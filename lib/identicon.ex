defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  @doc """
  ## Examples
      iex> Identicon.main("adios")
      "Has dicho: adios"
  """
  def main(input) do
    input
    |> hash_function
    |> pick_color
    |> build_grid
    |> filter_odd
  end

  @doc """
  Recibe el texto y genera una función hash
  """
  def hash_function(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r,g,b | _tail]} = image) do
    %Identicon.Image{image | color: {r,g,b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  def filter_odd (%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn({code, _index}) -> rem(code, 2) == 0 end)

    %Identicon.Image{image | grid: grid}
  end

end
