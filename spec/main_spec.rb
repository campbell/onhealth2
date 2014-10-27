require 'spec_helper'

describe Main do
  let(:main) { Main.new('./spec/fixtures/stats.csv', './spec/fixtures/players.csv')}

  context '#get_player_name' do
    it 'finds the player name from the player collection' do
      expect(main.get_player_name('a')).to eq 'b c'
    end

    it 'returns the playerID if the name is not found' do
      expect(main.get_player_name('fake')).to eq 'fake'
    end
  end

  context '#run' do
    it 'should announce the results' do
      allow(Award).to receive(:batting).and_return({'playerID' => 'batting-winner'})
      allow(Award).to receive(:slugging).and_return(0.12345)
      allow(Award).to receive(:triple_crown_winners).and_return([{'playerID' => 'triple-winner'}])

      orig_stdout, $stdout = $stdout, StringIO.new
      main.run

      expect($stdout.string).to include 'batting-winner'
      expect($stdout.string).to include '0.123'
      expect($stdout.string).to match /2011.*triple-winner/
      expect($stdout.string).to match /2012.*triple-winner/

      $stdout = orig_stdout
    end
  end

end