[0x004d6550]> is~Drive
vaddr=0x00702654 paddr=0x00168254 ord=024 fwd= sz=0 bind=NONE type=FUNC name=imp.KERNEL32.dll_GetDriveTypeA
[0x004d6550]> axt 0x00702654
[0x004d6550]> aaa
[0x004d6550]> axt 0x00702654

sub.KERNEL32.dll_GetDriveTypeA_2c0 <- internal function, meh.

izz~CD
vaddr=0x0055c684 paddr=0x0015a484 ordinal=18270 sz=7 len=6 section=.data type=ascii string=CDPath

[0x00535670]> axt 0x0055c684
d 0x40358a push 0x55c684
d 0x4d65d9 push 0x55c684
[0x00535670] >

[0x00535670] > pdf @ 0x40358a 
meh


[0x00535670] > pdf @ 0x4d65d9

yay!

[0x00535670] > s 0x4d65d9
[0x00535670] > VVV

[0x00535670]> oo+
[0x00535670]> s 0x4d6550
[0x00535670]> wx b801000000c20400
