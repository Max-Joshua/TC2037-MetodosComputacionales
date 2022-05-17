#Joshua Ruben Amaya Camilo A01025258
#Andrea Yela González A01025250




defmodule Ejer1 do
@moduledoc """
1. La función insert toma dos entradas: un número n y una lista lst que contiene números en orden ascendente.
Devuelve una nueva lista con los mismos elementos de lst pero con n insertado en su lugar correspondiente.
"""
    def insert(n,lst), do: do_insertlst(n,lst, [])
    defp do_insertlst(n,[], newlst), do: [n] #Lista vacía 
    defp do_insertlst(n, [head | tail], newlst) when n > head, #Cuando el numero es mayor al primer dato de la lista
        do: do_insertlst(n, tail, [head | newlst]) #Avanza hasta el siguiente valor
    defp do_insertlst(n, [head | tail], newlst) when (n in newlst), #Si el numero esta en la lista
        do: do_insertlst(n, tail, [head | newlst]) #Avanza al siguiente valor
    defp do_insertlst(n, [head | tail], newlst), 
        do: do_insertlst(n, tail, [head |[n | newlst]]) #Agrega el valor a la lista
end

# @doc """
# 2. La función insertion-sort toma una lista desordenada de números como entrada y devuelve una nueva lista
# con los mismos elementos pero en orden ascendente. Se debe usar la funci ́on de insert definida en el ejercicio
# anterior para escribir insertion-sort. No se debe utilizar la función sort o alguna similar predefinida.
# """
