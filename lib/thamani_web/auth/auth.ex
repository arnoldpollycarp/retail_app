defmodule ThamaniWeb.Auth do

  alias Thamani.Accounts.User
  alias Thamani.Repo
  import ThamaniWeb.Router.Helpers
  import Comeonin.Bcrypt

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

  def login_by_email_and_pass(conn, email, given_pass) do
    # try to get user by unique email from DB
    unless is_nil(email) do
      user = Repo.get_by(User, email: email)

      # examine the result
      cond do
        # if user was found and provided password hash equals to stored
        # hash

        user && checkpw(given_pass, user.password) && user.active == "true" ->
          {:ok, login(conn, user)}

        # else if we just found the use

        user ->
          {:error, :unauthorized, conn}

        true ->
          # simulate check password hash timing
          dummy_checkpw()
          {:error, :unauthorized, conn}
      end
    end
  end

  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end
end
