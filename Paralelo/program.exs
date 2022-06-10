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


  def inicio([hd | tl]), do:
    case hd do
      "[" -> inicioCorchete(tl, "", "") #Primer elemento es [
      "{" -> inicioLlave(tl, "", "") #Primer elemento es {
       _ -> inicio(tl) #No hay nada
  end

#Build - archivo html (lo que se está esccribiendo)
#estado - Para saber en que modo estas

#Corchete
#Agrega el corchete al build
  def inicioCorchete([hd | tl], build, estado) do
    buscarDato(tl, Enum.join([build, "<span class=\"parentesis\">[</span><br>"]), ["[" | estado])
  end

  #Agrega el final del corchete en el build
  def finalCorchete([_ | tl], build, [_ | estado]) do
    [sigEstado | _] = estado
      case sigEstado do
        "[" -> sigDatoCorchete(tl, Enum.join([build, "<class=\"parentesis\">]</span><br>"]), estado)
        "{" -> sigDatoLlave(tl, Enum.join([build, "<class=\"parentesis\">]</span><br>"]), estado)
      end
  end

  #Busca que dato sigue despues del Corchete
  def sigDatoCorchete([hd | tl], build, estado) do
    case hd do
      #Va a buscar que tipo de dato es
      "," -> buscarDatoCorchete(tl, Enum.join([build, hd, "<br>"]), estado)
      #Finaliza el corchete
      "]" -> finalCorchete([hd | tl], build, estado)
      #No hay nada (posiblemente hay un espacio)
      _ -> sigDatoCorchete(tl, build, estado)
    end
  end

  def buscarDatoCorchete([hd | tl], build) do
    case hd do
      hd == "[" -> inicioCorchete(tl, build, estado)
      hd == "{" -> inicioLlave(tl, build, estado)
      hd == "\""-> datoStringCorchete(tl, Enum.join([build, "<span class=\"string\">\""]), estado)
      hd == "]" -> finalCorchete(tl, build)
      Regex.match?(~r/^\d$/, hd) -> datoIntCorchete([hd | tl], Enum.join([build, "<span class=\"number\">"]), estado)
      Regex.match?(~r/[truefalsn]/, hd) -> datoBoolCorchete([hd | tl], Enum.join([build, "<span class=\"bool\">"]), estado)
      hd == _ -> buscarDatoCorchete(tl, build)
    end
  end

  def datoIntCorchete([hd | tl], build, estado) do
    cond do
      Regex.match?(~r/^\d$/, hd) -> datoIntCorchete(tl, Enum.join([build, hd]), estado)
      hd == "." -> datoFloatCorchete(tl, Enum.join([build, hd]), estado)
      true -> sigDatoCorchete([hd | tl], Enum.join([build, "</span>"]), estado)
    end
  end

  def datoFloatCorchete([hd | tl], build, estado) do
    cond do
      Regex.match?(~r/^\d$/, hd) -> modoFloat(tl, Enum.join([build, hd]), estado)
      true -> modoIterarCorchete([hd | tl], Enum.join([build, "</span>"]), estado)
    end
  end

  def datoBoolCorchete([hd | tl], build, stack) do
    cond do
      Regex.match?(~r/[truefalsn]/, hd) -> datoBoolCorchete(tl, Enum.join([build, hd]), estado)
      true -> sigDatoCorchete([hd | tl], Enum.join([build, "</span>"]), estado)
    end
  end

  def datoStringCorchete([hd | tl], build) do
    case hd do
      "\""-> modoValor(tl, Enum.join([build, hd, "</span>"]), estado)
      _ -> sigDatoCorchete(tl, Enum.join([build, hd]), estado)
  end

#Llave

