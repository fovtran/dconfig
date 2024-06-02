import numpy as np

fs = 8000000
_fs = 48000
fsa = fs/_fs
print(fsa)

fsm = _fs / fsa  # sclock / fs
print(fsm)
fsn = (fsa/100) * (_fs/fsa)

fs_fsM = lambda fsa, _fs, fs, fs1, flag0 ,flag1: [(fsa/100)*(_fs/fsa),(fs/_fs), (2*np.pi*_fss1)/_fs, flag0,flag1]
(nA, nB, nC, nD) = fn_fsM(fsa, _fs, fs, 440, False, False)
print(c)
fsclock = fs/nC
cbitstream = _fs/nA
nA/nB
