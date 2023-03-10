defmodule ThamaniWeb.GuardianErrorHandler do
  import ThamaniWeb.Router.Helpers

  def unauthorized(conn, _params) do
    conn
    |> Phoenix.Controller.put_flash(
      :error,
      "You must be signed in to access that page."
    )
    |> Phoenix.Controller.redirect(to: login_path(conn, :index))
  end

  def unverified(conn, _params) do
    conn
    |> Phoenix.Controller.put_flash(
      :error,
      "You must verify your account first."
    )
    |> Phoenix.Controller.redirect(to: panel_path(conn, :index))
  end

  def timeout(conn, _params) do
    conn
    |> Phoenix.Controller.put_flash(
      :warning,
      "Your session has timed out."
    )
    |> Phoenix.Controller.redirect(to: login_path(conn, :index))
  end
end
