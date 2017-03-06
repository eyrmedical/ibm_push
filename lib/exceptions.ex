defmodule IBMPush.ConfigError do
  @moduledoc """
  Raised in case there is issues with the config.
  """
  defexception [:message]
end

defmodule IBMPush.ApiError do
  @moduledoc """
  Raised in case invalid response is returned from Bluemix API.
  """
  defexception [:message]
end

defmodule IBMPush.InvalidRequestData do
  @moduledoc """
  Raised in case request data is invalid.
  """
  defexception [:message]
end

defmodule IBMPush.UnsupportedAcceptType do
  @moduledoc """
  Raised in case request media type specified in Accept
  header is not application/json.
  """
  defexception [:message]
end

defmodule IBMPush.UnsupportedMediaType do
  @moduledoc """
  Raised in case request content type specified in Content-Type
  header is not application/json.
  """
  defexception [:message]
end

defmodule IBMPush.NoApplication do
  @moduledoc """
  Raised in case application doesn't exist.
  """
  defexception [:message]
end

defmodule IBMPush.MethodNotAllowed do
  @moduledoc """
  Raised in case request method is not allowed.
  """
  defexception [:message]
end

defmodule IBMPush.NoSecurityHeader do
  @moduledoc """
  Raised in case the clientSecret header value did not match.
  """
  defexception [:message]
end

defmodule IBMPush.GenericError do
  @moduledoc """
  Raised for non-specific backend errors related to this library.
  """
  defexception [:message]
end
