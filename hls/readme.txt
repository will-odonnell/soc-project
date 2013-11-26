High Level Synthesis
---------------------------------------
Run Catapult from this directory

All the Catapult project files should be in this folder.  The output verilog files can be found in the Catapult project folders.


To select the project type:
 1. Uncomment or comment #define CATAPULT in the tb_viterbidecoder.cpp as needed.  This adds or removes Catapult macros.

To create the Catapult project:
 1. Add all the .cpp and .h files 
 2. Exclude all files except ViterbiDecoder.cpp and ViterbiDecoder.h from compilation in Catapult
 3. Run Setup Design and Architecture Constraints

To create standalone project:
 1. On the SOC machines, run script build_and_run_socX
 2. On an Ubunut machine, run script buid_and_run_ubuntu

The two version of the build scrip exist because the SOC machine seems to include the new standard C++ library.  The Ubuntu version uses a newer
g++ compiler and seems to need this library explicitly included.  
