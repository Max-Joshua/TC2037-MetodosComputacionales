#Joshua Ruben Amaya Camilo A01025258
#Andrea Yela González A01025250

defmodule Ej3 do
    @moduledoc """
    3. La función rotate-left toma dos entradas: un número entero n y una lista lst. Devuelve la lista que resulta
    de rotar lst un total de n elementos a la izquierda. Si n es negativo, rota hacia la derecha.
    """
      # Exercise 3

  @doc """
  The function rotate_left receives a list and n value
  The function rotates list left by n value
  """

  # Define the function
    def rotate_left([], n), do: [] # The list is empty, nor defp because it can identify an empty list
    def rotate_left(list, n) do    # Reverse the list received to generalize the entrant values
        if n < 0 do   # n value is negative
            do_rotate_left(Enum.reverse(list), n * -1, true)   # Reverse the list and make positive the n value
        else    # n value is positive
            do_rotate_left(list, n, false)   # Keep the list intact
        end
    end

  # Define base case
    defp do_rotate_left(list, 0, result) do    # Reverse or keep the list when n value reaches zero
        if result do    # The list have been reversed before
            Enum.reverse(list)   # Reverse the list
        else
            list   # Keep intact the list
        end
    end

    defp do_rotate_left([hd | tl], n, result) do    # The list contains values

        do_rotate_left(tl ++ [hd], n - 1, result)   # Append the head into tail n times and decrease n in 1

    end
end
