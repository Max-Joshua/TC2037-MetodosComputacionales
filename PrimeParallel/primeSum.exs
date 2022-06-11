defmodule Hw_Primes do

  def sum_primes_parallel(n) when n < 2, do: []
  def sum_primes_parallel(n, c) do

    chunk = div(n, c)

    1..c
    |> Task.async_stream(fn i -> sum_prime(((i - 1) * chunk) + 1, i * chunk) end, timeout: :infinity)
    |> Enum.map(fn {:ok, sum} -> sum end)
    |> Enum.sum

  end



  def search_prime(n) when n in[2, 3], do: true
  def search_prime(n) do
    sqrt= :math.sqrt(n)
      |> Float.floor
      |> round

    !Enum.any?(2..sqrt, &(rem(n, &1) == 0))

  end


  def sum_prime(fst, lst) do
    Enum.filter(fst..lst, &search_prime/1) |> Enum.sum
  end



end




Hw_Primes.sum_primes_parallel(4645434121, 8)
