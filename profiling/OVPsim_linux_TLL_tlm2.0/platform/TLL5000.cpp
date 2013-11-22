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


#include "TLL5000.h"



TLL5000::TLL5000  ( sc_core::sc_module_name name, 
                    TLL6219::bootConfig bconf )
  : sc_core::sc_module (name)

  , adderLow  ( 0xd3000000 )
  , adderHigh ( 0xd300000c )

  , board1  ("board1", bconf )

  , bus     ("bus")

  , adder   ("adder")

{
    board1.emi(bus.target_socket);

    // FPGA hardware
    bus.initiator_socket[0](adder.bus);
    bus.setDecode(0, adderLow, adderHigh);
    adder.intr.bind(*board1.externalInterrupt());
}

