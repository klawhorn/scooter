module Scooter
  module HttpDispatchers
    module Inventory
      # Methods here are generally representative of endpoints
      module V1

        def initialize(host)
          super(host)
          @version = 'v1'
        end

        #commands endpoints
        def post_connection(payload)
          @connection.post("#{@version}/command/create-connection") do |req|
            req.body = payload
          end
        end
        
        #query endpoints
        def get_connections(certname=nil, senstive=nil)
          path = "#{@version}/query/connections"
          @connection.get(path) do |request|
            request.params['certname'] = certname if certname
            request.params['sensitive'] = sensitive if sensitive
          end
        end
        
      end
    end
  end
end
