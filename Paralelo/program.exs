defmodule Tlist do
  def read(in_filename, out_filename) do
    data = File.stream!(in_filename) #Lista de renglones

    #Using pipe operator to link the calls
    text =
        in_filename
        |>File.stream!()
        |>Enum.filter(&(&1 != nil))

    data2 = File.stream!("base.html") #Lista de renglones

    #Using pipe operator to link the calls
    text2 =
        "base.html"
        |>File.stream!()
        |>Enum.filter(&(&1 != nil))

    File.write(out_filename, [text2, text, "</p>\n</body>\n</html>"])
  end


  def stateStart([hd | tl]), do:
    case hd do
      "[" -> modoCorchete(tl, "")
      "{" -> modoLlave(tl, "")
  end

  def modoCorchete([hd | tl], build) do
    modoValor(tl, Enum.join([build, "<span class=\"parentesis\">[</span><br>"]))
  end

  def modoCorcheteF([hd | tl], build) do
    modoValor(tl, Enum.join([build, "<class=\"parentesis\">]</span><br>"]))
  end

  def modoIterarCorchete([hd | tl], build) do
    case hd do
      "," -> modoCorchete(tl, Enum.join([build, hd, "<br>"]))
      "]" -> modoCorcheteF(tl, build)
      _ -> modoIterar(tl, build)
  end

  def modoString([hd | tl], build) do
    case hd do
      "\""-> modoValor(tl, Enum.join([build, hd, "</span>"]))
      _ -> modoString(tl, Enum.join([build, hd]))
  end

  def modoValor([hd | tl], build) do
    case hd do
      "[" -> modoCorchete(tl, build)
      "{" -> modoLlave(tl, build)
      "\""-> modoString(tl, Enum.join([build, "<span class=\"string\">\""]))
      "]" -> modoCorcheteF(tl, build)
      _ -> modoValor(tl, build)
  end

  def modoLlave([hd | tl], build) do
    modoValor(tl, Enum.join([build, "<span class=\"parentesis\">{</span><br>"]))
  end

  def modoLlaveF([hd | tl], build) do
    modoValor(tl, Enum.join([build, "<span class=\"parentesis\">}</span><br>"]))
  end
  
  def modoLlaveS([hd | tl], build) do

  end
end
