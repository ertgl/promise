defmodule Promise.Test.UserRepository do

	def all() do
		%{
			1 => %{
				username: "ertgl",
				is_active?: false,
			},
		}
	end

	def get(id) do
		Map.get(__MODULE__.all(), id, {:error, :not_found})
	end

end
