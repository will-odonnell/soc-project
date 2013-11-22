/******************************************************************************\
 * Technische Universitaet Darmstadt, Institut fuer Nachrichtentechnik
 * Copyright (c) 2001
 *
 * Author(s):
 *	Volker Fischer
 *
 * Description:
 *	See TimeSync.cpp
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

#if !defined(TIMESYNC_H__3B0BEVJBN872345NBEROUEBGF4344_BB27912__INCLUDED_)
#define TIMESYNC_H__3B0BEVJBN872345NBEROUEBGF4344_BB27912__INCLUDED_

#include "../Parameter.h"
#include "../util/Modul.h"
#include "../util/Vector.h"
#include "../matlib/Matlib.h"
#include "TimeSyncFilter.h"

/* Definitions ****************************************************************/
/* Use 5 or 10 kHz bandwidth for guard-interval correlation. 10 kHz bandwidth
   should be chosen when time domain freuqency offset estimation is used */
#define USE_10_KHZ_HILBFILT

#define LAMBDA_LOW_PASS_START			10
#define TIMING_BOUND_ABS				150

/* Non-linear correction of the timing if variation is too big */
#define NUM_SYM_BEFORE_RESET			5

/* Definitions for robustness mode detection */
#define NUM_BLOCKS_FOR_RM_CORR			16
#define THRESHOLD_RELI_MEASURE			((CReal) 8.0)

/* The guard-interval correlation is only updated every "STEP_SIZE_GUARD_CORR"
   samples to save computations */
#define STEP_SIZE_GUARD_CORR			4

/* "GRDCRR_DEC_FACT": Downsampling factor. We only use approx. 6 [12] kHz for
   correlation, therefore we can use a decimation of 8 [4]
   (i.e., 48 kHz / 8 [4] = 6 [12] kHz). Must be 8 [4] since all symbol and
   guard-interval lengths at 48000 for all robustness modes are dividable
   by 8 [4] */
#ifdef USE_10_KHZ_HILBFILT
# define GRDCRR_DEC_FACT				4
# define NUM_TAPS_HILB_FILT				NUM_TAPS_HILB_FILT_10
# define HILB_FILT_BNDWIDTH				HILB_FILT_BNDWIDTH_10
static float* fHilLPProt =				fHilLPProt10;
#else
# define GRDCRR_DEC_FACT				8
# define NUM_TAPS_HILB_FILT				NUM_TAPS_HILB_FILT_5
# define HILB_FILT_BNDWIDTH				HILB_FILT_BNDWIDTH_5
static float* fHilLPProt =				fHilLPProt5;
#endif

#ifdef USE_FRQOFFS_TRACK_GUARDCORR
/* Time constant for IIR averaging of frequency offset estimation */
# define TICONST_FREQ_OFF_EST_GUCORR	((CReal) 1.0) /* sec */
#endif


/* Classes ********************************************************************/
class CTimeSync : public CReceiverModul<_COMPLEX, _COMPLEX>
{
public:
	CTimeSync();
	virtual ~CTimeSync() {}

	/* To set the module up for synchronized DRM input data stream */
	void SetSyncInput(const _BOOLEAN bNewS) {bSyncInput = bNewS;}

	void StartAcquisition(); //DRM Receiver, FreqSyncAcq, SyncUsingPil
	void StopTimingAcqu() {bTimingAcqu = FALSE;} //DRM Receiver
	void StopRMDetAcqu() {bRobModAcqu = FALSE;} //DRM Receiver

protected:
	int				iCorrCounter;
	int				iAveCorr;
	int				iStepSizeGuardCorr;

	CShiftRegister<_COMPLEX>	HistoryBuf;
	CShiftRegister<FComplex>	HistoryBufCorr;
	CShiftRegister<int>  		pMaxDetBuffer; // <_FREAL>
	CFRealVector			vecrHistoryFilt;
	
	CMovingAv<int>			vecrGuardEnMovAv; // <CFReal>
	int                             scale;
	
	CMatlibVector<int>     		vecCorrAvBuf; // CFRealVector
	int				iCorrAvInd;

	int				iMaxDetBufSize;
	int				iCenterOfMaxDetBuf;

	int				iMovAvBufSize;
	int				iTotalBufferSize;
	int				iSymbolBlockSize;
	int				iDecSymBS;
	int				iGuardSize;
	int				iTimeSyncPos;
	int				iDFTSize;

	int				rStartIndex;  // CFReal	

	int				iCenterOfBuf;

	_BOOLEAN			bSyncInput;

	_BOOLEAN			bInitTimingAcqu;
	_BOOLEAN			bTimingAcqu;
	_BOOLEAN			bRobModAcqu;
	_BOOLEAN			bAcqWasActive;

	int				iTiSyncInitCnt;
	int				iRobModInitCnt;

	int				iSelectedMode;

	CFComplexVector			cvecZ; //vbx
	CFComplexVector			cvecB; //vbx
	CVector<FComplex>		cvecOutTmpInterm;

	int 				rLambdaCoAv;  // CFReal

	/* Intermediate correlation results and robustness mode detection */
	CComplexVector			veccIntermCorrRes[NUM_ROBUSTNESS_MODES];
	CMatlibVector<int> 		vecrIntermPowRes[NUM_ROBUSTNESS_MODES];  // CFRealVector
	CVector<int>			iLengthIntermCRes;
	CVector<int>			iPosInIntermCResBuf;
	CVector<int>			iLengthOverlap;
	CVector<int>			iLenUsefPart;
	CVector<int>			iLenGuardInt;

	CComplexVector			cGuardCorr;
	CComplexVector			cGuardCorrBlock;
	CMatlibVector<int>		rGuardPow;       // CFRealVector
	CMatlibVector<int>		rGuardPowBlock;  // CFRealVector
 
	CMatlibVector<int>		vecrRMCorrBuffer[NUM_ROBUSTNESS_MODES]; // CFRealVector
	CMatlibVector<int>		vecrCos[NUM_ROBUSTNESS_MODES];          // CFRealVector
	int				iRMCorrBufSize;

#ifdef USE_FRQOFFS_TRACK_GUARDCORR
	FComplex			cFreqOffAv;
	CFReal				rLamFreqOff;
	CFReal				rNormConstFOE;
#endif

	int			GetIndFromRMode(ERobMode eNewMode);
	ERobMode	GetRModeFromInd(int iNewInd);
	void		SetFilterTaps(const CReal rNewOffsetNorm);

	virtual void InitInternal(CParameter& ReceiverParam);
	virtual void ProcessDataInternal(CParameter& ReceiverParam);
};


#endif // !defined(TIMESYNC_H__3B0BEVJBN872345NBEROUEBGF4344_BB27912__INCLUDED_)
