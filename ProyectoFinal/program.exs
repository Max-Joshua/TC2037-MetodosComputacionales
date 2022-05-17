defmodule Tlist do
  def read(in_filename, out_filename) do
    data = File.stream!(in_filename) #Lista de renglones

    #Using pipe operator to link the calls
    text =
        in_filename
        |>File.stream!()
        |>Enum.map(&String.split/1)
        |>Enum.join("\n")

    File.write(out_filename, text)
  end
end
