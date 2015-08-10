require 'rest-client'
require 'json'
require 'base64'

# Errors
require 'onfleet/errors/onfleet_error'
require 'onfleet/errors/authentication_error'

module Onfleet
  @base_url = "https://onfleet.com/api/v2"

  class << self
    attr_accessor :api_key, :base_url, :encoded_api_key
  end

  def self.request url, method, params
    raise AuthenticationError.new("Set your API Key using Onfleet.api_key = <API_KEY>") unless @api_key

    begin
      RestClient::Request.execute(method: method, url: self.base_url+url, payload: params, headers: self.request_headers)
    rescue RestClient::ExceptionWithResponse => e
      # if response_code = e.http_code and response_body = e.http_body
      #   handle_api_error(response_code, response_body)
      # else
      #   handle_restclient_error(e)
      # end
    rescue RestClient::Exception, Errno::ECONNREFUSED => e
      # handle_restclient_error(e)
    end
  end

  private
    def self.request_headers
      {
        Authorization: "Basic #{self.encoded_api_key}"
      }
    end

    def encoded_api_key
      @encoded_api_key ||= Base64.urlsafe_encode64(@api_key)
    end
end
