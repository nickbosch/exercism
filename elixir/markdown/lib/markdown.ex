defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    # - rename `m` to `markdown`
    # - rename `t` to `line`
    # - change nested function calls to pipe operators
    # - change Enum.map / Enum.join to Enum.map_join
    markdown
    |> String.split("\n")
    |> Enum.map_join("", &process/1)
    |> wrap_lists()
  end

  # - rename `t` to `line`
  # - replace nested if statements / String.starts_with? with string pattern matching
  # - split `line` here as each sub-function performs a String.split or requires a
  #   list as input
  defp process(line = "#" <> _),
    do: String.split(line) |> parse_header_md_level() |> enclose_with_header_tag()

  defp process(line = "*" <> _), do: String.split(line) |> parse_list_md_level()
  defp process(line), do: String.split(line) |> enclose_with_paragraph_tag()

  defp parse_header_md_level([h | t]) do
    # - capture `h` and `t` with pattern matching
    {to_string(String.length(h)), Enum.join(t, " ")}
  end

  defp parse_list_md_level([_ | t]) do
    # - refactor entire method as String.split is no longer required
    # - capture `t` with pattern matching and discard `h` as it is the
    #   bullet point "* "
    # - replace concatenations with interpolation
    "<li>#{join_words_with_tags(t)}</li>"
  end

  defp enclose_with_header_tag({header_level, header_content}) do
    # - replace concatenations with interpolation
    # - rename `hl` to `header_level`
    # - rename `htl` to `header_content`
    "<h#{header_level}>#{header_content}</h#{header_level}>"
  end

  defp enclose_with_paragraph_tag(t) do
    "<p>#{join_words_with_tags(t)}</p>"
  end

  defp join_words_with_tags(words) do
    # - rename `t` to 'words'
    # - replace multiple function calls Enum.map_join
    Enum.map_join(words, " ", &replace_md_with_tag/1)
  end

  defp replace_md_with_tag(word) do
    # - rename `w` to 'word'
    # - replace nested function calls with pipe operators
    # - remove `replace_prefix_md` / `replace_suffix_md` functions
    # - replace cond from `replace_..._md` functions with chained String.replace
    # - simplify regex
    word
    |> String.replace(~r/^__/, "<strong>")
    |> String.replace(~r/^_/, "<em>")
    |> String.replace(~r/__$/, "</strong>")
    |> String.replace(~r/_$/, "</em>")
  end

  defp wrap_lists(html) do
    # - rename `l` to `html`
    # - change nested function calls to pipe operators
    # - remove unnecessary string concatenation
    # - change `replace` and `replace_suffix` to regex that handles 
    #   list items at any point in string (not just the start and end)
    html
    |> String.replace(~r/(?<!<\/li>)<li>/, "<ul><li>")
    |> String.replace(~r/<\/li>(?!<li>)/, "</li></ul>")
  end
end
