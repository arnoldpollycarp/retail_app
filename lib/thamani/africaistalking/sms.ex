defmodule Thamani.Africaistalking.Sms do
  @moduledoc """
  The Shops context.
  """

  import Ecto.Query, warn: false
  use HTTPotion.Base

  def process_url() do
    get_api_url()
  end

  @doc """
  get the appropriate url from the configuration files.
  """
  def get_api_url do
    Application.get_env(:thamani, :aft_url)
  end

  def get_api_username do
    Application.get_env(:thamani, :aft_username)
  end

  def get_api_key do
    Application.get_env(:thamani, :aft_key)
  end

  def get_timestamp do
    Timex.local()
    |> Timex.format!("{YYYY}-{0M}-{0D} {h24}:{m}:{s}")
  end

  def send(phone, message) do
    header = [
      apiKey: get_api_key(),
      "Content-Type": "application/x-www-form-urlencoded",
      Accept: "application/json"
    ]

    body = %{
      "username" => get_api_username(),
      "message" => message,
      "to" => phone
    }

    HTTPotion.post(get_api_url(), body: URI.encode_query(body), headers: header)
    |> process_response()
  end

  def reset(phone, message) do
    header = [
      apiKey: get_api_key(),
      "Content-Type": "application/x-www-form-urlencoded",
      Accept: "application/json"
    ]

    body = %{
      "username" => get_api_username(),
      "message" => message,
      "to" => phone
    }

    HTTPotion.post(get_api_url(), body: URI.encode_query(body), headers: header)
    |> process_response()
  end

  @doc """
  Process the response from the API
  """
  def process_response(%HTTPotion.Response{status_code: status_code, body: body} = resp) do
    cond do
      status_code == 201 ->
        {:ok, body, resp}

      true ->
        {:error, resp}
    end
  end
end
