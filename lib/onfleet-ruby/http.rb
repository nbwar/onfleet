require 'rest-client'
require 'json'
require 'base64'
require 'uri'

module Onfleet
  @base_url = 'https://onfleet.com/api/v2/'

  class << self
    attr_accessor :api_key, :base_url

    def request(api_url, method, params = {})
      raise(AuthenticationError, 'Set your API Key using Onfleet.api_key = <API_KEY>') unless api_key

      begin
        url = URI.join(base_url, api_url).to_s
        response = RestClient::Request.execute(method: method, url: url, payload: params.to_json, headers: request_headers)
        JSON.parse(response) unless response.empty?
      rescue RestClient::ExceptionWithResponse => e
        if (response_code = e.http_code) && (response_body = e.http_body)
          handle_api_error(response_code, JSON.parse(response_body))
        else
          handle_restclient_error(e)
        end
      rescue RestClient::Exception, Errno::ECONNREFUSED => e
        handle_restclient_error(e)
      end
    end

    private

    def request_headers
      {
        Authorization: "Basic #{encoded_api_key}",
        content_type: :json,
        accept: :json
      }
    end

    def encoded_api_key
      @encoded_api_key ||= Base64.urlsafe_encode64(api_key)
    end

    def handle_api_error(code, body)
      case code
      when 400, 404
        raise InvalidRequestError, body['message']
      when 401
        raise AuthenticationError, body['message']
      else
        raise OnfleetError, body['message']
      end
    end

    def handle_restclient_error(exception)
      message =
        case exception
        when RestClient::RequestTimeout
          'Could not connect to Onfleet. Check your internet connection and try again.'
        when RestClient::ServerBrokeConnection
          'The connetion with onfleet terminated before the request completed. Please try again.'
        else
          'There was a problem connection with Onfleet. Please try again. If the problem persists contact contact@onfleet.com'
        end

      raise ConnectionError, message
    end
  end
end

