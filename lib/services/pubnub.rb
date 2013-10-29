require 'uri'

class Service::Pubnub < Service::HttpPost
  string :subscribe_key, :publish_key, :cipher_key, :channel

  default_events ALL_EVENTS

  url 'https://pubnub.com/'
  logo_url 'http://www.pubnub.com/images/logo.png'

  maintained_by :github => 'blazeroot',
                :twitter => '@blazeroot'

  supported_by :web => 'https://help.pubnub.com/',
               :email => 'help@pubnub.com.',
               :github => 'https://github.com/pubnub/',
               :twitter => '@PubNub'

  def receive_event
    subscribe_key = config_value('subscribe_key') || 'demo'
    publish_key   = config_value('publish_key')   || 'demo'
    cipher_key    = config_value('cipher_key')
    channel       = config_value('channel')       || 'demo'
    origin        = config_value('origin')        || 'pubsub.pubnub.com'
    ssh           = config_value('ssh')           || true

    puts subscribe_key
    puts publish_key
    puts cipher_key
    puts channel
    puts origin
    puts ssh

    raise_config_error 'Invalid Subscribe Key' unless subscribe_key.match(/^[A-Za-z0-9\-_]+$/)
    raise_config_error 'Invalid Publish Key'   unless publish_key.match(/^[A-Za-z0-9\-_]+$/)
    raise_config_error 'Invalid Channel'       unless channel.match(/^[A-Za-z0-9\-_]+$/)
    raise_config_error 'Invalid Origin'        unless origin.match(/^[A-Za-z0-9\-_.]+$/)

    payload = generate_json(payload)

    proto = ssh ? 'http://' : 'https://'

    url = "#{proto}#{origin}/publish/#{subscribe_key}/#{publish_key}/0/#{channel}/0/#{payload}"

    deliver url
  end

  private

  def encode_payload(payload)
    URI.escape(payload).gsub(/\?/,'%3F')
  end

end