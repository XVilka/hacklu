import sys
import r2pipe

r2 = r2pipe.open(sys.argv[1])
print('The five first instructions:\n%s\n' % r2.cmd('pi 5'))
print('And now in JSON:\n%s\n' % r2.cmdj('pij 5'))
print('architecture: %s' % r2.cmdj('ij')['bin']['machine'])


