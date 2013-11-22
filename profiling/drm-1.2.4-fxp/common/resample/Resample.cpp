/******************************************************************************\
 * Technische Universitaet Darmstadt, Institut fuer Nachrichtentechnik
 * Copyright (c) 2002
 *
 * Author(s):
 *	Volker Fischer
 *
 * Description:
 * Resample routine for arbitrary sample-rate conversions in a low range (for
 * frequency offset correction).
 * The algorithm is based on a polyphase structure. We upsample the input
 * signal with a factor INTERP_DECIM_I_D and calculate two successive samples
 * whereby we perform a linear interpolation between these two samples to get
 * an arbitraty sample grid.
 * The polyphase filter is calculated with Matlab(TM), the associated file
 * is ResampleFilter.m.
 *
 ******************************************************************************
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
\******************************************************************************/

#include "Resample.h"


/* Implementation *************************************************************/
int CResample::Resample(CVector<_FREAL>* prInput, CVector<_FREAL>* prOutput, _FREAL rRation_fxp)
{
	/* Move old data from the end to the history part of the buffer and
	   add new data (shift register) */
  vecrIntBuff_fxp.AddEnd((*prInput), iInputBlockSize);
        
	/* Sample-interval of new sample frequency in relation to interpolated
	   sample-interval */
       FXP INTERP_DECIM_I_D_fxp = INTERP_DECIM_I_D;
       FXP rTStep_fxp = INTERP_DECIM_I_D_fxp / rRation_fxp;
 
	/* Init output counter */
	int im = 0;

	/* Main loop */
	do
	{
		/* Quantize output-time to interpolated time-index */
      		const int ik = (int) rtOut_fxp;

		/* Calculate convolutions for the two interpolation-taps ------------ */
		/* Phase for the linear interpolation-taps */
		const int ip1 = ik % INTERP_DECIM_I_D;
		const int ip2 = (ik + 1) % INTERP_DECIM_I_D;

		/* Sample positions in input vector */
		const int in1 = (int) (ik / INTERP_DECIM_I_D);
		const int in2 = (int) ((ik + 1) / INTERP_DECIM_I_D);

		/* Convolution */
		FXP ry1_fxp = 0;
		FXP ry2_fxp = 0;
		FXP fResTaps1To1_fxp = 0;

		for (int i = 0; i < RES_FILT_NUM_TAPS_PER_PHASE; i++)
		{

                        fResTaps1To1_fxp = fResTaps1To1[ip1][i];
         		ry1_fxp += fResTaps1To1_fxp * (vecrIntBuff_fxp[in1 - i] ); 
                        fResTaps1To1_fxp = fResTaps1To1[ip2][i];
         		ry2_fxp += fResTaps1To1_fxp * (vecrIntBuff_fxp[in2 - i] ); 

		}


		/* Linear interpolation --------------------------------------------- */
		/* Get numbers after the comma */
		FXP rxInt_fxp = rtOut_fxp - (FXP)rtOut_fxp.GetIValue();

		//(*prOutput)[im] = (_REAL)((ry2_fxp - ry1_fxp) * rxInt_fxp + ry1_fxp);
		(*prOutput)[im] = ((ry2_fxp - ry1_fxp) * rxInt_fxp + ry1_fxp);

		/* Increase output counter */
		im++;

		/* Increase output-time and index one step */
		rtOut_fxp = rtOut_fxp + rTStep_fxp;

	} 
	while (rtOut_fxp.GetIValue() < rBlockDuration_fxp.GetIValue());

	/* Set rtOut back */
        FXP iInputBlockSize_fxp = iInputBlockSize;
	rtOut_fxp -= iInputBlockSize_fxp * INTERP_DECIM_I_D_fxp;

	return im;
}

void CResample::Init(const int iNewInputBlockSize)
{
	iInputBlockSize = iNewInputBlockSize;
        FXP INTERP_DECIM_I_D_fxp = INTERP_DECIM_I_D;

	/* History size must be one sample larger, because we use always TWO
	   convolutions */
	iHistorySize = RES_FILT_NUM_TAPS_PER_PHASE + 1;

	/* Calculate block duration */
	rBlockDuration_fxp = ((FXP)iInputBlockSize + (FXP)RES_FILT_NUM_TAPS_PER_PHASE) * (FXP)INTERP_DECIM_I_D;

	/* Allocate memory for internal buffer, clear sample history */
	vecrIntBuff_fxp.Init(iInputBlockSize + iHistorySize, (_FREAL) 0.0);

	/* Init absolute time for output stream (at the end of the history part) */
 	rtOut_fxp = (FXP) RES_FILT_NUM_TAPS_PER_PHASE * INTERP_DECIM_I_D_fxp;
}

void CAudioResample::Resample(CVector<_REAL>& rInput, CVector<_REAL>& rOutput)
{
	int j;

        FXP rRation_fxp = rRation;
	if (rRation_fxp == (FXP) 1.0)
	{
		/* If ratio is 1, no resampling is needed, just copy vector */
		for (j = 0; j < iOutputBlockSize; j++)
			rOutput[j] = rInput[j];
	}
	else
	{
		/* Move old data from the end to the history part of the buffer and
		   add new data (shift register) */
		vecrIntBuff.AddEnd(rInput, iInputBlockSize);

		/* Main loop */
		for (j = 0; j < iOutputBlockSize; j++)
		{
			/* Phase for the linear interpolation-taps */
			const int ip =
				(int) (j * INTERP_DECIM_I_D / rRation) % INTERP_DECIM_I_D;

			/* Sample position in input vector */
			const int in = (int) (j / rRation) + RES_FILT_NUM_TAPS_PER_PHASE;

			/* Convolution */
			FXP ry_fxp = (FXP) 0.0;
			for (int i = 0; i < RES_FILT_NUM_TAPS_PER_PHASE; i++){
				ry_fxp += (FXP)fResTaps1To1[ip][i] * (FXP)vecrIntBuff[in -1];
			}
			rOutput[j] = ry_fxp.GetFValue();
		}
	}
}

void CAudioResample::Init(int iNewInputBlockSize, _REAL rNewRation)
{
	rRation = rNewRation;
	iInputBlockSize = iNewInputBlockSize;
	iOutputBlockSize = (int) (iInputBlockSize * rNewRation);

	/* Allocate memory for internal buffer, clear sample history */
	vecrIntBuff.Init(iInputBlockSize + RES_FILT_NUM_TAPS_PER_PHASE, (_REAL) 0.0);
}
