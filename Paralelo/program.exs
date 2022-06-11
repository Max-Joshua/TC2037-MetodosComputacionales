defmodule Tlist do

  def paralelismo(pathFolder, nuevoFolder)do
  #Encuentra el directorio
    File.mkdir_p!(Path.dirname("#{nuevoFolder}"))
  #Crea un archivo con el mismo nombre del .json pero ahora con .html
  #COn spawn se manda a llamar la funcion read
    for jasons <- pathFolder do
      spawn(Tlist, :read, [jasons, Enum.join([nuevoFolder, "/", Regex.replace(~r/.+\/(.+)\.json/, jasons, "\\1.html")])])
    end
  end

  def read(in_filename, out_filename) do
    #Calcula el tiempo de ejecución
    time = Time.utc_now()

  #Divide nuestro archivo json en secciones para ejecutar el programa
    text = inicio(String.split(File.read!(in_filename), ""))


    text2 = File.read!("base.html")
  #Calcula el tiempo transcurrido
    tiempoFinal = Time.diff(Time.utc_now(), time, :millisecond)

    IO.puts("Archivo #{in_filename} se creo en (#{tiempoFinal}ms)")
    File.write(out_filename, "#{text2}#{text}\n</p>\n</body>\n</html>")
  end


  def inicio([hd | tl]) do
    case hd do
      "[" -> inicioCorchete(tl, "", "") #Primer elemento es [
      "{" -> inicioLlave(tl, "", "") #Primer elemento es {
       _ -> inicio(tl) #No hay nada
    end
  end

#Build - archivo html (lo que se está esccribiendo)
#estado - Para saber en que modo estas

#Corchete
#Agrega el corchete al build
  def inicioCorchete([hd | tl], build, estado) do
    buscarDatoCorchete(tl, Enum.join([build, "<span class=\"parentesis\">[</span><br><div class=\"indent\">"]), ["[" | estado])
  end

  #Agrega el final del corchete en el build

  def finalCorchete([], build, _), do: build
  def finalCorchete(_, build, [_ | ""]) do
    Enum.join([build, "</div><span class=\"parentesis\">}</span><br>"])
  end
  def finalCorchete([_ | tl], build, [_ | estado]) do
    [sigEstado | _] = estado
      case sigEstado do
        "[" -> sigDatoCorchete(tl, Enum.join([build, "<class=\"parentesis\">]</span><br><div class=\"indent\">"]), estado)
        "{" -> sigDatoLlave(tl, Enum.join([build, "<class=\"parentesis\">]</span><br><div class=\"indent\">"]), estado)
      end
  end

  #Busca que dato sigue despues del Corchete
  def sigDatoCorchete(_, build, []), do: build
  def sigDatoCorchete([], build, _), do: build
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

#Encontrar que tipo de dato esta despues del corchete
  def buscarDatoCorchete([], build, _), do: build
  def buscarDatoCorchete([hd | tl], build, estado) do
    cond do
      hd == "[" -> inicioCorchete(tl, build, estado)#Es un corchete
      hd == "{" -> inicioLlave(tl, build, estado) #Es una llave
      hd == "]" -> finalCorchete(tl, build, estado)#Cierra un corchete
      hd == "\""-> datoStringCorchete(tl, Enum.join([build, "<span class=\"string\">\""]), estado) #
      Regex.match?(~r/^\d$/, hd) -> datoIntCorchete([hd | tl], Enum.join([build, "<span class=\"number\">"]), estado)
      Regex.match?(~r/[truefalsn]/, hd) -> datoBoolCorchete([hd | tl], Enum.join([build, "<span class=\"bool\">"]), estado)
      true -> buscarDatoCorchete(tl, build, estado)
    end
  end

  #El dato es un string
  def datoStringCorchete([hd | tl], build, estado) do
      case hd do
        "\""-> buscarDatoCorchete(tl, Enum.join([build, hd, "</span>"]), estado)
        _ -> sigDatoCorchete(tl, Enum.join([build, hd]), estado)
      end
  end

  #El dato es un int: numero
  def datoIntCorchete([hd | tl], build, estado) do
    cond do
      Regex.match?(~r/^\d$/, hd) -> datoIntCorchete(tl, Enum.join([build, hd]), estado)
      #Si encuentra un punto es un Float y se para a Float
      hd == "." -> datoFloatCorchete(tl, Enum.join([build, hd]), estado)
      true -> sigDatoCorchete([hd | tl], Enum.join([build, "</span>"]), estado)
    end
  end

