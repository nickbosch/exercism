defmodule ProteinTranslation do
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    rna
    |> String.graphemes()
    |> Enum.chunk_every(3)
    |> Enum.reduce_while({:ok, []}, fn codon, {status, acc} ->
      case codon |> Enum.join() |> of_codon() do
        {:ok, "STOP"} -> {:halt, {:ok, acc}}
        {:ok, protein} -> {:cont, {:ok, acc ++ [protein]}}
        {:error, _} -> {:halt, {:error, "invalid RNA"}}
      end
    end)
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) do
    cond do
      codon =~ ~r/^UG[UC]$/ -> {:ok, "Cysteine"}
      codon =~ ~r/^UU[AG]$/ -> {:ok, "Leucine"}
      codon =~ ~r/^AUG$/ -> {:ok, "Methionine"}
      codon =~ ~r/^UU[UC]$/ -> {:ok, "Phenylalanine"}
      codon =~ ~r/^UC[UCAG]$/ -> {:ok, "Serine"}
      codon =~ ~r/^UGG$/ -> {:ok, "Tryptophan"}
      codon =~ ~r/^UA[UC]$/ -> {:ok, "Tyrosine"}
      codon =~ ~r/^U(A[AG]|GA)$/ -> {:ok, "STOP"}
      true -> {:error, "invalid codon"}
    end
  end
end
