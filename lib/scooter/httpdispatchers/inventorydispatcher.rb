%w( v1 ).each do |lib|
  require "scooter/httpdispatchers/inventory/v1/#{lib}"
end

module Scooter
  module HttpDispatchers
    class InventoryDispatcher < HttpDispatcher

      include Scooter::HttpDispatchers::Inventory::V1

      def initialize(host)
        super(host)
        @connection.url_prefix.path = '/inventory'
        @connection.url_prefix.port = 8143
      end

      # @return [Faraday::Response] response object from Faraday http client
      def create_connection(payload)
        post_connection(payload)
      end

      # @return [Faraday::Response] response object from Faraday http client
      def list_connections(sensitive=nil, certname=nil)
        get_job(sensitive, certname)
      end
    end
  end
end
