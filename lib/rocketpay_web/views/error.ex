defmodule RocketpayWeb.ErrorView do
  use RocketpayWeb, :view

  alias Ecto.Changeset
  alias RocketpayWeb.ErrorHelpers

  def template_not_found(template, %{changeset: %Changeset{} = changeset}) do
    %{
      error: %{
        message: Phoenix.Controller.status_message_from_template(template),
        details: ErrorHelpers.translate_errors(changeset)
      }
    }
  end

  def template_not_found(template, _assigns) do
    %{error: %{message: Phoenix.Controller.status_message_from_template(template)}}
  end
end
