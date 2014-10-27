class Calculator

  def self.slugging_percentage(hits, doubles, triples, home_runs, at_bats)
    singles = hits - doubles - triples - home_runs

    (singles + doubles*2 + triples*3 + home_runs*4) / at_bats.to_f
  end

  def self.batting_average(hits, at_bats)
    hits / at_bats.to_f
  end
end
