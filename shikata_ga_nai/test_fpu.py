import r2pipe
import sys

opcodes = [
'd9d0', 'd9e1', 'd9f6', 'd9f7', 'd9e5', 'd9e8', 'd9e9', 'd9ea', 'd9eb', 'd9ec',
'd9ed', 'd9c0', 'd9c1', 'd9c2', 'd9c3', 'd9c4', 'd9c5', 'd9c6', 'd9c7', 'd9c8',
'd9c9', 'd9ca', 'd9cb', 'd9cc', 'd9cd', 'd9ce', 'dac0', 'dac1', 'dac2', 'dac3',
'dac4', 'dac5', 'dac6', 'dac7', 'dac8', 'dac9', 'daca', 'dacb', 'dacc', 'dacd',
'dace', 'dacf', 'dad0', 'dad1', 'dad2', 'dad3', 'dad4', 'dad5', 'dad6', 'dad7',
'dad8', 'dad9', 'dada', 'dadb', 'dadc', 'dadd', 'dade', 'dbc0', 'dbc1', 'dbc2',
'dbc3', 'dbc4', 'dbc5', 'dbc6', 'dbc7', 'dbc8', 'dbc9', 'dbca', 'dbcb', 'dbcc',
'dbcd', 'dbce', 'dbcf', 'dbd0', 'dbd1', 'dbd2', 'dbd3', 'dbd4', 'dbd5', 'dbd6',
'dbd7', 'dbd8', 'dbd9', 'dbda', 'dbdb', 'dbdc', 'dbdd', 'dbde', 'ddc0', 'ddc1',
'ddc2', 'ddc3', 'ddc4', 'ddc5', 'ddc6'
]

r = r2pipe.open('-')

for i in opcodes:
    opcode = r.cmdj('abj %s' % i)[0]
    if opcode['family'] != 'fpu':
        print opcode['opcode']
        sys.exit(0)
print('[+] All instructions are FPU ones!')


