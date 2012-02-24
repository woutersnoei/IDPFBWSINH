(
/* -------------------------------------------------------------
 Mayke Nas & Wouter Snoei
 I Delayed People's Flights by Walking Slowly in Narrow Hallways

 software for live electonics

 written in SuperCollider 3.3

 with extra's installed:
 Quarks:   wslib

 (c) W. Snoei 2005-2008

------------------------------------------------------------- */

~nasPath = ~nasPath ?? { thisProcess.nowExecutingPath.dirname; };

Server.default = s = Server.internal;
if( s.options.device.notNil ) { 
	s.options.hardwareBufferSize = 128; 
} {
	s.options.hardwareBufferSize = 512; 
};

/*
~nasPath.openInFinder;
*/

~nasWaitWindow = Window( "starting up...", Rect( 0, 0, 400, 200 )
	.origin_( Rect( 0, 0, 400, 200 ).centerIn( Window.screenBounds ) ) ).front;
~nasWaitView = WaitView( ~nasWaitWindow, ~nasWaitWindow.view.bounds.insetBy( 20, 20 ) ).start;
~nasWaitWindow.onClose_({ ~nasWaitView.stop });


s.waitForBoot({	
	~nasWaitWindow.close;
	(~nasPath +/+ "buffers.scd").load;
	(~nasPath +/+ "synthdefs.scd").load;
	
	(
	(~nasPath +/+ "states_installation.scd").load;
	(~nasPath +/+ "window_installation.scd").load;
	(~nasPath +/+ "funcs_installation.scd").load;
	(~nasPath +/+ "inputs.scd").load;
	
	~nasCurrent = 0;
	~nasAction.value;
	);
});

);
