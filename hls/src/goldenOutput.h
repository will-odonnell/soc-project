#include "ViterbiDecoder.h"

_DECISION golden_output[256] = {
0,
1,
1,
1,
0,
1,
1,
0,
0,
1,
1,
0,
0,
1,
1,
0,
1,
1,
0,
0,
1,
1,
1,
0,
0,
1,
1,
1,
0,
0,
1,
1,
1,
0,
1,
1,
0,
0,
1,
1,
0,
1,
0,
0,
1,
1,
0,
0,
0,
0,
0,
1,
1,
0,
0,
1,
1,
0,
0,
1,
1,
1,
0,
0,
0,
1,
1,
0,
1,
0,
1,
0,
1,
1,
1,
1,
1,
1,
1,
1,
1,
0,
0,
0,
0,
0,
1,
1,
1,
0,
0,
1,
1,
0,
1,
1,
0,
0,
0,
1,
0,
1,
1,
0,
1,
0,
0,
0,
0,
0,
0,
0,
0,
0,
1,
1,
1,
0,
0,
1,
1,
1,
0,
0,
1,
1,
0,
0,
0,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
0,
0,
0,
1,
0,
1,
0,
0,
1,
1,
0,
0,
0,
1,
1,
1,
0,
0,
0,
1,
1,
1,
1,
1,
0,
0,
1,
1,
1,
1,
0,
0,
0,
0,
1,
1,
1,
1,
0,
0,
1,
0,
0,
0,
1,
1,
1,
0,
1,
0,
0,
1,
0,
1,
1,
1,
0,
0,
1,
0,
0,
1,
1,
0,
1,
0,
0,
0,
1,
0,
0,
1,
1,
0,
1,
0,
0,
0,
0,
1,
1,
0,
1,
0,
1,
1,
1,
0,
0,
1,
1,
1,
1,
1,
1,
0,
1,
1,
1,
1,
0,
0,
1,
1,
0,
1,
1,
0,
0,
1};
/*
0,
1,
0,
0,
1,
0,
1,
0,
1,
0,
1,
1,
1,
0,
0,
0,
1,
1,
0,
0,
1,
0,
1,
0,
0,
0,
0,
1,
1,
1,
1,
0,
1,
1,
1,
1,
0,
0,
1,
0,
0,
0,
1,
1,
1,
1,
0,
0,
0,
0,
1,
1,
1,
1,
0,
1,
1,
0,
0,
1,
0,
1,
1,
0,
0,
1,
1,
1,
1,
1,
0,
1,
0,
1,
0,
1,
0,
0,
1,
0,
0,
0,
1,
0,
0,
0,
1,
0,
1,
0,
0,
1,
0,
0,
0,
1,
0,
0,
0,
0,
0,
1,
1,
1,
1,
0,
0,
1,
0,
1,
1,
1,
0,
0,
1,
1,
0,
1,
1,
1,
1,
0,
1,
0,
0,
1,
1,
0,
1,
1,
1,
0,
1,
0,
0,
0,
1,
1,
0,
1,
0,
0,
0,
0,
0,
0,
0,
1,
1,
0,
0,
0,
1,
1,
1,
1,
1,
0,
0,
0,
1,
1,
0,
1,
1,
0,
1,
1,
0,
1,
1,
1,
1,
1,
0,
0,
1,
1,
1,
0,
0,
0,
1,
0,
0,
0,
1,
1,
0,
1,
1,
0,
1,
0,
1,
0,
0,
1,
0,
0,
1,
1,
1,
1,
1,
1,
0,
0,
0,
1,
0,
1,
1,
1,
1,
1,
1,
0,
1,
0,
1,
1,
0,
0,
1,
1,
1,
1,
0,
0,
0,
1,
0,
1,
0,
1,
1,
1,
1,
0,
1,
1,
0,
1,
0,
0,
1,
0,
1,
0,
1,
1,
0,
0,
1,
0,
0,
1,
0,
1,
1,
0,
1,
1,
0,
0,
1,
0,
1,
0,
1,
0,
0,
1,
1,
1,
0,
1,
1,
0,
1,
0,
0,
0,
1,
0,
0,
1,
1,
1,
1,
0,
0,
0,
1,
0,
0,
1,
1,
0,
1,
1,
0,
0,
1,
1,
0,
0,
0,
0,
1,
1,
0,
1,
0,
1,
0,
1,
1,
0,
0,
1,
1,
1,
1,
0,
0,
0,
1,
1,
1,
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
1,
1,
0,
1,
0,
1,
0,
0,
0,
0,
0,
0,
1,
1,
0,
1,
1,
0,
0,
0,
1,
0,
1,
1,
1,
0,
1,
0,
1,
1,
0,
1,
1,
0,
1,
0,
0,
0,
1,
0,
0,
1,
1,
1,
0,
1,
0,
1,
1,
0,
1,
1,
1,
0,
0,
1,
1,
1,
0,
0,
0,
1,
1,
0,
0,
1,
0,
1,
0,
0,
0,
1,
0,
1,
0,
0,
1,
0,
0,
0,
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
1,
0,
1,
1,
1,
1,
0,
1,
1,
1,
1,
0,
1,
1,
1,
0,
1,
0,
0,
0,
1,
1,
0,
0,
1,
1,
0,
0,
0,
0,
0,
0,
0,
0,
1,
0,
1,
0,
1,
0,
0,
0,
1,
0,
1,
0,
1,
0,
1,
1,
1,
1,
1,
1,
1,
1,
0,
1,
1,
1,
0,
1,
1,
1,
1,
1,
1,
0,
1,
0,
0,
0,
1,
0,
1,
1,
0,
1,
0,
0,
0,
1,
0,
0,
0,
0,
1,
1,
1,
1,
0,
1,
0,
1,
1,
1,
1,
0,
0,
0,
1,
0,
0,
1,
0,
1,
0,
1,
0,
0,
0,
1,
0,
1,
0,
1,
0,
0,
0,
1,
1,
1,
0,
1,
0,
0,
0,
0,
1,
1,
0,
0,
0,
1,
0,
0,
1,
1,
1,
1,
0,
1,
1,
0,
0,
1,
1,
1,
1,
0,
1,
1,
1,
0,
0,
0,
0,
1,
0,
0,
0,
0,
0,
1,
0,
1,
0,
1,
0,
0,
1,
1,
0,
0,
0,
0,
0,
0,
1,
0,
0,
1,
1,
1,
1,
1,
0,
0,
1,
1,
1,
0,
0,
0,
1,
1,
0,
1,
0,
0,
1,
1,
0,
0,
0,
0,
0,
1,
0,
1,
0,
0,
0,
0,
1,
0,
0,
0,
0,
0,
0,
0,
0,
1,
0,
0,
1,
0,
0,
0,
1,
1,
1,
0,
0,
0,
0,
1,
0,
0,
1,
0,
1,
1,
0,
0,
1,
1,
0,
1,
0,
0,
0,
0,
1,
0,
0,
0,
1,
0,
1,
0,
0,
1,
0,
1,
0,
0,
0,
1,
1,
1,
1,
1,
1,
1,
1,
1,
1,
1,
0,
0,
0,
1,
1,
1,
0,
0,
0,
1,
1,
1,
1,
0,
0,
0,
1,
1,
1,
1,
0,
1,
0,
1,
0,
0,
0,
1,
1,
1,
1,
0,
0,
0,
0,
1,
0,
0,
1,
0,
0,
0,
1,
0,
1,
1,
0,
0,
0,
1,
1,
0,
0,
0,
1,
1,
0,
0,
0,
1,
0,
0,
1,
0,
0,
0,
0,
0,
1,
1,
0,
1,
0,
0,
0,
0,
1,
0,
1,
0,
1,
0,
0,
1,
0,
1,
0,
0,
0,
1,
0,
1,
0,
1,
1,
1,
1,
1,
1,
1,
0,
1,
0,
0,
1,
1,
0,
0,
1,
1,
1,
1,
0,
0,
0,
0,
0,
0,
0,
1,
1,
0,
0,
0,
0,
0,
1,
1,
1,
1,
0,
0,
0,
0,
0,
0,
1,
0,
0,
1,
0,
1,
1,
0,
1,
0,
1,
0,
1,
1,
0,
1,
1,
0,
1,
1,
1,
1,
0,
1,
0,
0,
1,
1,
0,
1,
1,
1,
1,
1,
1,
1,
0,
0,
0,
1,
0,
0,
0,
0,
1,
0,
0,
1,
0,
1,
1,
1,
0,
0,
1,
1,
0,
1,
0,
0,
0,
1,
1,
1,
1,
0,
0,
0,
1,
0,
1,
0,
0,
0,
1,
0,
1,
0,
0,
0,
0,
1,
1,
0,
0,
1,
0,
1,
0,
1,
0,
0,
1,
1,
0,
0,
0,
1,
0,
1,
1,
0,
0,
0,
0,
1,
0,
1,
0,
1,
1,
1,
0,
1,
1,
0,
1,
0,
0,
1,
0,
0,
0,
1,
1,
0,
0,
0,
1,
1,
0,
0,
1,
1,
1,
0,
1,
1,
1,
0,
0,
1,
0,
1,
1,
1,
1,
0,
0,
1,
0,
1,
0,
0,
1,
1,
1,
1,
0,
0,
0,
0,
0,
1,
1,
0,
1,
1,
0,
1,
0,
1,
0,
1,
0,
0,
0,
0,
1,
1,
0,
1,
0,
1,
1,
0,
1,
0,
0,
0,
1,
0,
0,
1,
0,
1,
0,
1,
1,
0,
1,
0,
0,
0,
1,
1,
0,
1,
1,
0,
1,
1,
0,
0,
1,
0,
0,
1,
1,
1,
0,
0,
0,
0,
0,
1,
0,
1,
1,
0,
0,
0,
1,
1,
1,
0,
0,
0,
1,
1,
1,
1,
1,
0,
0,
0,
1,
0,
0,
1,
0,
0,
1,
0,
0,
1,
1,
1,
1,
1,
1,
1,
0,
1,
1,
1,
1,
1,
0,
1,
0,
0,
0,
0,
1,
0,
0,
1,
1,
1,
1,
1,
1,
0,
1,
0,
0,
0,
0,
1,
0,
0,
1,
1,
0,
1,
1,
1,
1,
0,
1,
1,
1,
0,
1,
0,
0,
0,
1,
1,
1,
0,
0,
1,
1,
0,
1,
1,
1,
1,
0,
0,
1,
1,
0,
0,
1,
0,
1,
0,
1,
1,
1,
0,
0,
1,
0,
1,
0,
0,
0,
0,
1,
1,
1,
0,
1,
1,
0,
1,
0,
0,
0,
0,
1,
0,
1,
0,
0,
1,
1,
0,
1,
0,
0,
0,
1,
0,
0,
0,
0,
1,
1,
0,
0,
1,
1,
0,
0,
0,
1,
1,
1,
1,
1,
1,
1,
1,
0,
1,
0,
1,
0,
0,
0,
1,
0,
1,
1,
0,
1,
1,
0,
0,
0,
0,
1,
0,
1,
1,
0,
1,
1,
1,
0,
0,
1,
1,
0,
0,
0,
0,
1,
0,
0,
1,
1,
1,
1,
1,
0,
1,
0,
0,
1,
0,
1,
0,
1,
1,
1,
1,
0,
0,
0,
0,
0,
0,
1,
1,
0,
1,
0,
0,
1,
1,
0,
1,
0,
1,
0,
0,
0,
1,
1,
0,
1,
0,
1,
0,
1,
0,
1,
1,
0,
1,
0,
1,
1,
1,
1,
0,
1,
0,
1,
0,
1,
1,
1,
0,
1,
1,
0,
1,
1,
1,
0,
0,
0,
1,
1,
0,
0,
1,
1,
1,
1,
0,
0,
1,
1,
0,
0,
1,
0,
0,
1,
0,
1,
1,
1,
0,
0,
1,
1,
1,
1,
0,
0,
0,
0,
1,
0,
1,
1,
1,
1,
1,
0,
0,
1,
0,
0,
0,
0,
0,
1,
1,
1,
1,
1,
1,
1,
1,
0,
1,
0,
0,
0,
0,
1,
0,
1,
1,
0,
0,
0,
1,
0,
1,
0,
1,
0,
0,
1,
0,
0,
0,
0,
1,
1,
0,
0,
0,
1,
1,
0,
0,
0,
0,
1,
0,
0,
1,
0,
1,
1,
0,
1,
0,
1,
1,
0,
1,
0,
1,
1,
0,
0,
1,
0,
0,
0,
0,
0,
0,
0,
0,
1,
0,
0,
1,
0,
1,
1,
1,
1,
0,
0,
1,
0,
1,
0,
1,
1,
0,
1,
1,
0,
1,
1,
1,
1,
0,
0,
0,
1,
1,
1,
0,
1,
1,
0,
0,
0,
0,
1,
1,
1,
0,
1,
0,
0,
1,
1,
0,
0,
0,
1,
1,
1,
0,
0,
0,
1,
1,
0,
1,
1,
0,
0,
0,
1,
0,
1,
0,
1,
1,
0,
1,
0,
0,
0,
1,
0,
1,
0,
0,
1,
1,
1,
0,
0,
1,
0,
1,
1,
1,
0,
1,
0,
1,
0,
0,
1,
0,
1,
0,
0,
1,
1,
1,
1,
1,
1,
1,
1,
1,
1,
0,
0,
0,
0,
1,
0,
0,
0,
1,
0,
0,
0,
1,
1,
1,
1,
0,
0,
1,
0,
1,
0,
1,
1,
1,
0,
1,
1,
1,
0,
1,
1,
1,
0,
0,
1,
1,
1,
0,
1,
1,
0,
1,
1,
1,
1,
0,
0,
0,
0,
1,
1,
0,
1,
1,
0,
0,
0,
1,
0,
0,
0,
1,
0,
0,
1,
0,
0,
0,
0,
1,
0,
1,
1,
1,
1,
1,
0,
0,
0,
1,
1,
0,
0,
0,
1,
0,
1,
1,
0,
0,
1,
0,
1,
0,
0,
0,
1,
1,
0,
1,
1,
0,
0,
0,
0,
1,
1,
0,
0,
0,
0,
1,
0,
1,
0,
0,
1,
0,
0,
1,
1,
1,
1,
1,
1,
0,
0,
0,
0,
0,
0,
1,
1,
0,
0,
1,
0,
0,
0,
0,
0,
1,
1,
0,
0,
0,
1,
0,
1,
1,
0,
1,
1,
1,
0,
0,
1,
0,
1,
0,
1,
1,
1,
1,
1,
1,
0,
1,
1,
1,
0,
0,
1,
1,
0,
1,
1,
1,
0,
1,
0,
1,
0,
1,
0,
1,
0,
1,
0,
1,
0,
1,
0,
1,
1,
1,
1,
0,
1,
0,
0,
0,
0,
1,
1,
1,
0,
0,
1,
0,
0,
0,
0,
0,
1,
0,
1,
0,
1,
1,
1,
0,
1,
0,
1,
0,
0,
0,
0,
0,
1,
1,
0,
0,
1,
0,
0,
1,
1,
0,
0,
0,
0,
1,
0,
0,
1,
0,
1,
1,
1,
1,
1,
0,
1,
0,
1,
1,
0,
1,
0,
0,
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
0,
0,
1,
1,
0,
0,
0,
1,
1,
1,
1,
0,
0,
0,
1,
0,
0,
0,
0,
1,
1,
1,
1,
1,
1,
1,
0,
1,
1,
1,
0,
0,
0,
1,
0,
1,
1,
0,
1,
1,
1,
1,
1,
1,
1,
1,
1,
0,
1,
1,
0,
1,
1,
1,
1,
0,
1,
0,
0,
0,
1,
1,
1,
1,
1,
1,
0,
0,
1,
1,
1,
0,
0,
0,
1,
1,
1,
1,
1,
0,
1,
1,
1,
1,
0,
0,
1,
0,
0,
1,
1,
1,
1,
1,
1,
1,
0,
1,
0,
1,
0,
1,
0,
1,
0,
1,
1,
0,
1,
0,
1,
1,
0,
0,
1,
1,
0,
0,
1,
1,
1,
0,
1,
0,
1,
1,
1,
1,
1,
1,
0,
0,
0,
1,
0,
0,
0,
0,
0,
0,
1,
0,
0,
0,
1,
1,
1,
1,
0,
1,
0,
0,
0,
1,
0,
0,
1,
0,
0,
1,
1,
1,
1,
1,
0,
0,
0,
0,
0,
0,
0,
1,
0,
0,
0,
1,
0,
0,
0,
1,
1,
0,
1,
1,
0,
1,
1,
1,
1,
1,
1,
1,
1,
0,
0,
0,
1,
0,
0,
1,
0,
1,
0,
1,
1,
0,
0,
1,
0,
1,
1,
0,
0,
0,
0,
1,
0,
0,
0,
0,
0,
1,
1,
0,
1,
0,
0,
0,
0,
0,
1,
0,
1,
1,
1,
1,
0,
0,
0,
1,
1,
0,
1,
0,
0,
0,
1,
1,
1,
1,
1,
1,
1,
0,
0,
1,
0,
1,
1,
0,
0,
0,
0,
1,
0,
1,
1,
1,
0,
1,
0,
0,
0,
1,
0,
1,
1,
0,
0,
0,
0,
0,
1,
1,
0,
1,
1,
1,
0,
0,
1,
1,
1,
1,
1,
0,
0,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
0,
1,
1,
0,
1,
1,
0,
0,
1,
1,
1,
1,
1,
1,
0,
0,
1,
1,
1,
0,
0,
1,
0,
1,
1,
0,
0,
1,
1,
1,
1,
1,
1,
0,
1,
1,
0,
1,
0,
0,
0,
0,
0,
0,
0,
0,
1,
0,
0,
0,
1,
0,
1,
0,
1,
1,
1,
1,
1,
0,
1,
0,
0,
0,
1,
1,
1,
0,
0,
0,
1,
1,
0,
1,
1,
0,
0,
1,
0,
0,
1,
1,
0,
0,
0,
0,
1,
0,
1,
0,
0,
1,
0,
1,
1,
0,
0,
0,
1,
1,
1,
0,
1,
1,
1,
1,
0,
0,
0,
1,
1,
1,
0,
0,
0,
1,
1,
0,
1,
1,
1,
1,
1,
1,
1,
1,
1,
0,
0,
0,
1,
0,
0,
1,
1,
1,
0,
1,
0,
0,
1,
0,
0,
1,
1,
1,
1,
0,
1,
0,
1,
1,
0,
0,
0,
0,
1,
0,
0,
1,
1,
1,
1,
1,
1,
0,
1,
1,
1,
1,
0,
0,
1,
1,
1,
0,
1,
0,
0,
0,
1,
0,
1,
1,
0,
1,
1,
1,
1,
0,
1,
0,
1,
1,
1,
0,
0,
0,
0,
0,
0,
1,
1,
1,
0,
1,
1,
1,
1,
0,
1,
1,
1,
1,
0,
0,
0,
0,
0,
1,
1,
0,
1,
0,
0,
1,
0,
1,
0,
0,
0,
1,
0,
1,
0,
0,
1,
0,
0,
1,
0,
0,
1,
0,
1,
1,
0,
0,
1,
0,
1,
0,
0,
0,
1,
1,
0,
0,
1,
1,
1,
1,
0,
0,
1,
0,
0,
0,
0,
1,
1,
0,
0,
0,
0,
0,
1,
1,
1,
1,
0,
1,
0,
0,
1,
0,
1,
1,
1,
0,
1,
0,
0,
1,
0,
0,
0,
1,
1,
0,
0,
0,
1,
1,
1,
0,
1,
1,
1,
1,
0,
0,
0,
0,
0,
1,
1,
0,
0,
0,
0,
0,
1,
1,
1,
0,
1,
0,
1,
1,
0,
1,
0,
1,
0,
1,
0,
1,
1,
1,
1,
1,
1,
1,
0,
1,
1,
1,
0,
1,
0,
1,
0,
0,
0,
0,
1,
0,
1,
0,
0,
1,
1,
0,
0,
1,
1,
0,
0,
0,
0,
1,
1,
1,
0,
0,
0,
0,
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
1,
0,
1,
1,
1,
0,
1,
0,
1,
1,
0,
1,
0,
0,
0,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
0,
0,
1,
1,
0,
1,
1,
0,
0,
1,
1,
1,
0,
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
1,
1,
1,
1,
1,
1,
0,
1,
1,
1,
0,
1,
0,
0,
0,
1,
1,
0,
1,
1,
0,
1,
1,
1,
0,
0,
0,
1,
0,
0,
1,
0,
1,
1,
0,
1,
0,
1,
0,
1,
0,
0,
1,
0,
0,
0,
1,
1,
0,
1,
1,
1,
1,
0,
0,
1,
0,
0,
0,
0,
0,
0,
1,
0,
1,
0,
1,
1,
0,
1,
0,
1,
1,
0,
1,
1,
0,
0,
1,
0,
1,
0,
1,
1,
0,
0,
0,
0,
1,
0,
0,
1,
0,
0,
0,
1,
0,
1,
0,
1,
0,
1,
0,
1,
0,
0,
1,
0,
1,
1,
1,
1,
1,
1,
0,
0,
0,
0,
0,
0,
0,
0,
0,
1,
0,
1,
0,
1,
1,
1,
0,
0,
1,
0,
0,
0,
1,
1,
0,
0,
0,
1,
0,
1,
1,
0,
0,
1,
0,
1,
1,
1,
1,
1,
1,
0,
0,
1,
0,
0,
0,
1,
0,
1,
1,
1,
1,
1,
0,
1,
0,
1,
0,
0,
1,
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
0,
0,
1,
1,
0,
1,
0,
1,
1,
1,
1,
0,
1,
0,
1,
1,
1,
1,
1,
0,
0,
0,
0,
1,
0,
1,
1,
1,
1,
0,
1,
0,
1,
1,
1,
1,
0,
0,
0,
0,
1,
0,
1,
1,
0,
1,
0,
1,
1,
1,
1,
0,
1,
0,
0,
0,
0,
1,
0,
1,
1,
0,
0,
0,
0,
1,
0,
0,
0,
0,
1,
0,
1,
1,
1,
1,
0,
0,
0,
0,
1,
0,
0,
0,
0,
0,
0,
0,
0,
1,
1,
1,
1,
1,
0,
1,
0,
0,
1,
0,
1,
1,
1,
0,
1,
1,
0,
0,
0,
1,
0,
0,
1,
1,
1,
0,
1,
1,
0,
1,
1,
1,
1,
1,
0,
0,
0,
0,
0,
0,
1,
1,
1,
1,
0,
0,
0,
0,
0,
1,
0,
1,
0,
0,
0,
0,
1,
1,
1,
0,
1,
0,
0,
0,
1,
0,
0,
0,
1,
0,
1,
0,
0,
0,
0,
1,
1,
1,
1,
1,
0,
1,
0,
0,
0,
0,
0,
1,
1,
1,
0,
1,
0,
0,
1,
1,
0,
1,
0,
1,
1,
0,
0,
0,
0,
0,
0,
1,
0,
0,
1,
0,
0,
1,
1,
0,
1,
0,
1,
1,
0,
0,
1,
1,
0,
0,
0,
0,
0,
0,
1,
0,
1,
0,
0,
1,
0,
1,
0,
0,
0,
1,
0,
1,
1,
0,
0,
0,
0,
0,
0,
1,
1,
0,
0,
1,
0,
1,
0,
1,
0,
0,
0,
1,
0,
1,
0,
1,
1,
0,
1,
0,
0,
0,
1,
0,
0,
1,
0,
1,
0,
1,
0,
0,
0,
1,
0,
1,
0,
1,
0,
1,
0,
1,
0,
0,
0,
0,
0,
0,
0,
1,
1,
0,
0,
1,
1,
1,
0,
1,
1,
0,
1,
0,
1,
1,
0,
0,
0,
0,
0,
1,
1,
0,
0,
0,
1,
0,
1,
0,
0,
1,
1,
0,
0,
0,
1,
1,
0,
1,
1,
0,
1,
0,
1,
1,
0,
1,
0,
1,
1,
0,
1,
1,
0,
1,
0,
1,
1,
1,
0,
0,
1,
0,
0,
1,
1,
1,
1,
1,
1,
0,
1,
1,
0,
0,
0,
1,
1,
0,
0,
0,
0,
0,
1,
1,
0,
1,
1,
0,
1,
0,
0,
0,
0,
1,
0,
1,
1,
0,
0,
0,
1,
0,
1,
1,
1,
1,
0,
0,
1,
1,
0,
1,
1,
1,
1,
0,
1,
0,
1,
0,
0,
1,
1,
1,
1,
1,
1,
1,
1,
0,
1,
0,
1,
1,
0,
1,
1,
1,
1,
0,
0,
1,
1,
1,
0,
1,
0,
0,
0,
1,
1,
1,
0,
1,
0,
0,
0,
1,
1,
0,
1,
0,
1,
1,
0,
1,

--------------------------------
*/