defmodule ThamaniWeb.CommerceApiController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Carts


  def create(conn, %{"id" => id, "status" => status, "qty" => qty, "user" => user}) do
   cart = Carts.get_cart_user(user,id)

      if is_nil(cart) do

    case Carts.create_cart(%{"item" => id,"qty" => qty, "status" => status,"user_id" => user}) do

      {:ok, _} ->
        data =
           %{
            response: "true",
              message: "Item added to cart successfully",
            count: Carts.get_count_carts(user)
          }

        put_resp_content_type(conn, "application/json")
        send_resp(conn, 200, Poison.encode!(data))

        {:error, %Ecto.Changeset{} = _changeset} ->

          data =
             %{
              response: "false",
              message: "Sorry could not add to cart atn the moment try again later",
              count: Carts.get_count_carts(user)
            }

          put_resp_content_type(conn, "application/json")
          send_resp(conn, 200, Poison.encode!(data))

    end
   else
     data =
        %{
         response: "false",
         message: "Item already added to cart",
         count: Carts.get_count_carts(user)
       }

     put_resp_content_type(conn, "application/json")
     send_resp(conn, 200, Poison.encode!(data))


   end




  end

  def updatecart(conn, %{"id" => id,  "qty" => qty}) do
   cart = Carts.get_cart!(id)

      if is_nil(cart) do


        data =
           %{
            response: "false",
            message: "Sorry could not update the cart at the moment try again later",

          }

        put_resp_content_type(conn, "application/json")
        send_resp(conn, 200, Poison.encode!(data))


        else


    case Carts.update_cart( cart, %{"qty" => qty}) do

      {:ok, _} ->
        data =
           %{
            response: "true",
              message: "Item updated successfully",

          }

        put_resp_content_type(conn, "application/json")
        send_resp(conn, 200, Poison.encode!(data))

        {:error, %Ecto.Changeset{} = _changeset} ->

          data =
             %{
              response: "false",
              message: "Sorry could not add to cart at the moment try again later",

            }

          put_resp_content_type(conn, "application/json")
          send_resp(conn, 200, Poison.encode!(data))

    end
  end

  end

  def delcart(conn, %{"id" => id}) do
   cart = Carts.get_cart!(id)

      if is_nil(cart) do


        data =
           %{
            response: "false",
            message: "Item does not exist in cart",

          }

        put_resp_content_type(conn, "application/json")
        send_resp(conn, 200, Poison.encode!(data))


        else


    case Carts.update_cart( cart, %{"status" => "deleted"}) do

      {:ok, _} ->
        data =
           %{
            response: "true",
              message: "Item delete successfully",

          }

        put_resp_content_type(conn, "application/json")
        send_resp(conn, 200, Poison.encode!(data))

        {:error, %Ecto.Changeset{} = _changeset} ->

          data =
             %{
              response: "false",
              message: "Sorry could not add to cart at the moment try again later",

            }

          put_resp_content_type(conn, "application/json")
          send_resp(conn, 200, Poison.encode!(data))

    end
  end
end

  def status(conn, %{ "user" => user }) do

     data =
        %{
         response: "true",
         message: "Item already added to cart",
         count: Carts.get_count_carts(user)
       }

     put_resp_content_type(conn, "application/json")
     send_resp(conn, 200, Poison.encode!(data))


   end

end
