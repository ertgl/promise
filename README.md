Promise implementation in Elixir.

[![Hex Version](https://img.shields.io/hexpm/v/promise.svg?style=flat-square)](https://hex.pm/packages/promise) [![Docs](https://img.shields.io/badge/api-docs-orange.svg?style=flat-square)](https://hexdocs.pm/promise) [![Hex downloads](https://img.shields.io/hexpm/dt/promise.svg?style=flat-square)](https://hex.pm/packages/promise) [![GitHub](https://img.shields.io/badge/vcs-GitHub-blue.svg?style=flat-square)](https://github.com/ertgl/promise) [![MIT License](https://img.shields.io/hexpm/l/promise.svg?style=flat-square)](LICENSE.txt)

---

</br>

**`Installation`**


The package is [available in Hex](https://hex.pm/packages/promise), it can be installed
by adding `:promise` to your list of dependencies in `mix.exs`:

```elixir
def application() do
	[
		extra_applications: [
			:promise,
		],
	]
end

def deps() do
	[
		{:promise, "~> 0.1.0"},
	]
end
```

</br>
