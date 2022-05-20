defmodule Evidencia1 do
    def evidencia1(filein, fileout) do
        data = File.stream!(filein) #Lista de renglones

        #Using pipes
        example =
            filein
            |> File.stream!() #reads the file and returns a list of rows where the program has to check if there is an email
            # |> Enum.map(&example_from_line/1) #llamas a una funcion que hace que el archivo json se convierta en html. email_from_line the /1 element means that the function takes 1 , 1 row of the array.
            |> Enum.map(&regexNewLine/1)
            |> Enum.map(&regexString/1)
            |> Enum.map(&regexInt/1)
            |> IO.inspect() #debugger para que se vaya a la consola

        #Create the new file
        File.write(fileout, example)
    end

    def regexNewLine(file) do
        Regex.replace(~r/\n/, file, "<br>")#Para los espacios de código
    end

    def regexString(string) do # remplazo para los strings

        Regex.replace(~r/"([^"]+)"/, string, "<span class=\"string\">\"\\1\"</span>")
        # que ponga al inicio <span class="string"> y al final </span> utilizamos este para que tome todo lo que estña dentro de las comillas excepto las comillas
    end

    def regexInt(file) do #remplazo de números (int)
        Regex.replace(~r/(\d+)/, file, "<span class=\"int\">\\1</span>")
    end

    def regexLlave(file) do #remplazo de llave
        Regex.replace(~r/({|})/, file, "<span class=\"llave\">\\1</span>")
    end

    def regexCorchete(file) do #remplazo de corchete
        Regex.replace(~r/([|])/, file, "<span class=\"corchete\">\\1</span>")
    end
end

Evidencia1.evidencia1("ejemplo2.json", "output.html")
