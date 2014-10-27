require 'spec_helper'

describe Calculator do

  it 'calculates the slugging percentage' do
    singles = 1000
    doubles = 100
    triples = 10
    home_runs = 1
    hits = singles + doubles + triples + home_runs
    at_bats = 2222

    pct = (singles + doubles*2 + triples*3 + home_runs*4) / at_bats.to_f

    expect(Calculator.slugging_percentage(hits, doubles, triples, home_runs, at_bats)).to eq pct
  end

  it 'calculates the batting average' do
    hits = 123
    at_bats = 456

    expect(Calculator.batting_average(hits, at_bats)).to eq( hits / at_bats.to_f )
  end

end