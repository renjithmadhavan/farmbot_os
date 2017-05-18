defmodule Farmbot.CeleryScript.Ast.Context do
  @moduledoc """
    Context serves as an execution sandbox for all CeleryScript
  """

  alias Farmbot.CeleryScript.Ast

  @enforce_keys [:auth, :database, :network, :serial]
  defstruct     [:auth, :database, :network, :serial, data_stack: []]

  @typedoc false
  @type database  :: Farmbot.Database.database

  @typedoc false
  @type auth      :: Farmbot.Auth.auth

  @typedoc false
  @type network   :: Farmbot.System.Network.netman

  @typedoc false
  @type serial    :: Farmbot.Serial.Handler.handler

  @typedoc """
    Stuff to be passed from one CS Node to another
  """
  @type t :: %__MODULE__{
    database:   database,
    auth:       auth,
    network:    network,
    serial:     serial,
    data_stack: [Ast.t]
  }


  @spec push_data(t, Ast.t) :: t
  def push_data(%__MODULE__{} = context, %Ast{} = data) do
    new_ds = [data | context.data_stack]
    %{context | data_stack: new_ds}
  end

  @spec pop_data(t) :: {Ast.t, t}
  def pop_data(context) do
    [result | rest] = context.data_stack
    {result, %{context | data_stack: rest}}
  end

  @doc """
    Returns an empty context object for those times you don't care about
    side effects or execution.
  """
  @spec new :: Ast.context
  def new do
    %__MODULE__{ data_stack: [],
                 database:   Farmbot.Database,
                 network:    Farmbot.System.Network,
                 serial:     Farmbot.Serial.Handler,
                 auth:       Farmbot.Auth,
    }
  end
end
