defmodule ElixirRavelry.Repo.MaterialFor do
  @moduledoc false

  alias ElixirRavelryWeb.{MaterialFor}

  def create(conn, %MaterialFor{end_node_id: end_node_id, start_node_id: start_node_id}) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (e) WHERE id(e) = {end_node_id}
         MATCH (s) WHERE id(s) = {start_node_id}
         CREATE (s)-[m:MATERIAL_FOR]->(e)
         RETURN m
         """,
         %{end_node_id: end_node_id, start_node_id: start_node_id}
       )
    |> return_to_material_for_list()
    |> hd()
  end

  def get(conn, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH ()-[m:MATERIAL_FOR]->()
         WHERE id(m) = toInteger({id})
         RETURN m
         """,
         %{id: id}
       )
    |> return_to_material_for_list()
    |> case do
         [] -> :error
         [material_for] -> {:ok, material_for}
       end
  end

  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH ()-[m:MATERIAL_FOR]->()
         RETURN m
         """
       )
    |> return_to_material_for_list()
  end

  def return_to_material_for_list(return) when is_list(return) do
    Enum.map(return, &return_to_material_for/1)
  end

  def return_to_material_for(%{"m" => %Bolt.Sips.Types.Relationship{"end": end_node_id, id: id, start: start_node_id, type: "MATERIAL_FOR"}}) do
    %MaterialFor{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "MaterialFor"},
        state: :loaded
      },
      id: id,
      start_node_id: start_node_id,
      end_node_id: end_node_id
    }
  end
end