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




#include "TLL5000.h"                    // top module

#include "tlm.h"                        // TLM header
//#include "systemc.h"



int sc_main (int argc, char *argv[] )
{
    sc_report_handler::set_actions("/IEEE_Std_1666/deprecated", SC_DO_NOTHING);

    sc_set_time_resolution(1,SC_NS);

    TLL6219::bootConfig bc = TLL6219::BCONF_LINUX;

    int i;
    for(i=1; i < argc; i++) {
        if (strcmp(argv[i], "u") == 0) {
          bc = TLL6219::BCONF_UBOOT;
        } else if (strcmp(argv[i], "l") == 0) {
          bc = TLL6219::BCONF_LINUX;
        } else if (strcmp(argv[i], "b") == 0) {
          bc = TLL6219::BCONF_BAREMETAL;
        } else {
          cout << "Usage: TLL_tlm2.0.exe [u|l|b]" << endl;
          cout << "       u = U-Boot: l = Linux:  b = Bare metal" << endl;
          exit(0);
          break;
        }
    }

    // Ignore some of the Warning messages
    icmIgnoreMessage ("ICM_NPF");

    cout << "Constructing." << endl;
    TLL5000 top("top", bc);

    cout << "default time resolution = " << sc_get_time_resolution() << endl;

    // start the simulation
    cout << "Starting sc_main." << endl;
    sc_start();

    cout << "Finished sc_main." << endl;
    return 0;                             // return okay status
}
