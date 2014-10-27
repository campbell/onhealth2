require 'spec_helper'

def stat_factory(player, year, league, team, at_bats, hits, doubles, triples, home_runs, rbis)
  {
    'playerID' => player,
    'yearID' => year,
    'league' => league,
    'teamID' => team,
    'AB' => at_bats,
    'H' => hits,
    '2B' => doubles,
    '3B' => triples,
    'HR' => home_runs,
    'RBI' => rbis
  }
end

describe Award do
  let(:batting_stats) { Main.new(stats_array)}
  let(:award) { Award.new(batting_stats, [])}

  context 'slugging percentage' do
    let(:stats_array) {[
      stat_factory('a', 2006, nil, 'OAK', 20, 10, 0, 0, 0, 0 ),
      stat_factory('b', 2007, nil, 'OAK', 25, 10, 0, 0, 0, 0 ),
      stat_factory('a', 2008, nil, 'OAK', 30, 10, 0, 0, 0, 0 ),
      stat_factory('d', 2007, nil, 'NYY', 35, 10, 0, 0, 0, 0 )
    ]}

    it 'can be calculated for a team in a given year' do
      expect(Award.slugging(stats_array, 2007, 'OAK')).to eq 10/25.to_f
    end
  end

  context 'most_improved' do
    let(:stats_array) {[
      # 200+ at-bats, low improvement
      stat_factory('a', 2009, nil, nil, 200, 10, 0, 0, 0, 0 ),
      stat_factory('a', 2010, nil, nil, 201, 20, 0, 0, 0, 0 ),
      # 200+ at-bats, best improvement
      stat_factory('b', 2009, nil, nil, 200, 10, 0, 0, 0, 0 ),
      stat_factory('b', 2010, nil, nil, 200, 30, 0, 0, 0, 0 ),
      # < 200 at-bats in one year
      stat_factory('c', 2009, nil, nil, 199, 10, 0, 0, 0, 0 ),
      stat_factory('c', 2010, nil, nil, 200, 40, 0, 0, 0, 0 ),
      # 200+ at-bats but didn't improve
      stat_factory('d', 2009, nil, nil, 200, 30, 0, 0, 0, 0 ),
      stat_factory('d', 2010, nil, nil, 200, 10, 0, 0, 0, 0 ),
    ]}

    it 'finds the player having > 199 hits with the most improved batting average between 2009 and 2010' do
      expect(Award.batting(stats_array)['playerID']).to eq 'b'
    end
  end

  context 'triple crown winner' do
    let(:league_1_winner) { stat_factory('winner1', 2000, 'AL', nil, 400, 400, 0, 0, 100, 200) }
    let(:league_1_second_winner) { stat_factory('winner1a', 2000, 'AL', nil, 400, 400, 0, 0, 100, 200) }
    let(:league_2_winner) { stat_factory('winner2', 2000, 'NL', nil, 400, 400, 0, 0, 100, 200) }

    let(:losing_stats) {[
      stat_factory('b', 2001, 'AL', nil, 400, 400, 0, 0, 100, 200), # different year
      stat_factory('c', 2000, 'AL', nil, 300, 400, 0, 0, 100, 200), # not enough at-bats
      stat_factory('d', 2000, 'AL', nil, 400, 300, 0, 0, 100, 200), # lower batting average
      stat_factory('e', 2000, 'AL', nil, 400, 400, 0, 0, 99, 200),  # not enough HRs
      stat_factory('f', 2000, 'AL', nil, 400, 400, 0, 0, 100, 199), # not enough RBIs
    ]}

    context 'with a winner' do
      let(:stats_array) { losing_stats << league_1_winner }

      it 'finds the player with > 400 at-bats and the best batting average, home runs & RBI counts' do
        expect(Award.triple_crown_winners(stats_array, 2000)).to eq ['winner1']
      end
    end

    context 'with multiple winners' do
      let(:stats_array) { losing_stats << league_1_winner << league_1_second_winner }

      it 'finds them' do
        expect(Award.triple_crown_winners(stats_array, 2000)).to eq %w(winner1 winner1a)
      end
    end

    context 'with multiple leagues' do
      let(:stats_array) { losing_stats << league_1_winner << league_2_winner }

      it 'finds the winners in each league' do
        expect(Award.triple_crown_winners(stats_array, 2000)).to eq %w(winner1 winner2)
      end
    end
  end

end
