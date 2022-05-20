defmodule Tlist do
  def read(in_filename, out_filename) do
    data = File.stream!(in_filename) #Lista de renglones

    #Using pipe operator to link the calls
    text =
        in_filename
        |>File.stream!()
        |>Enum.map(&changeKeys/1)
        |>Enum.map(&replaceString/1)
        |>Enum.map(&replaceBool/1)
        |>Enum.map(&replaceNumber/1)
        |>Enum.map(&replaceParentesisStart/1)
        |>Enum.map(&replaceParentesisEnd/1)
        |>Enum.map(&revertKeys/1)
        |>Enum.map(&replaceNewlines/1)
        |>Enum.filter(&(&1 != nil))

    data2 = File.stream!("base.html") #Lista de renglones

    #Using pipe operator to link the calls
    text2 =
        "base.html"
        |>File.stream!()
        |>Enum.filter(&(&1 != nil))

    File.write(out_filename, [text2, text, "</p>\n</body>\n</html>"])
  end

  def changeKeys(line), do: Regex.replace(~r/"(.+)":/, line, "<keyS>\\1<keyE>")

  def revertKeys(line), do:
    Regex.replace(~r/<keyE>/, Regex.replace(~r/<keyS>/, line, "<span class=\"keys\">\""), "\"</span>:")

  def replaceString(line) do
    # replace all strings with necessary
    Regex.replace(~r/""/, Regex.replace(~r/"(.+)"/, line, "<span class=\"string\">\"\\1\"</span>"), "<span class=\"string\">\"\"</span>")
  end

  def replaceBool(line) do
    # replace all bool with necessary
    Regex.replace(~r/(true|false|null)/, line, "<span class=\"bool\">\\1</span>")
  end

  def replaceParentesisStart(line) do
    # replace all parentesis { with necessary
    Regex.replace(~r/(\[|\{)/, line, "<div class=\"indent\"><span class=\"parentesis\">\\1</span>")
  end

  def replaceParentesisEnd(line) do
    # replace all parenthesis } with necessary
    Regex.replace(~r/(\]|\})/, line, "<span class=\"parentesis\">\\1</span></div>")
  end

  def replaceNewlines(line) do
    # replace all lines with an enter in html
    Regex.replace(~r/\n/, line, "<br>")
  end

  def replaceNumber(line) do
    Regex.replace(~r/( )(\d+.\d+|\d+)(,| |\n|\}|\])/, line, "\\1<span class=\"number\">\\2</span>\\3")
  end

  # def replaceTabs(line) do
  #   # replace all strings with necessar
  #   Regex.replace(~r/\t/, line, "    ")
  # end

end
