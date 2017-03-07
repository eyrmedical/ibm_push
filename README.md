# IBMPush

A simple wrapper for IBM Bluemix push notification REST API.
Strictly follows the [REST API specs](https://mobile.eu-gb.bluemix.net/imfpush).

## Installation

Package can be installed by adding `ibm_push` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ibm_push, "~> 0.1"}]
end
```

### Config

Copy your push service credentials from Bluemix UI, to application config file:

```
config :ibm_push, IBMPush,
  appGuid: "************",
  url: "http://imfpush.eu-gb.bluemix.net/imfpush/v1/apps/*************",
  admin_url: "//mobile.eu-gb.bluemix.net/imfpushdashboard/?appGuid=************",
  appSecret: "*************",
  clientSecret: "************"
```

# Usage

Check the `test` folder for usage examples.

## Devices

### Get existing device
`{:ok, response} = IBMPush.devices()`

### Add new device
```
{:ok, response} = IBMPush.new_device(%{
  "deviceId" => device_id,
  "platform" => "A",
  "token" => IBMPush.config(:testAppleDeviceToken),
})
```

### Delete existing device
`:ok = IBMPush.delete_device(device_id)`

## Tags

### Get existing tags
`{:ok, response} = IBMPush.tags()`

### Add new tag
```
{:ok, response} = IBMPush.new_tag(%{
  "name" => tag_name,
  "description" => "Test tag"
})
```

### Delete existing tag
`IBMPush.delete_tag(tag_name)`

## Subscriptions

### Get existing subscriptions
`{:ok, response} = IBMPush.subs()`

### Add new subscription
```
{:ok, response} = IBMPush.new_sub(%{
  "deviceId" => device_id,
  "tagName" => tag_name
})
```

### Delete existing subscription
`:ok = IBMPush.delete_sub(device_id, tag_name)`

## Messages

### Post new push notification
```
{:ok, response} = IBMPush.new_message(%{
  "message" => %{
    "alert" => "Test alert"
  }
})
```

# Roadmap

- [ ] Applications
  - [ ] GET /apps/{applicationId}/settings
  - [ ] DELETE /apps/{applicationId}/settings/apnsConf
  - [ ] GET /apps/{applicationId}/settings/apnsConf
  - [ ] PUT /apps/{applicationId}/settings/apnsConf
  - [ ] DELETE /apps/{applicationId}/settings/gcmConf
  - [ ] GET /apps/{applicationId}/settings/gcmConf
  - [ ] PUT /apps/{applicationId}/settings/gcmConf
  - [ ] DELETE /apps/{applicationId}/settings/safariWebConf
  - [ ] GET /apps/{applicationId}/settings/safariWebConf
  - [ ] PUT /apps/{applicationId}/settings/safariWebConf
  - [ ] GET /apps/{applicationId}/settings/gcmConfPublic
  - [ ] DELETE /apps/{applicationId}/settings/chromeWebConf
  - [ ] GET /apps/{applicationId}/settings/chromeWebConf
  - [ ] PUT /apps/{applicationId}/settings/chromeWebConf
  - [ ] DELETE /apps/{applicationId}/settings/firefoxWebConf
  - [ ] GET /apps/{applicationId}/settings/firefoxWebConf
  - [ ] PUT /apps/{applicationId}/settings/firefoxWebConf
  - [ ] DELETE /apps/{applicationId}/settings/chromeAppExtConf
  - [ ] GET /apps/{applicationId}/settings/chromeAppExtConf
  - [ ] PUT /apps/{applicationId}/settings/chromeAppExtConf
  - [ ] GET /apps/{applicationId}/settings/chromeAppExtConfPublic
- [ ] Devices
  - [x] GET /apps/{applicationId}/devices
  - [x] POST /apps/{applicationId}/devices
  - [ ] GET /apps/{applicationId}/devices/report
  - [x] DELETE /apps/{applicationId}/devices/{deviceId}
  - [ ] GET /apps/{applicationId}/devices/{deviceId}
  - [ ] PUT /apps/{applicationId}/devices/{deviceId}
- [ ] Messages
  - [x] POST /apps/{applicationId}/messages
  - [ ] POST /apps/{applicationId}/messages/bulk
  - [ ] GET /apps/{applicationId}/messages/report
  - [ ] DELETE /apps/{applicationId}/messages/{messageId}
  - [ ] GET /apps/{applicationId}/messages/{messageId}
  - [ ] PUT /apps/{applicationId}/messages/{messageId}
  - [ ] GET /apps/{applicationId}/messages/{messageId}
- [x] Subscriptions
  - [x] DELETE /apps/{applicationId}/subscriptions
  - [x] GET /apps/{applicationId}/subscriptions
  - [x] POST /apps/{applicationId}/subscriptions
- [ ] Tags
  - [x] GET /apps/{applicationId}/tags
  - [x] POST /apps/{applicationId}/tags
  - [x] DELETE /apps/{applicationId}/tags/{tagName}
  - [ ] GET /apps/{applicationId}/tags/{tagName}
  - [ ] PUT /apps/{applicationId}/tags/{tagName}
- [ ] Webhooks
  - [ ] GET /apps/{applicationId}/webhooks
  - [ ] POST /apps/{applicationId}/webhooks
  - [ ] DELETE /apps/{applicationId}/webhooks/{webhookName}
  - [ ] GET /apps/{applicationId}/webhooks/{webhookName}
  - [ ] PUT /apps/{applicationId}/webhooks/{webhookName}

# Testing

Add the following line in your **test** config environment before running `mix test`.

```
config :ibm_push, IBMPush,
  testAppleDeviceToken: "*****************"
```

# Disclaimer

**This library is in it's early beta, use on your own risk. Pull requests / reports / feedback are welcome.**

