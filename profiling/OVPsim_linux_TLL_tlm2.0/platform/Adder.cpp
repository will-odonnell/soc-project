/*
 *
 * My SystemC - TLM 2.0 adder example
 * Author: Pablo Salinas
 * Date: 01/25/2010
 * Comments: This simple adder do the following:
 * a) If the application writes to address X, the peripheral should check the address and store the received 32bits data in data member 'a'.
 * b) If the application writes to address Y, the peripheral should check the address and store the received 32bits data in data member 'b'.
 * c) If the application writes to address W, the peripheral should check the address and add 'a' and 'b' and store the result.
 * d) If the application reads from address W, the peripheral should return the previously stored result.
 *
*/

/*
 * Date: 01/28/10
 * Note2: This version adds an interrupt line from the external adder to the arm cpu in order
 * to signal whenever the addition was finished being performed.
*/


#include "Adder.h"

#include <ostream>


int Adder::do_add(int val1, int val2)         // actual adder behavior
{
  return val1 + val2;
}


// Constructor
Adder::Adder(sc_core::sc_module_name name)
  : sc_module(name)
{
  // Reset variables
  value1 = 0;
  value2 = 0;
  result = -1;
  
  // Register callback for incoming b_transport interface method call
  bus.register_b_transport(this, &Adder::initiatorTransport);
  bus.register_transport_dbg(this, &Adder::initiatorDebug);
}


// TLM transport methods  
void Adder::initiatorTransport(transaction_type& trans,
                              sc_core::sc_time& t)
{
  uint64 addr           = trans.get_address();
  unsigned int *dataPtr = (unsigned int*)trans.get_data_ptr();
  unsigned int len      = trans.get_data_length();
  
  unsigned int data     = *dataPtr;
  char *what;
  
  switch( trans.get_command() ) 
  {
    case TLM_READ_COMMAND :  
      what = "read";
      if (addr == 0xd3000000) // Return result
      {
          intr.write(0); // This would disable the interrupt line again
          
          data = result;
          memcpy(dataPtr, &data, len); 
      }
      break;

    case TLM_WRITE_COMMAND:  
      what = "write" ;  
      if (addr == 0xd3000000) // Do the addition - Any details regarding timing should go here
      {
          result = this->do_add(value1, value2);   
          intr.write(1);    // Signal an interrupt to the CPU
      }
      
      else if(addr == 0xd3000004) // Store the first operand
        this->value1 = data;
      
      else if(addr == 0xd3000008) // Store the second operand
        this->value2 = data;
      
      break;

    default               :  	
      what = "not interested";  
      break;
  }

  if (1) {
    cout << hex << "Peripheral " << name() << " "<< what << " addr: " << addr << " data: " << data << endl;
  }
  
  trans.set_response_status(tlm::TLM_OK_RESPONSE);
}

unsigned int Adder::initiatorDebug(transaction_type& trans)
{
  trans.set_response_status(tlm::TLM_OK_RESPONSE);
  return 0;
}

