// (C) Madisetti & Sinnokrot, 2008
// modified by H.Park for catapult 2010
#include "stdio.h"
#include "ViterbiDecoder.h"

#include "goldenInput_rTow0.h"
#include "goldenInput_rTow1.h"
#include "goldenOutput.h"

//#define CATAPULT
#ifdef CATAPULT
#include <mc_scverify.h>
#endif

#ifdef CATAPULT
CCS_MAIN(int argc, char *argv[])
#else
int main(int argc, char *argv[])
#endif
{
  
  CFDistance input[4676];
  _DECISION output[4676];
  _DECISION* pOutput = output;
  int eCodeScheme = 2;
  int eChanType = 0;
  int iN1 = 0;
  int iN2 = 3000;
  int iBitA = 0;
  int iBitB = 3000;
  int iPatA = 9;
  int iPatB = 9;
  int iLvl = 2;
  int j;
  int mismatch = 0;
  int match = 0;

  // Initialize the input/output buffers
  for (j=0;j<4676;j++) {
    input[j].rTow0 = golden_rTow0[j];
    input[j].rTow1 = golden_rTow1[j];
    output[j] = 0xA5;
  }

#if 0  
  printf("Output buffer before decode:\n");
  for (j=0;j<256;j++) {
      printf("output[%d] = %d\n",j,output[j]);
  }
#endif

  // Run the decoder
  {
    printf("Viterbi decode starting...\n");
    //
    // Call Catapult hardware function
    //
#ifdef CATAPULT
    CCS_DESIGN(InitDecode)(input,pOutput,
                           eCodeScheme,
                           eChanType,
                           iN1,iN2,
                           iBitA,iBitB,
                           iPatA,iPatB,iLvl);
#else
    InitDecode(            input,pOutput,
                           eCodeScheme,
                           eChanType,
                           iN1,iN2,
                           iBitA,iBitB,
                           iPatA,iPatB,iLvl);
#endif
    printf("Viterbi decode complete.\n");

  }
    //
    // Input/Output Results
    //
  for (j=0;j<3000;j++) {
    if (output[j] != golden_output[j]) {
      printf("Output mismatch on element %d -> %d does not match %d\n",j,output[j],golden_output[j]);
      mismatch++;
    } else {
      match++;
    }
    
  }
  
  printf("total matches: %d\n",match);
  printf("total mismatches: %d\n",mismatch);    

#ifdef CATAPULT
  CCS_RETURN(0);
#else
  return 0;
#endif
}
