defmodule Tello.MixProject do
  use Mix.Project

  def project do
    [
      app: :tello,
      version: "0.1.0",
      elixir: "~> 1.13",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Tello",
      source_url: "https://github.com/linjunpop/tello",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Tello.Application, []}
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.28", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Tello SDK in Elixir"
  end

  defp package do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/linjunpop/tello"}
    ]
  end

  def docs do
    [
      main: "Tello",
      groups_for_modules: [
        Client: ~r/Tello.Client/,
        "Cyber Tello": ~r/Tello.CyberTello/
      ],
      before_closing_body_tag: &before_closing_body_tag/1,
      extras: [
        "LAB.livemd"
      ]
    ]
  end

  defp before_closing_body_tag(:html) do
    """
    <script src="https://cdn.jsdelivr.net/npm/mermaid@9.1.3/dist/mermaid.min.js"></script>
    <script>
      document.addEventListener("DOMContentLoaded", function () {
      mermaid.initialize({ startOnLoad: false });
      let id = 0;
      for (const codeEl of document.querySelectorAll("pre code.mermaid")) {
        const preEl = codeEl.parentElement;
        const graphDefinition = codeEl.textContent;
        const graphEl = document.createElement("div");
        const graphId = "mermaid-graph-" + id++;
        mermaid.render(graphId, graphDefinition, function (svgSource, bindListeners) {
          graphEl.innerHTML = svgSource;
          bindListeners && bindListeners(graphEl);
          preEl.insertAdjacentElement("afterend", graphEl);
          preEl.remove();
        });
      }
      });
    </script>
    """
  end

  defp before_closing_body_tag(_), do: ""
end
