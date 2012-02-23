(
/* -------------------------------------------------------------
 Mayke Nas & Wouter Snoei
 I Delayed People's Flights by Walking Slowly in Narrow Hallways

 software for live electonics

 written in SuperCollider 3.3

 with extra's installed:
 Quarks:   wslib

 © W. Snoei 2005-2008
 
 ////// POETRY VERSION 
 
 /// MODIFIED FOR RECORDING /// !!
------------------------------------------------------------- */

~nasPath = Document.current.path.dirname;

Server.default = s = Server.local;
s.quit;
s.options.hardwareBufferSize = 128;

// s.options.device = "";
// s.options.sampleRate = 48000; // for recording

(~nasPath +/+ "buffers.rtf").load;
(~nasPath +/+ "synthdefs.rtf").load;

(
(~nasPath +/+ "states_poetry.rtf").load;
(~nasPath +/+ "window.rtf").load;
(~nasPath +/+ "funcs_poetry.rtf").load;
(~nasPath +/+ "inputs.rtf").load;

~nasCurrent = 0;
~nasAction.value;
);

);
