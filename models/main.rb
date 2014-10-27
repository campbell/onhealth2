class Main
  attr_accessor :stats_array, :players_array

  def initialize(stats_csv_filename, players_csv_filename)
    @stats_array = CsvImporter.new(stats_csv_filename).import
    @players_array = CsvImporter.new(players_csv_filename).import
  end


  def run
    most_improved_winner = get_player_name(Award.batting(@stats_array)['playerID'])
    slugging_percentage_result = Award.slugging(@stats_array, 2007, 'OAK')
    triple_crown_winners_2011 = Award.triple_crown_winners(@stats_array, 2011).collect!{|player| get_player_name(player)}
    triple_crown_winners_2012 = Award.triple_crown_winners(@stats_array, 2012).collect!{|player| get_player_name(player)}

    results = "Most improved batting average between 2009 & 2010: " + most_improved_winner + "\n" +
              "Slugging percentage for OAK in 2007 was #{ '%0.3f' % slugging_percentage_result }\n" + 
          "Triple-crown-winner(s) for 2011: " + triple_crown_winners_2011.join(', ') + "\n" +
          "Triple-crown-winner(s) for 2012: " + triple_crown_winners_2012.join(', ')

    puts results
  end

  def get_player_name(player_id)
    player = @players_array.find{|p| player_id == p['playerID']}
    player ? player['nameFirst'] + ' ' + player['nameLast'] : player_id
  end


end