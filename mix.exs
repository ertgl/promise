defmodule Promise.MixProject do
	
	use Mix.Project

	@version "0.1.0"

	@github_url "https://github.com/ertgl/promise"

	def project() do
		[
			app: :promise,
			version: @version,
			description: """
			Promise implementation in Elixir.
			""",
			elixir: "~> 1.6",
			elixirc_paths: __MODULE__.elixirc_paths(Mix.env()),
			start_permanent: Mix.env() == :prod,
			deps: __MODULE__.deps(),
			docs: __MODULE__.docs(),
			package: __MODULE__.package(),
		]
	end

	def package() do
		[
			maintainers: [
				"Ertuğrul Keremoğlu <ertugkeremoglu@gmail.com>",
			],
			licenses: [
				"MIT",
			],
			files: [
				"lib",
				".formatter.exs",
				"mix.exs",
				"LICENSE.txt",
				"README.md",
			],
			links: %{
				"GitHub" => @github_url,
			},
		]
	end

	def docs() do
		[
			name: "Promise",
			source_ref: "v#{@version}",
			source_url: @github_url,
			main: "Promise",
		]
	end

	# Run "mix help compile.app" to learn about applications.
	def application() do
		[
			mod: {Promise.Application, []},
			extra_applications: [
				:logger,
			],
		]
	end

	def elixirc_paths() do
		[
			"lib",
		]
	end

	def elixirc_paths(:test) do
		__MODULE__.elixirc_paths()
		++
		[
			"test/support",
		]
	end

	def elixirc_paths(_env) do
		__MODULE__.elixirc_paths()
	end

	# Run "mix help deps" to learn about dependencies.
	def deps() do
		[
			{:ex_doc, "~> 0.16", only: :dev, runtime: false},
		]
	end

end
