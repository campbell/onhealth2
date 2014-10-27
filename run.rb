Dir['./helpers/**/*.rb', './models/**/*.rb'].each {|f| require f}

Main.new('Batting-07-12.csv', 'Master-small.csv').run