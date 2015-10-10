import sys
import r2pipe

def initESIL():
    r.cmd('e io.cache=true')
    r.cmd('e asm.bits=32')
    r.cmd('aei')
    r.cmd('aeim 0xffffd000 0x2000 stack')
    r.cmd('.ar*')  # set all registers to zero
    r.cmd('aer esp=0xffffd000')
    r.cmd('aer ebp=0xffffd000')

def dump (start):

    end = r.cmdj('oj')[0]['size']  # size of the opened object

    print(r.cmd('pD %d @ %d' % (end-start, start)))  # disassembly

    raw = r.cmdj('p8j %d @ %d' % (end-start, start))  # dump
    with open('out', 'w') as f:
        f.write(''.join(map(chr, raw)))


def decode(r):
    lastfpu = 0
    lastloop = 0

    for i in range(100000):
        current_op = r.cmdj('pdj 1 @ eip')[0]

        # End of shellcode or invalid opcode
        if current_op['type'] == 'invalid':
            dump(lastloop)
            return

        # ESIL doesn't implement FPU (yet),
        # but we don't care, since they are only used
        # to get EIP with the FNSTENV technique
        # (http://gynvael.coldwind.pl/n/eip_from_fpu_x86).
        #
        # So we take note of the offset of the latest FPU instruction,
        # on put it in `esp` when `fnstenv` is encounted.
        if current_op['family'] == 'fpu':
            if current_op['opcode'].startswith('fnstenv'):
                r.cmd('wv %d @ esp' % lastfpu)
            else:
                lastfpu = current_op['offset']

        # Check for end of loop opcodes
        if current_op['opcode'].startswith('loop') and r.cmdj('arj')['ecx'] <= 1:
            lastloop = current_op['offset'] + current_op['size'];

        r.cmd('aes')

    print('[-] We emulated %d instructions, giving up' % i)


if len(sys.argv) != 2:
    print('[*] Usage: %s sample' % sys.argv[0])
    sys.exit(0)

r = r2pipe.open(sys.argv[1])
r.cmd('e asm.comments=false');
r.cmd('e asm.lines=false');
r.cmd('e asm.flags=false');
initESIL()
decode(r)
