defmodule IBMPushTest do
  use ExUnit.Case
  doctest IBMPush

  test "getting list of registered devices" do
    {:ok, response} = IBMPush.devices()
    assert Map.has_key?(response, "devices")
  end

  test "register new device, then delete it" do
    device_id = UUID.uuid4()
    {:ok, response} = IBMPush.new_device(%{
      "deviceId" => device_id,
      "platform" => "A",
      "token" => IBMPush.config(:testAppleDeviceToken),
    })
    assert Map.has_key?(response, "userId")
    assert IBMPush.delete_device(device_id) === :ok
  end

  test "getting list of registered tags" do
    {:ok, response} = IBMPush.tags()
    assert Map.has_key?(response, "tags")
  end

  test "register new tag, then delete it" do
    tag_name = UUID.uuid4()
    {:ok, response} = IBMPush.new_tag(%{
      "name" => tag_name,
      "description" => "Test tag"
    })
    assert Map.has_key?(response, "href")
    assert IBMPush.delete_tag(tag_name) === :ok
  end

  test "getting list of registered subscriptions" do
    {:ok, response} = IBMPush.subs()
    assert Map.has_key?(response, "subscriptions")
  end

  test "register new subscription, then delete it" do
    device_id = UUID.uuid4()
    {:ok, _} = IBMPush.new_device(%{
      "deviceId" => device_id,
      "platform" => "A",
      "token" => IBMPush.config(:testAppleDeviceToken),
    })

    tag_name = UUID.uuid4()
    {:ok, _} = IBMPush.new_tag(%{
      "name" => tag_name,
      "description" => "Test tag"
    })

    {:ok, response} = IBMPush.new_sub(%{
      "deviceId" => device_id,
      "tagName" => tag_name
    })
    assert Map.has_key?(response, "href")

    assert IBMPush.delete_sub(device_id, tag_name) === :ok
    assert IBMPush.delete_tag(tag_name) === :ok
    assert IBMPush.delete_device(device_id) === :ok
  end

  test "send new message" do
    {:ok, response} = IBMPush.new_message(%{
      "message" => %{
        "alert" => "Test alert"
      }
    })
    assert Map.has_key?(response, "messageId")
  end
end
