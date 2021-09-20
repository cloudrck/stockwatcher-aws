require 'oauth'
require 'oj'

module RestAlly
    class AllyApi  
      attr_accessor :private_key, :public_key, :conn_options
  
      def initialize(options)
        @consumer_key = options[:consumer_key]
        @consumer_secret = options[:consumer_secret]
        @access_key = options[:access_key]
        @access_key_secret = options[:access_key_secret]
        
        @JSON_HEADER = {'Accept' => 'application/json'}
        @conn_options = {
          :site               => options[:site] || 'https://devapi.invest.ally.com/v1',
          :request_token_path => "",
          :authorize_path     => "",
          :access_token_path  => "",
          :http_method        => :get
        }
        begin
        
        @oa_consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, @conn_options)
        @oa_access = OAuth::AccessToken.new(@oa_consumer, @access_key, @access_key_secret)
        rescue
          puts "cant connect"
        end
        
      end

      def account(action, params={})
        if params.empty?
          raise 'Message goes here'
        end

        response = case action
          when :number
            get_account_number
          when :holdings
            get_holdings(params[:id])
          else
            "no output"
          end
        
        response
      end

      protected
      def get_holdings(id)
        begin
        doc = parse_response(@oa_access.get("/accounts/#{id}/holdings.json", @JSON_HEADER))
        #pp doc.inspect

        rescue
          puts "cant connect 2"
        end

        doc_load = {}

        doc['accountholdings']['holding'].each do |key|
          doc_load["#{key['instrument']['sym']}"] = { 
                                                  :costbasis => "#{key['costbasis']}",
                                                  :purchaseprice => "#{key['purchaseprice']}",
                                                  :qty => "#{key['qty']}"
          }
        end

        doc_load
      end

      # assumes only one account
      def get_account_number 
        doc = parse_response(@oa_access.get('/accounts.json', @JSON_HEADER))
        doc["accounts"]['accountsummary']['account']
      end
      def parse_response(response)
        if response.code == '200'
        #doc = Oj::Doc.open response.body
        #doc.fetch
        doc_load = Oj.load(response.body) # Passes Ruby Object from JSON Response
        doc_load['response'] # Skip to the Response nodes
        else
          { :status => 'MyError', 
            :code => response.code, 
            :message => response.body }
        end
      end
    end
end