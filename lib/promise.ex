defmodule Promise do
	@moduledoc File.read!("README.md")

	@type t :: %Promise{}

	defstruct [
		chain: nil,
		on_error: nil,
	]

	@doc ~S"""
	Returns a new Promise struct.

	## Examples

		Promise.new({UserRepository, :all})

		Promise.new({UserRepository, :get, [1]})

		Promise.new(fn -> UserRepository.get(1) end)

		Promise.new(fn ->
			case UserRepository.get(1) do
				%{is_active: false} = user ->
					{:reject, user}
				user ->
					{:resolve, user}
			end
		end)
	"""
	@spec new(on_execution :: function | {module, atom} | {module, atom, [any]}) :: Promise.t
	@since "0.1.0"
	def new(on_execution)
	when
	is_function(on_execution)
	or
	(is_tuple(on_execution) and (tuple_size(on_execution) == 2 or tuple_size(on_execution) == 3))
	do
		%__MODULE__{
			chain: [
				on_execution,
			],
			on_error: (fn error -> error end),
		}
	end

	@doc ~S"""
	Returns a new Promise struct.
	
	## Examples

		Promise.new(UserRepository, :all)

		Promise.new(UserRepository, :get, [1])
	"""
	@spec new(mod :: atom, fun :: atom, args :: [any]) :: Promise.t
	@since "0.1.0"
	def new(mod, fun, args \\ [])
	when is_atom(mod)
	when is_atom(fun)
	when is_list(args)
	do
		__MODULE__.new({mod, fun, args})
	end

	@doc ~S"""
	Appends function into `promise` chain.
	
	## Examples

		Promise.new(UserRepository, :all)
		|> Promise.then(fn users -> IO.inspect users end)
	"""
	@spec then(promise :: Promise.t, on_resolve :: function | {module, atom}) :: Promise.t
	@since "0.1.0"
	def then(%__MODULE__{chain: chain} = promise, on_resolve)
	when
	is_function(on_resolve)
	or
	is_tuple(on_resolve) and tuple_size(on_resolve) == 2
	do
		%__MODULE__{
			promise | chain: chain ++ [on_resolve]
		}
	end

	@doc ~S"""
	Changes `on_error` callback of `promise`.

	## Default

		fn error -> error end
	
	## Examples

		Promise.new(UserRepository, :all)
		|> Promise.then(fn users -> IO.inspect users end)
		|> Promise.on_error(fn error -> IO.inspect(error) end)
	"""
	@spec on_error(promise :: Promise.t, on_error :: function | {module, atom}) :: Promise.t
	@since "0.1.0"
	def on_error(%__MODULE__{} = promise, on_error)
	when is_function(on_error)
	or
	is_tuple(on_error) and tuple_size(on_error) == 2
	do
		%__MODULE__{
			promise | on_error: on_error
		}
	end

	@doc ~S"""
	Resolves `promise`.
	
	## Examples

		Promise.new(UserRepository, :all)
		|> Promise.then(fn users -> IO.inspect users end)
		|> Promise.on_error(fn error -> IO.inspect(error) end)
		|> Promise.resolve()
	"""
	def resolve(%__MODULE__{chain: chain} = promise) do
		try do
			chain
			|> Enum.with_index()
			|> Enum.reduce_while(nil, fn {next, next_id}, acc ->
				result = cond do
					next_id == 0 ->
						case next do
							{mod, fun} ->
								apply(mod, fun, [])
							{mod, fun, args} ->
								apply(mod, fun, args)
							fun ->
								apply(fun, [])
						end
					true ->
						case next do
							{mod, fun} ->
								apply(mod, fun, [acc])
							fun ->
								apply(fun, [acc])
						end
				end
				case result do
					{:reject, error} ->
						{:halt, __MODULE__.reject(promise, error)}
					{:resolve, result} ->
						{:cont, result}
					result ->
						cond do
							result == :error ->
								{:halt, __MODULE__.reject(promise, result)}
							is_tuple(result) && tuple_size(result) >= 1 && elem(result, 0) == :error ->
								{:halt, __MODULE__.reject(promise, result)}
							true ->
								{:cont, result}
						end
				end
			end)
		catch
			error ->
				__MODULE__.reject(promise, error)
		end
	end

	@doc ~S"""
	Rejects `promise` with specified `error`.
	
	## Examples

		Promise.new(UserRepository, :all)
		|> Promise.then(fn users -> IO.inspect users end)
		|> Promise.on_error(fn error -> IO.inspect(error) end)
		|> Promise.resolve()
	"""
	def reject(%__MODULE__{on_error: on_error} = _promise, error) do
		case on_error do
			{mod, fun} ->
				apply(mod, fun, [error])
			fun ->
				apply(fun, [error])
		end
	end

end
