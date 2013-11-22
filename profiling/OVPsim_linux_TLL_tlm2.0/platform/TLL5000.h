/*
 * Copyright (c) 2005-2010 Imperas Software Ltd., www.imperas.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#ifndef __TLL5000_H__
#define __TLL5000_H__



#include "tlm.h"
#include "TLL6219.h"
#include "CPLD.h"

#include "Adder.h"


class TLL5000
: public sc_core::sc_module
{
public:
    TLL5000 (sc_core::sc_module_name name, 
             TLL6219::bootConfig bconf );

private:
    const Addr        adderLow;
    const Addr        adderHigh;

    TLL6219           board1;          // ARM daughter board

    CPLD<0xCC000000, 1> bus;           // CPLD bus decoder (CS1 through CS5)

    Adder             adder;           // FPGA hardware
};




#endif
