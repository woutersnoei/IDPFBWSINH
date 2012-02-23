(
/* -------------------------------------------------------------
 Mayke Nas & Wouter Snoei
 I Delayed People's Flights by Walking Slowly in Narrow Hallways

 software for live electonics

 written in SuperCollider 3.3

 with extra's installed:
 Quarks:   wslib
 
 Standalone Version - can also be used in SuperCollider by extracting from Resources folder

 © W. Snoei 2005-2008
 
 
 /// MODIFIED FOR RECORDING /// !!
------------------------------------------------------------- */

~nasPath = ~nasPath ?? { Document.current.path.dirname; };

Server.default = s = Server.internal;
//s.quit;
if( s.options.device.notNil ) { 
	s.options.hardwareBufferSize = 128; 
} {
	s.options.hardwareBufferSize = 512; 
};

// s.options.device = "";
// s.options.sampleRate = 48000; // for recording

~nasWaitWindow = Window( "starting up...", Rect( 0, 0, 400, 200 )
	.origin_( Rect( 0, 0, 400, 200 ).centerIn( Window.screenBounds ) ) ).front;
~nasWaitView = WaitView( ~nasWaitWindow, ~nasWaitWindow.view.bounds.insetBy( 20, 20 ) ).start;
~nasWaitWindow.onClose_({ ~nasWaitView.stop });


s.waitForBoot({	
	~nasWaitWindow.close;
	(~nasPath +/+ "buffers.scd").load;
	(~nasPath +/+ "synthdefs.scd").load;
	
	(
	(~nasPath +/+ "levels.scd").load;
	(~nasPath +/+ "states_full.scd").load;
	(~nasPath +/+ "window.scd").load;
	(~nasPath +/+ "funcs.scd").load;
	(~nasPath +/+ "inputs.scd").load;
	
	
	~nasCurrent = 0;
	~nasAction.value;
	);
});

);
