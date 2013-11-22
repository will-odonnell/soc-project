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

#ifndef __TLL6219_H__
#define __TLL6219_H__



#include "tlm.h"

#include "ovpworld.org/modelSupport/tlmPlatform/1.0/tlm2.0/platform.hpp"
#include "ovpworld.org/modelSupport/tlmDecoder/1.0/tlm2.0/decoder.hpp"
#include "ovpworld.org/modelSupport/tlmMemory/1.0/tlm2.0/memory.hpp"
#include "arm.ovpworld.org/processor/arm/1.0/tlm2.0/processor.igen.hpp"
#include "arm.ovpworld.org/peripheral/CoreModule9x6/1.0/tlm2.0/pse.igen.hpp"
#include "arm.ovpworld.org/peripheral/IntICP/1.01/tlm2.0/pse.igen.hpp"
#include "arm.ovpworld.org/peripheral/IcpCounterTimer/1.0/tlm2.0/pse.igen.hpp"
#include "arm.ovpworld.org/peripheral/IcpControl/1.0/tlm2.0/pse.igen.hpp"
#include "arm.ovpworld.org/peripheral/DebugLedAndDipSwitch/1.0/tlm2.0/pse.igen.hpp"
#include "arm.ovpworld.org/peripheral/KbPL050/1.0/tlm2.0/pse.igen.hpp"
#include "arm.ovpworld.org/peripheral/RtcPL031/1.0/tlm2.0/pse.igen.hpp"
#include "arm.ovpworld.org/peripheral/UartPL011/1.0/tlm2.0/pse.igen.hpp"
#include "arm.ovpworld.org/peripheral/MmciPL181/1.0/tlm2.0/pse.igen.hpp"
#include "arm.ovpworld.org/peripheral/SmartLoaderArmLinux/1.0/tlm2.0/pse.igen.hpp"



class TLL6219
: public sc_core::sc_module
{
public:
    typedef tlm::tlm_initiator_socket<> initiator_socket_type;

    initiator_socket_type emi;

public:
    typedef enum bootConfigE { BCONF_UBOOT, BCONF_LINUX, BCONF_BAREMETAL } bootConfig;

    TLL6219 (sc_core::sc_module_name name, bootConfig bconf);

    icmInputNetPort *externalInterrupt(void) {
        return &pic1.ir9;
    }

private:
    icmTLMPlatform    platform;  // platform construction
    decoder<3, 15>    bus;       // simple bus decoder  <1,32>

    // --- i.MX21

    arm               arm1;      // Processor core

    SmartLoaderArmLinux	smartLoader; // Smart Loader

    CoreModule9x6     cm;        // Integrator Core Module 9x6
    IntICP            pic1;      // Integrator Board interrupt controller
    IntICP            pic2;      // Integrator Board interrupt controller

    IcpCounterTimer   pit;       // Timer module

    RtcPL031          rtc;       // RTC

    UartPL011         uart1;     // UART
    UartPL011         uart2;     // UART


    // --- TLL6219 base board

    IcpControl        icp;       // Board controller

    KbPL050           kb1;       // Keyboard
    KbPL050           ms1;       // Mouse

    MmciPL181         mmci;      // Multimedia Card Interface

    DebugLedAndDipSwitch led1;

    ram               ram1;      // RAM
    ram               ram2;      // ambaDummy


    icmAttrListObject *attrsForarm1() {
        icmAttrListObject *userAttrs = new icmAttrListObject;
        userAttrs->addAttr("showHiddenRegs", "0");
        userAttrs->addAttr("compatibility", "ISA");
        userAttrs->addAttr("variant", "ARM926EJ-S");
        userAttrs->addAttr("endian", "little");
        userAttrs->addAttr("mips", 200);
        userAttrs->addAttr("override_debugMask",0);
        return userAttrs;
    }

    icmAttrListObject *attrsForkb1() {
        icmAttrListObject *userAttrs = new icmAttrListObject;
        userAttrs->addAttr("isMouse", 0);
        userAttrs->addAttr("grabDisable", 0);
        return userAttrs;
    }

    icmAttrListObject *attrsForms1() {
        icmAttrListObject *userAttrs = new icmAttrListObject;
        userAttrs->addAttr("isMouse", 1);
        userAttrs->addAttr("grabDisable", 1);
        return userAttrs;
    }

    icmAttrListObject *attrsForuart1() {
        icmAttrListObject *userAttrs = new icmAttrListObject;
        userAttrs->addAttr("portnum", 9000);
        userAttrs->addAttr("finishOnDisconnect", "on");
        // userAttrs->addAttr("outfile", "uart1.log");
        userAttrs->addAttr("variant", "ARM");
        return userAttrs;
    }

    icmAttrListObject *attrsForuart2() {
        icmAttrListObject *userAttrs = new icmAttrListObject;
        userAttrs->addAttr("outfile", "uart2.log");
        userAttrs->addAttr("variant", "ARM");
        return userAttrs;
    }

    icmAttrListObject *attrsForsmartLoader(bootConfig bc) {
        icmAttrListObject *userAttrs = new icmAttrListObject;
        // Local Image
        userAttrs->addAttr("initrd", "fs.img");
        userAttrs->addAttr("kernel", "zImage");
        if (bc != BCONF_LINUX) {
            userAttrs->addAttr("disable", "True");
        }
        return userAttrs;
    }
};




#endif
