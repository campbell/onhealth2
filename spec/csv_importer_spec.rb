require 'spec_helper'

describe CsvImporter do
  let(:imported_results) { CsvImporter.new('./spec/fixtures/stats.csv').import }

  it 'returns an array of imported results' do
    expect(imported_results.length).to eq 2
  end

  it 'creates a hash for each result' do
    result = imported_results.first
    expected_results = {
      'playerID' => 'abc',
      'yearID' => 2012,
      'league' => 'AL',
      'teamID' => 'NYA',
      'G' => 1,
      'AB' => 2,
      'R' => 3,
      'H' => 4,
      '2B' => 5,
      '3B' => 6,
      'HR' => 7,
      'RBI' => 0,
      'SB' => nil,
      'CS' => 10
    }

    expected_results.each do |key, value|
      expect(result[key]).to eq value
    end
  end
end
