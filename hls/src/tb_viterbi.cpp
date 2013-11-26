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
/*
  double golden_rTow0[64] = { 	3.48087,6.83191,68.8044,36.9827,4.30804,77.6387,5.51903,74.9669,
			   	71.4903,62.3567,46.593,7.48975,64.0657,57.4409,14.6554,79.4388,
			   	78.1065,87.2036,9.54176,7.61053,56.36,71.331,17.2903,2.8371,1.96042,
			   	15.2465,5.72023,90.3111,4.92032,0.579102,6.38275,69.8369,7.94221,
			   	2.41739,63.6048,55.7841,7.4687,3.22153,52.2689,10.1676,64.7133,
			   	4.7533,52.7004,5.82019,61.5357,0.736603,79.3606,88.0299,59.7449,
		           	66.903,4.16118,60.6877,13.617,1.85164,46.3077,11.7199,74.6274,
			   	4.54201,0.249908,5.48381,6.42163,50.1648,16.4985,79.2064};
  double golden_rTow1[64] = {  	74.4306,70.1627,6.98581,5.03098,72.8049,6.50418,41.8718,3.1769,
				5.35852,1.89667,5.40363,83.2659,2.85559,12.8984,94.6011,4.88,11.0956,
				7.54456,60.9312,53.927,6.03864,1.01949,84.4089,63.9763,61.4715,
				64.1838,71.4908,14.6891,57.0689,53.1591,76.0481,2.02515,61.3075,
				57.2601,6.46867,3.78761,65.779,57.8014,0.143814,59.6824,6.47536,
				80.1232,2.72844,68.7257,0.29425,52.9642,7.67874,20.315,2.48305,
				6.46317,61.8932,4.4472,63.6985,54.8199,3.96674,65.8734,10.2394,
				92.4263,42.6346,58.5059,73.5627,0.524429,86.5468,9.38728};

  _DECISION golden_output[64] = {0,1,1,1,0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0,1,1,1,0,0,1,1,1,0,0,1,1,
				 1,0,1,1,0,0,1,1,0,1,0,0,1,1,0,0,0,0,0,1,1,0,0,1,1,0,0,1,1,1,0,0};
*/
  
  CFDistance input[256];
  _DECISION output[256];
  _DECISION* pOutput = output;
  int eCodeScheme = 2;
  int eChanType = 0;
  int iN1 = 0;
  int iN2 = 256;
  int iBitA = 0;
  int iBitB = 256;
  int iPatA = 9;
  int iPatB = 9;
  int iLvl = 2;
  int j;
  int mismatch = 0;

  // Initialize the input/output buffers
  for (j=0;j<256;j++) {
    input[j].rTow0 = golden_rTow0[j];
    input[j].rTow1 = golden_rTow1[j];
    output[j] = 0xA5;
  }
  
  printf("Output buffer before decode:\n");
  for (j=0;j<256;j++) {
      printf("output[%d] = %d\n",j,output[j]);
  }

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
  for (j=0;j<256;j++) {
    if (output[j] != golden_output[j]) {
      printf("Output mismatch on element %d -> %d does not match %d\n",j,output[j],golden_output[j]);
      mismatch++;
    }
  }
  

    if (mismatch > 0) {
    printf("total mismatches: %d\n",mismatch);    
    }

#ifdef CATAPULT
  CCS_RETURN(0);
#else
  return 0;
#endif
}
