require 'rest-client'
require 'json'
require 'base64'

# Utils
require 'onfleet/Util'

# Errors
require 'onfleet/errors/onfleet_error'
require 'onfleet/errors/authentication_error'
require 'onfleet/errors/invalid_request_error'
require 'onfleet/errors/connection_error'

# Actions
require 'onfleet/actions/create'
require 'onfleet/actions/find'
require 'onfleet/actions/save'
require 'onfleet/actions/update'
require 'onfleet/actions/get'
require 'onfleet/actions/list'
require 'onfleet/actions/delete'


# Resources
require 'onfleet/onfleet_object'
require 'onfleet/recipient'
require 'onfleet/destination'
require 'onfleet/address'
require 'onfleet/task'
require 'onfleet/organization'
require 'onfleet/admin'
require 'onfleet/team'


module Onfleet
  @base_url = "https://onfleet.com/api/v2"

  class << self
    attr_accessor :api_key, :base_url, :encoded_api_key
  end

  def self.request url, method, params={}
    raise AuthenticationError.new("Set your API Key using Onfleet.api_key = <API_KEY>") unless @api_key
    p self.base_url+url
    begin
      response = RestClient::Request.execute(method: method, url: self.base_url+url, payload: params.to_json, headers: self.request_headers)

      if response != ''
        JSON.parse(response)
      end
    rescue RestClient::ExceptionWithResponse => e
      if response_code = e.http_code and response_body = e.http_body
        handle_api_error(response_code, JSON.parse(response_body))
      else
        handle_restclient_error(e)
      end
    rescue RestClient::Exception, Errno::ECONNREFUSED => e
      handle_restclient_error(e)
    end
  end

  private
    def self.request_headers
      {
        Authorization: "Basic #{self.encoded_api_key}"
      }
    end

    def self.encoded_api_key
      @encoded_api_key ||= Base64.urlsafe_encode64(@api_key)
    end

    def self.handle_api_error code, body
      case code
      when 400, 404
        raise InvalidRequestError.new(body["message"])
      when 401
        raise AuthenticationError.new(body["message"])
      else
        raise OnfleetError.new(body["message"])
      end
    end

    def self.handle_restclient_error e
      case e
      when RestClient::RequestTimeout
        message = "Could not connect to Onfleet. Check your internet connection and try again."
      when RestClient::ServerBrokeConnection
        message = "The connetion with onfleet terminated before the request completed. Please try again."
      else
        message = "There was a problem connection with Onfleet. Please try again. If the problem persists contact contact@onfleet.com"
      end

      raise ConnectionError.new(message)
    end
end
