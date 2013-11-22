/*
 *
 * My SystemC - TLM 2.0 adder example
 * Author: Pablo Salinas
 * Date: 01/25/2010
*/


#ifndef _ADDER_PERIPH_H_
#define _ADDER_PERIPH_H_


#include "tlm.h"
#include "tlm_utils/simple_target_socket.h"


using namespace sc_core;
using namespace sc_dt;
using namespace tlm;
using namespace std;
	

SC_MODULE(Adder)          // declare adder sc_module
{
public:

  typedef tlm_utils::simple_target_socket<Adder> target_socket_type;
  typedef tlm_generic_payload                    transaction_type;

  tlm_analysis_port<int> intr;  //This is the interface that would work as an interrupt.
				//Contrary to the more general OVP peripheral example,
				//I only used one interrupt line as permited.

  target_socket_type bus;

private:

  int do_add(int val1, int val2);         // actual adder behavior


public:
  int value1, value2, result;

  // Constructor
  Adder(sc_core::sc_module_name name);
  
  // TLM transport methods
  void initiatorTransport(transaction_type& trans,
                          sc_core::sc_time& t);
  unsigned int initiatorDebug(transaction_type& trans);
};

#endif
