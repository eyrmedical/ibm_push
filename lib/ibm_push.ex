defmodule IBMPush do
  @moduledoc """
  Wrapper to use IBM Bluemix Push notification REST API.
  ref. https://mobile.eu-gb.bluemix.net/imfpush
  """

  use HTTPoison.Base

  unless Application.get_env(:ibm_push, IBMPush) do
    raise IBMPush.ConfigError, message: "IBMPush is not configured"
  end

  unless Keyword.get(Application.get_env(:ibm_push, IBMPush), :url) do
    raise IBMPush.ConfigError, message: "IBMPush requires url"
  end


  @doc """
  Append REST API main url.
  """
  @spec process_url(String.t) :: String.t
  def process_url(url) do
    config(:url) <> url
  end


  @doc """
  Get the list of a registered devices.
  """
  @spec devices() :: {:ok, map()} | {:error, Exception.t}
  def devices do
    with {:ok, %{body: json_body, status_code: 200}} <- IBMPush.get("/devices", headers(:device)),
      {:ok, response} <- Poison.decode(json_body)
    do
      {:ok, response}
    else
      {:ok, %{status_code: 400}} ->
        {:error, IBMPush.InvalidRequestData}
      {:ok, %{status_code: 401}} ->
        {:error, IBMPush.NoSecurityHeader}
      {:ok, %{status_code: 406}} ->
        {:error, IBMPush.UnsupportedAcceptType}
      {:ok, %{status_code: 409}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 500}} ->
        {:error, IBMPush.ApiError}
      {:error, _} ->
        {:error, IBMPush.ApiError}
      _ ->
        {:error, IBMPush.GenericError}
    end
  end

  @doc """
  Register a new device.
  """
  @spec new_device(map()) :: {:ok, map()} | {:error, Exception.t}
  def new_device(%{"deviceId" => _, "platform" => _, "token" => _} = device_spec) do
    with {:ok, json} <- Poison.encode(device_spec),
      {:ok, %{body: json_body, status_code: 201}} <- IBMPush.post("/devices", json, headers(:device)),
      {:ok, response} <- Poison.decode(json_body)
    do
      {:ok, response}
    else
      {:ok, %{status_code: 401}} ->
        {:error, IBMPush.NoSecurityHeader}
      {:ok, %{status_code: 404}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 406}} ->
        {:error, IBMPush.UnsupportedAcceptType}
      {:ok, %{status_code: 409}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 415}} ->
        {:error, IBMPush.UnsupportedMediaType}
      {:ok, %{status_code: 500}} ->
        {:error, IBMPush.ApiError}
      {:error, {:invalid, _}} ->
        {:error, IBMPush.InvalidRequestData}
      {:error, _} ->
        {:error, IBMPush.ApiError}
      _ ->
        {:error, IBMPush.GenericError}
    end
  end

  @doc """
  Remove existing device.
  """
  @spec delete_device(String.t) :: :ok
  def delete_device(device_id) do
    with {:ok, %{status_code: 204}} <- IBMPush.delete("/devices/#{device_id}", headers(:device)) do
      :ok
    else
      {:ok, %{status_code: 401}} ->
        {:error, IBMPush.NoSecurityHeader}
      {:ok, %{status_code: 404}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 500}} ->
        {:error, IBMPush.ApiError}
      {:error, _} ->
        {:error, IBMPush.ApiError}
      _ ->
        {:error, IBMPush.GenericError}
    end
  end


  @doc """
  Get a list of current application tags.
  """
  @spec tags() :: {:ok, map()} | {:error, Exception.t}
  def tags do
    with {:ok, %{body: json_body, status_code: 200}} <- IBMPush.get("/tags", headers(:tag)),
      {:ok, response} <- Poison.decode(json_body)
    do
      {:ok, response}
    else
      {:ok, %{status_code: 400}} ->
        {:error, IBMPush.InvalidRequestData}
      {:ok, %{status_code: 401}} ->
        {:error, IBMPush.NoSecurityHeader}
      {:ok, %{status_code: 406}} ->
        {:error, IBMPush.UnsupportedAcceptType}
      {:ok, %{status_code: 500}} ->
        {:error, IBMPush.ApiError}
      {:error, _} ->
        {:error, IBMPush.ApiError}
      _ ->
        {:error, IBMPush.GenericError}
    end
  end

  @doc """
  Register a new tag.
  """
  @spec new_tag(map()) :: {:ok, map()} | {:error, Exception.t}
  def new_tag(%{"name" => _, "description" => _} = tag_spec) do
    with {:ok, json} <- Poison.encode(tag_spec),
      {:ok, %{body: json_body, status_code: 201}} <- IBMPush.post("/tags", json, headers(:tag)),
      {:ok, response} <- Poison.decode(json_body)
    do
      {:ok, response}
    else
      {:ok, %{status_code: 401}} ->
        {:error, IBMPush.NoSecurityHeader}
      {:ok, %{status_code: 404}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 406}} ->
        {:error, IBMPush.UnsupportedAcceptType}
      {:ok, %{status_code: 409}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 415}} ->
        {:error, IBMPush.UnsupportedMediaType}
      {:ok, %{status_code: 500}} ->
        {:error, IBMPush.ApiError}
      {:error, {:invalid, _}} ->
        {:error, IBMPush.InvalidRequestData}
      {:error, _} ->
        {:error, IBMPush.ApiError}
      _ ->
        {:error, IBMPush.GenericError}
    end
  end

  @doc """
  Remove existing tag.
  """
  @spec delete_tag(String.t) :: :ok
  def delete_tag(tag_id) do
    with {:ok, %{status_code: 204}} <- IBMPush.delete("/tags/#{tag_id}", headers(:tag)) do
      :ok
    else
      {:ok, %{status_code: 400}} ->
        {:error, IBMPush.InvalidRequestData}
      {:ok, %{status_code: 401}} ->
        {:error, IBMPush.NoSecurityHeader}
      {:ok, %{status_code: 404}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 500}} ->
        {:error, IBMPush.ApiError}
      {:error, _} ->
        {:error, IBMPush.ApiError}
      _ ->
        {:error, IBMPush.GenericError}
    end
  end


  @doc """
  Get a list of current subscriptions.
  """
  @spec subs() :: {:ok, map()} | {:error, Exception.t}
  def subs do
    with {:ok, %{body: json_body, status_code: 200}} <- IBMPush.get("/subscriptions", headers(:sub)),
      {:ok, response} <- Poison.decode(json_body)
    do
      {:ok, response}
    else
      {:ok, %{status_code: 401}} ->
        {:error, IBMPush.NoSecurityHeader}
      {:ok, %{status_code: 404}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 406}} ->
        {:error, IBMPush.UnsupportedAcceptType}
      {:ok, %{status_code: 500}} ->
        {:error, IBMPush.ApiError}
      {:error, _} ->
        {:error, IBMPush.ApiError}
      _ ->
        {:error, IBMPush.GenericError}
    end
  end

  @doc """
  Register a new subscription.
  """
  @spec new_sub(map()) :: {:ok, map()} | {:error, Exception.t}
  def new_sub(%{"deviceId" => _, "tagName" => _} = sub_spec) do
    with {:ok, json} <- Poison.encode(sub_spec),
      {:ok, %{body: json_body, status_code: 201}} <- IBMPush.post("/subscriptions", json, headers(:sub)),
      {:ok, response} <- Poison.decode(json_body)
    do
      {:ok, response}
    else
      {:ok, %{status_code: 401}} ->
        {:error, IBMPush.NoSecurityHeader}
      {:ok, %{status_code: 404}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 406}} ->
        {:error, IBMPush.UnsupportedAcceptType}
      {:ok, %{status_code: 409}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 415}} ->
        {:error, IBMPush.UnsupportedMediaType}
      {:ok, %{status_code: 500}} ->
        {:error, IBMPush.ApiError}
      {:error, {:invalid, _}} ->
        {:error, IBMPush.InvalidRequestData}
      {:error, _} ->
        {:error, IBMPush.ApiError}
      _ ->
        {:error, IBMPush.GenericError}
    end
  end

  @doc """
  Remove existing subscription.
  """
  @spec delete_sub(String.t, String.t) :: :ok
  def delete_sub(device_id, tag_name) do
    url = "/subscriptions?tagName=#{tag_name}&deviceId=#{device_id}"
    with {:ok, %{status_code: 204}} <- IBMPush.delete(url, headers(:sub)) do
      :ok
    else
      {:ok, %{status_code: 400}} ->
        {:error, IBMPush.InvalidRequestData}
      {:ok, %{status_code: 401}} ->
        {:error, IBMPush.NoSecurityHeader}
      {:ok, %{status_code: 404}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 500}} ->
        {:error, IBMPush.ApiError}
      {:error, _} ->
        {:error, IBMPush.ApiError}
      _ ->
        {:error, IBMPush.GenericError}
    end
  end


  @doc """
  Send new message as push notification.
  """
  @spec new_message(map()) :: {:ok, map()} | {:error, Exception.t}
  def new_message(%{"message" => _} = message_spec) do
    with {:ok, json} <- Poison.encode(message_spec),
      {:ok, %{body: json_body, status_code: 202}} <- IBMPush.post("/messages", json, headers(:message)),
      {:ok, response} <- Poison.decode(json_body)
    do
      {:ok, response}
    else
      {:ok, %{status_code: 401}} ->
        {:error, IBMPush.NoSecurityHeader}
      {:ok, %{status_code: 404}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 405}} ->
        {:error, IBMPush.MethodNotAllowed}
      {:ok, %{status_code: 406}} ->
        {:error, IBMPush.UnsupportedAcceptType}
      {:ok, %{status_code: 409}} ->
        {:error, IBMPush.NoApplication}
      {:ok, %{status_code: 415}} ->
        {:error, IBMPush.UnsupportedMediaType}
      {:ok, %{status_code: 500}} ->
        {:error, IBMPush.ApiError}
      {:error, {:invalid, _}} ->
        {:error, IBMPush.InvalidRequestData}
      {:error, _} ->
        {:error, IBMPush.ApiError}
      _ ->
        {:error, IBMPush.GenericError}
    end
  end


  @doc """
  Helper function to read global config in scope of this module.
  """
  def config, do: Application.get_env(:ibm_push, IBMPush)
  def config(key, default \\ nil) do
    config() |> Keyword.get(key, default) |> resolve_config(default)
  end

  defp resolve_config({:system, var_name}, default),
    do: System.get_env(var_name) || default
  defp resolve_config(value, _default),
    do: value


  # Add security header
  defp process_request_headers(headers) when is_map(headers) do
    Enum.into(headers, headers())
  end
  defp process_request_headers(headers), do: headers ++ headers()

  # Default headers added to all requests
  defp headers do
    [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]
  end
  # Headers related to management of tags
  defp headers(:tag) do
    [{"appSecret", config(:appSecret)}]
  end
  # Headers related to management of messages
  defp headers(:message) do
    [{"appSecret", config(:appSecret)}]
  end
  # Headers related to management of subscriptions
  defp headers(:sub) do
    [{"clientSecret", config(:clientSecret)}]
  end
  # Headers related to management of devices
  defp headers(:device) do
    [{"clientSecret", config(:clientSecret)}]
  end
end
