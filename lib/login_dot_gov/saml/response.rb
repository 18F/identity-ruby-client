require 'base64'

module LoginDotGov
  module SAML
    class Response

      attr_reader :parsed_response

      def self.parsed_response(saml_response)
        new(saml_response).parsed_response
      end

      def initialize(raw_response)
        puts "Raw Response: #{raw_response}"
        @raw_response = raw_response
        puts "Decoded Response: #{decoded_response}"
        @parsed_response = Nokogiri::XML(decoded_response)
        puts "Parsed Response: #{parsed_response}"
      end

      private

      attr_reader :raw_response

      def config
        LoginDotGov::SAML.configuration
      end

      def decoded_response
        decoded = Base64.decode64(raw_response)
        # return decoded unless config.assertion_encryption
      end
    end
  end
end
