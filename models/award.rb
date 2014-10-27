class Award
  def self.batting(stats)
    stats_2009 = stats.select{|stat| stat['yearID'].to_i == 2009 && stat['AB'].to_i > 199 }
    stats_2010 = stats.select{|stat| stat['yearID'].to_i == 2010 && stat['AB'].to_i > 199 }

    batting_averages_2009 = get_batting_average(stats_2009)
    batting_averages_2010 = get_batting_average(stats_2010)

    players = batting_averages_2009.keys & batting_averages_2010.keys
    best_player = {'playerID' => nil, improvement: 0}
    players.each do |player_id|
      improvement = batting_averages_2010[player_id][:average] - batting_averages_2009[player_id][:average]
      
      best_player = {'playerID' => player_id, improvement: improvement} if improvement > best_player[:improvement]
    end

    best_player
  end


  def self.get_batting_average(stats)
    stats.inject({}) do |memo, stat|
      player = stat['playerID']
      year = stat['yearID']

      memo[player] ||= { hits: 0, at_bats: 0 }
      memo[player][:hits] += stat['H'].to_i
      memo[player][:at_bats] += stat['AB'].to_i
      memo[player][:average] = Calculator.batting_average(memo[player][:hits], memo[player][:at_bats])
      memo
    end
  end

  def self.slugging(stats, year, team_id)
    stats = stats.select{|stat| stat['yearID'].to_i == year && stat['teamID'] == team_id }
    slugging_stats = %w(H 2B 3B HR AB).collect do |stat|
      stats.collect{|s| s[stat].to_i}.reduce(:+)
    end

    Calculator.slugging_percentage(*slugging_stats)
  end

  def self.stats_leaders(stats, league, year)
    selected_stats = stats.select{|stat| stat['yearID'].to_i == year && stat['league'] == league && stat['AB'].to_i > 399 }
    selected_stats.collect! do |stat|
      stat[:average] = Calculator.batting_average(stat['H'].to_i, stat['AB'].to_i)
      stat
    end

    ['HR', 'RBI', :average].collect do |stat_name|
      max = selected_stats.max_by{|stat| stat[stat_name]}
      selected_stats.select{|stat| stat[stat_name] == max[stat_name]}
                    .collect{|stat| stat['playerID']}
    end
  end

  def self.triple_crown_winners(stats, year)
    winners = []

    leaders = stats_leaders(stats, 'AL', year)
    winners += (leaders[0] & leaders[1] & leaders[2])

    leaders = stats_leaders(stats, 'NL', year)
    winners += (leaders[0] & leaders[1] & leaders[2])

    winners << '(No winner)' if winners.length == 0
    winners
  end

end