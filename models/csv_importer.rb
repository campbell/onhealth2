require 'csv'

# NOTE: Every CSV file must have a header row (just like the sample data ;-) 

class CsvImporter
 
  def initialize(csv_file_name)
    @csv_file_name = csv_file_name
  end

  def import
    keys = nil
    rows = []
    CSV.foreach(@csv_file_name) do |values|
      if keys # Not the first row, so parse the values into a hash
        rows << create_hash(keys, values)
      else # First row, defines the fields & order
        keys = values
      end
    end

    rows
  end

  private

  def create_hash(keys, values)
    key_pairs = values.fill do |i|
      key = keys[i]
      value = values[i]
      value = value.to_i if value =~ /^\d+$/  # Convert to integer if possible
      [key, value]
    end

    Hash[key_pairs]
  end
end