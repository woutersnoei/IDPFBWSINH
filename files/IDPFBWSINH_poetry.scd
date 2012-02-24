(
/* -------------------------------------------------------------
 Mayke Nas & Wouter Snoei
 I Delayed People's Flights by Walking Slowly in Narrow Hallways

 software for live electonics

 written in SuperCollider 3.3

 with extra's installed:
 Quarks:   wslib

 (c) W. Snoei 2005-2008
 
 ////// POETRY VERSION : SOME PARTS REMOVED
------------------------------------------------------------- */

~nasPath = ~nasPath ?? { thisProcess.nowExecutingPath.dirname; };

Server.default = s = Server.local;
s.quit;
s.options.hardwareBufferSize = 128;

// s.options.device = "";
// s.options.sampleRate = 48000; // for recording

(~nasPath +/+ "buffers.scd").load;
(~nasPath +/+ "synthdefs.scd").load;

(
(~nasPath +/+ "states_poetry.scd").load;
(~nasPath +/+ "window.scd").load;
(~nasPath +/+ "funcs_poetry.scd").load;
(~nasPath +/+ "inputs.scd").load;

~nasCurrent = 0;
~nasAction.value;
);

);
