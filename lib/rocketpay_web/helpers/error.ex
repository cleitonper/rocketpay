defmodule RocketpayWeb.ErrorHelpers do
  alias Ecto.Changeset

  def translate_errors(%Changeset{} = changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      translate_error({msg, opts})
    end)
  end

  defp translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(RocketpayWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(RocketpayWeb.Gettext, "errors", msg, opts)
    end
  end
end
