#Joshua Ruben Amaya Camilo A01025258
#Andrea Yela González A01025250
#13 de mayo 2020

defmodule Actividad2_2.Actividad22Test do
  use ExUnit.Case
  alias Actividad2_2.Actividad22

  # Functions
  #Ejercicio 1
  test "test insert" do
    assert Actividad22.insert([], 14) == [14]
    assert Actividad22.insert([5, 6, 7, 8], 4) == [4, 5, 6, 7, 8]
    assert Actividad22.insert([1, 3, 6, 7, 9, 16], 5) == [1, 3, 5, 6, 7, 9, 16]
    assert Actividad22.insert([1, 5, 6], 10) == [1, 5, 6, 10]
  end
  #Ejercicio 2
  test "test insertion_sort" do
    assert Actividad22.insertion_sort([]) == []
    assert Actividad22.insertion_sort([4, 3, 6, 8, 3, 0, 9, 1, 7]) == [0, 1, 3, 3, 4, 6, 7, 8, 9]
    assert Actividad22.insertion_sort([1, 2, 3, 4, 5, 6]) == [1, 2, 3, 4, 5, 6]
    assert Actividad22.insertion_sort([5, 5, 5, 1, 5, 5, 5]) == [1, 5, 5, 5, 5, 5, 5]
  end
  #Ejercicio 3
  test "test rotate_left" do
    assert Actividad22.rotate_left([], 5) == []
    assert Actividad22.rotate_left([:a, :b, :c, :d, :e, :f, :g], 0) == [:a, :b, :c, :d, :e, :f, :g]
    assert Actividad22.rotate_left([:a, :b, :c, :d, :e, :f, :g], 1) == [:b, :c, :d, :e, :f, :g, :a]
    assert Actividad22.rotate_left([:a, :b, :c, :d, :e, :f, :g], -1) == [:g, :a, :b, :c, :d, :e, :f]
    assert Actividad22.rotate_left([:a, :b, :c, :d, :e, :f, :g], 3) == [:d, :e, :f, :g, :a, :b, :c]
    assert Actividad22.rotate_left([:a, :b, :c, :d, :e, :f, :g], -3) == [:e, :f, :g, :a, :b, :c, :d]
    assert Actividad22.rotate_left([:a, :b, :c, :d, :e, :f, :g], 8) == [:b, :c, :d, :e, :f, :g, :a]
    assert Actividad22.rotate_left([:a, :b, :c, :d, :e, :f, :g], -8) == [:g, :a, :b, :c, :d, :e, :f]
    assert Actividad22.rotate_left([:a, :b, :c, :d, :e, :f, :g], 45) == [:d, :e, :f, :g, :a, :b, :c]
    assert Actividad22.rotate_left([:a, :b, :c, :d, :e, :f, :g], -45) == [:e, :f, :g, :a, :b, :c, :d]
  end
  #Ejercicio 10
  test "test encode" do
    assert Actividad22.encode([]) == []
    assert Actividad22.encode([:a]) == [{1, :a}]

    assert Actividad22.encode([:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e]) ==
             [{4, :a}, {1, :b}, {2, :c}, {2, :a}, {1, :d}, {4, :e}]

    assert Actividad22.encode([1, 2, 3, 4, 5]) == [{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}]
    assert Actividad22.encode([9, 9, 9, 9, 9]) == [{5, 9}]
  end

end
