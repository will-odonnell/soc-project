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


#include "TLL6219.h"

#include <iostream>



TLL6219::TLL6219  ( sc_core::sc_module_name name, bootConfig bconf )
  : sc_core::sc_module (name)

  , platform ("icm", ICM_VERBOSE | ICM_STOP_ON_CTRLC| ICM_ENABLE_IMPERAS_INTERCEPTS | ICM_WALLCLOCK)
  , bus ("bus")
  , arm1 ( "arm1", 0, ICM_ATTR_SIMEX | ICM_ATTR_TRACE_ICOUNT | ICM_ATTR_RELAXED_SCHED, attrsForarm1())
  , smartLoader ("smartLoader", attrsForsmartLoader(bconf))
  , cm ("cm")
  , pic1 ("pic1")
  , pic2 ("pic2")
  , pit ("pit")
  , rtc ("rtc")
  , uart1 ("uart1", attrsForuart1())
  , uart2 ("uart2", attrsForuart2())
  , icp ("icp")
  , kb1 ("kb1", attrsForkb1())
  , ms1 ("ms1", attrsForms1())
  , mmci ("mmci")
  , led1 ("led1")
  , ram1 ("ram1", "sp1", 0x8000000)
  , ram2 ("ram2", "sp1", 0x1000)

 {
    // --- i.MX21

    // ARM9 CPU
    arm1.INSTRUCTION.socket(bus.target_socket[0]);
    arm1.DATA.socket(bus.target_socket[1]);
    smartLoader.mport.socket(bus.target_socket[2]);

    // Core Module 9x6
    bus.initiator_socket[1](cm.bport1.socket);
    bus.setDecode(1, 0x10000000, 0x10000fff);

    // Interrupt controller 1
    bus.initiator_socket[2](pic1.bport1.socket);
    bus.setDecode(2, 0x14000000, 0x14000fff);

    // Interrupt controller 2
    bus.initiator_socket[3](pic2.bport1.socket);
    bus.setDecode(3, 0xca000000, 0xca000fff);

    // IPC Timer Module
    bus.initiator_socket[4](pit.bport1.socket);
    bus.setDecode(4, 0x13000000, 0x13000fff);

    // RTC
    bus.initiator_socket[5](rtc.bport1.socket);
    bus.setDecode(5, 0x15000000, 0x15000fff);

    // UART 1
    bus.initiator_socket[6](uart1.bport1.socket);
    bus.setDecode(6, 0x16000000, 0x16000fff);

    // UART 2
    bus.initiator_socket[7](uart2.bport1.socket);
    bus.setDecode(7, 0x17000000, 0x17000fff);

    // Connectivity
    pic1.irq(arm1.irq);
    pic1.fiq(arm1.fiq);

    uart1.irq.bind(pic1.ir1);
    uart2.irq.bind(pic1.ir2);

    pit.irq0.bind(pic1.ir5);
    pit.irq1.bind(pic1.ir6);
    pit.irq2.bind(pic1.ir7);

    rtc.irq(pic1.ir8);


    // --- TLL6219 base board

    // Board controller
    bus.initiator_socket[8](icp.bport1.socket);
    bus.setDecode(8, 0xcb000000, 0xcb00000f);

    // Keyboard interface
    bus.initiator_socket[9](kb1.bport1.socket);
    bus.setDecode(9, 0x18000000, 0x18000fff);

    // Mouse interface
    bus.initiator_socket[10](ms1.bport1.socket);
    bus.setDecode(10, 0x19000000, 0x19000fff);

    // MMCI
    bus.initiator_socket[11](mmci.bport1.socket);
    bus.setDecode(11, 0x1c000000, 0x1c000fff);

    // LEDs and DIP switches
    bus.initiator_socket[12](led1.bport1.socket);
    bus.setDecode(12, 0x1a000000, 0x1a000fff);

    // Memory
    bus.initiator_socket[13](ram1.sp1);
    bus.setDecode(13, 0x0, 0x7ffffff);

    // Memory
    bus.initiator_socket[14](ram2.sp1);
    bus.setDecode(14, 0x1d000000, 0x1d000fff);

    // EMI
    bus.initiator_socket[0](emi);
    bus.setDecode(0, 0xcc000000, 0xd3ffffff);
    

    // Connectivity
    kb1.irq(pic1.ir3);
    ms1.irq(pic1.ir4);

    mmci.irq0(pic1.ir23);
    mmci.irq1(pic1.ir24);


    // --- Simulation parameters

    arm1.setIPS(200000000);
    cm.setDiagnosticLevel(3);
    uart1.setDiagnosticLevel(1);
    uart2.setDiagnosticLevel(1);
    smartLoader.setDiagnosticLevel(7);

}



