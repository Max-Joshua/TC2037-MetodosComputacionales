#Joshua Ruben Amaya Camilo A01025258
#Andrea Yela González A01025250
#13 de mayo 2020

defmodule Actividad2_2.Actividad22 do
  @moduledoc """
  Funtions to wotk with lists in Elixir
  """

  # Exercise 1

  @doc """
  Function that receives two elements, a number "n" and a list "lst" with ascendant numbers.
  Return a new lst with the inserted element "n" in it's correct place
  """

  # Define the function
  def insert(list, n), do: do_insert(list, n, [])

  # Define base case
  defp do_insert([], n, result) do    # When receives an empty list

    if n in result do   # The element is in the list
      Enum.reverse(result)    # Return the reversed value

    else    # The element is not in the list
      Enum.reverse([n | result])    # Add n and return the list reversed

    end

  end

  defp do_insert([hd | tl], n, result) do     # The list contains values

    if hd < n do   # If head is less than n value
      do_insert(tl, n, [hd | result])

    else    # If head is greater than n value

      if n in result do   # The list contains n value
        do_insert(tl, n, [hd | result])   # Compare the next value

      else    # The list doesn't contain n value
        do_insert(tl, n, [hd | [n | result]])   # Append n value

      end

    end

  end



  # Exercise 2

  @doc """
  The function insertion_sort receives a list
  The function sorts a list from smallest to largest value
  """

  # Define function
  def insertion_sort(list), do: do_insertion_sort(list, [])

  # Define base case
  defp do_insertion_sort([], compile), do: compile    # If the list is empty, return the list
  defp do_insertion_sort([hd | tl], compile) do    # The list contains values

    do_insertion_sort(tl, insert(compile, hd))    # Calls insert function and calls recursively

  end



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



  # Exercise 10

  @doc """
  Encode function :)
  """
  def encode([]), do: [] #If there is no value return nothing
  def encode(list), do: do_encode(list, nil, 0, []) #If the list is empty return list

  defp do_encode([], hdp, n, return), do: Enum.reverse([{n, hdp} | return])
  defp do_encode([hd | tl], hdp, n, return) do
    if hd == hdp do #if the previus value is the same as head
      do_encode(tl, hdp, n + 1, return) #you move to the next value and add 1 to counter
    else
      if hdp == nil do #if its the first value
        do_encode(tl, hd, 1, return) #look for the tail and begin the process
      else
        do_encode(tl, hd, 1, [{n, hdp} | return]) #when the list only has 1 value
      end
    end
  end



end

