/******************************************************************************\
 * Technische Universitaet Darmstadt, Institut fuer Nachrichtentechnik
 * Copyright (c) 2002
 *
 * Author(s):
 *	Volker Fischer
 *
 * Description:
 *	See Resampling.cpp
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

#if !defined(RESAMPLE_H__3B0FEUFE7876F_FE8FE_CA63_4344_1912__INCLUDED_)
#define RESAMPLE_H__3B0FEUFE7876F_FE8FE_CA63_4344_1912__INCLUDED_

#include "ResampleFilter.h"
#include "../GlobalDefinitions.h"
#include "../util/Vector.h"


/* Classes ********************************************************************/
class CResample
{
public:
	CResample() {}
	virtual ~CResample() {}

	void Init(const int iNewInputBlockSize);
	int Resample(CVector<_FREAL>* prInput, CVector<_FREAL>* prOutput,
				 _FREAL rRation);

protected:
	FXP			rTStep_fxp;
	FXP			rtOut_fxp;
	FXP			rBlockDuration_fxp;

	CShiftRegister<FXP>	vecrIntBuff_fxp;
	int			iHistorySize;

	int			iInputBlockSize;
};

class CAudioResample
{
public:
	CAudioResample() {}
	virtual ~CAudioResample() {}

	void Init(int iNewInputBlockSize, _REAL rNewRation);
	void Resample(CVector<_REAL>& rInput, CVector<_REAL>& rOutput);

protected:
	_REAL					rRation;

	CShiftRegister<_REAL>	vecrIntBuff;
	int						iHistorySize;

	int						iInputBlockSize;
	int						iOutputBlockSize;
};


#endif // !defined(RESAMPLE_H__3B0FEUFE7876F_FE8FE_CA63_4344_1912__INCLUDED_)