#El dato es un float: numero decimal
  def datoFloatCorchete([hd | tl], build, estado) do
    cond do
      Regex.match?(~r/^\d$/, hd) -> datoFloatCorchete(tl, Enum.join([build, hd]), estado)
      true -> sigDatoCorchete([hd | tl], Enum.join([build, "</span>"]), estado)
    end
  end
#El dato es un booleano: true or false
  def datoBoolCorchete([hd | tl], build, estado) do
    cond do
      Regex.match?(~r/[truefalsn]/, hd) -> datoBoolCorchete(tl, Enum.join([build, hd]), estado)
      true -> sigDatoCorchete([hd | tl], Enum.join([build, "</span>"]), estado)
    end
  end



#Llave (El nuevo estado es llave)
#Son las mismas funciones que en el estado de corchete
  def inicioLlave(tl, build, estado) do
    datoKeyLlave(tl, Enum.join([build, "<span class=\"parentesis\">[</span><br><div class=\"indent\">"]), ["[" | estado])
  end

  def finalLlave([], build, _), do: build
  def finalCorchete(_, build, [_ | ""]) do
    Enum.join([build, "</div><span class=\"parentesis\">}</span><br>"])
  end
  def finalLlave([_ | tl], build, [_ | estado]) do
    [sigEstado | _] = estado
    case sigEstado do
      "[" -> sigDatoCorchete(tl, Enum.join([build, "</div><span class=\"parentesis\">}</span><br><div class=\"indent\">"]), estado)
      "{" -> sigDatoLlave(tl, Enum.join([build, "</div><span class=\"parentesis\">}</span><br><div class=\"indent\">"]), estado)
    end
  end

  def sigDatoLlave(_, build, []), do: build
  def sigDatoLlave([], build, _), do: build
  def sigDatoLlave([hd | tl], build, estado) do
    case hd do
      "," -> datoKeyLlave(tl, Enum.join([build, hd, "<br><span class=\"keys\">"]), estado)
      "}" -> finalLlave([hd | tl], build, estado)
      _ -> sigDatoLlave(tl, build, estado)
    end
  end

  def buscarDatoLlave([], build, _), do: build
  def buscarDatoLlave([hd | tl], build, estado) do
    cond do
      hd == "[" -> inicioCorchete(tl, build, estado)
      hd == "{" -> inicioLlave(tl, build, estado)
      hd == "}" -> finalLlave(tl, build, estado)
      hd == "\""-> datoStringLlave(tl, Enum.join([build, "<span class=\"string\">\""]), estado)
      Regex.match?(~r/^\d$/, hd) -> datoIntLlave([hd | tl], Enum.join([build, "<span class=\"number\">"]), estado)
      Regex.match?(~r/[truefalsn]/, hd) -> datoBoolLlave([hd | tl], Enum.join([build, "<span class=\"bool\">"]), estado)
      true -> buscarDatoLlave(tl, build, estado)
    end
  end

  #El dato es una key
  def datoKeyLlave([hd | tl], build, estado) do
    case hd do
      ":" -> buscarDatoLlave(tl, Enum.join([build, ":</span> "]), estado)
      "}" -> finalLlave(tl, Enum.join([build, "</span>"]), estado)
      _ -> datoKeyLlave(tl, Enum.join([build, hd]), estado)
    end
  end

  def datoStringLlave([hd | tl], build, estado) do
    case hd do
      "\""-> buscarDatoLlave(tl, Enum.join([build, hd, "</span>"]), estado)
      _ -> sigDatoLlave(tl, Enum.join([build, hd]), estado)
    end
  end

  def datoIntLlave([hd | tl], build, estado) do
    cond do
      Regex.match?(~r/^\d$/, hd) -> datoIntLlave(tl, Enum.join([build, hd]), estado)
      hd == "." -> datoFloatLlave(tl, Enum.join([build, hd]), estado)
      true -> sigDatoLlave([hd | tl], Enum.join([build, "</span>"]), estado)
    end
  end

  def datoFloatLlave([hd | tl], build, estado) do
    cond do
      Regex.match?(~r/^\d$/, hd) -> datoFloatLlave(tl, Enum.join([build, hd]), estado)
      true -> sigDatoLlave([hd | tl], Enum.join([build, "</span>"]), estado)
    end
  end

  def datoBoolLlave([hd | tl], build, estado) do
    cond do
      Regex.match?(~r/[truefalsn]/, hd) -> datoBoolCorchete(tl, Enum.join([build, hd]), estado)
      true -> sigDatoLlave([hd | tl], Enum.join([build, "</span>"]), estado)
    end
  end


end
