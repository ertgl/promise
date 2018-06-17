defmodule Promise.Test do
	
	use ExUnit.Case,
		async: true

	alias Promise.Test.UserRepository
	
	doctest Promise

	test "resolves promise" do
		assert Promise.new(UserRepository, :get, [1])
		|> Promise.then(fn user -> user.username end)
		|> Promise.resolve() == "ertgl"

		assert Promise.new(fn -> {:resolve, UserRepository.get(1)} end)
		|> Promise.then(fn user ->
			case user do
				%{is_active?: false} = user ->
					{:reject, {:inactive, user}}
				user ->
					{:resolve, user}
			end
		end)
		|> Promise.then(fn user -> user.username end)
		|> Promise.resolve() == {:inactive, %{username: "ertgl", is_active?: false}}

		assert Promise.new(fn -> UserRepository.get(2) end)
		|> Promise.then(fn user -> user.username end)
		|> Promise.resolve() == {:error, :not_found}

		assert Promise.new(fn -> {:resolve, UserRepository.get(3)} end)
		|> Promise.then(fn
			{:error, :not_found} ->
				:ok
			user when is_map(user) ->
				user.username
			user ->
				{:reject, user}
		end)
		|> Promise.resolve() == :ok
	end

end
