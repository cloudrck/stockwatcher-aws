require 'aws-sdk-dynamodb'

def create_table(dynamodb_client, table_definition)
  response = dynamodb_client.create_table(table_definition)
  response.table_description.table_status
rescue StandardError => e
  puts "Error creating table: #{e.message}"
  'Error'
end

def boot

  Aws.config.update(
    endpoint: ENV["DYNAMODB_ENDPOINT"],
    region: ENV["AWS_DEFAULT_REGION"]
  )

  dynamodb_client = Aws::DynamoDB::Client.new

  table_definition = {
    table_name: 'Stocks',
    key_schema: [
      {
        attribute_name: 'ticker',
        key_type: 'HASH'  # Partition key.
      },
      {
        attribute_name: 'date',
        key_type: 'RANGE' # Sort key.
      }
    ],
    attribute_definitions: [
      {
        attribute_name: 'ticker',
        attribute_type: 'S'
      },
      {
        attribute_name: 'date',
        attribute_type: 'N'
      }
    ],
    provisioned_throughput: {
      read_capacity_units: 10,
      write_capacity_units: 10
    }
  }

  puts "Creating the table named 'Stocks'..."
  create_table_result = create_table(dynamodb_client, table_definition)

  if create_table_result == 'Error'
    puts 'Table not created.'
  else
    puts "Table created with status '#{create_table_result}'."
  end
end

boot if $PROGRAM_NAME == __FILE__
