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
//s.options.hardwareBufferSize = 256;

/*
~nasPath.openInFinder;
*/

//s.options.device = "U24XL";
// s.options.sampleRate = 48000; // for recording

~nasWaitWindow = Window( "starting up...", Rect( 0, 0, 400, 200 )
	.origin_( Rect( 0, 0, 400, 200 ).centerIn( Window.screenBounds ) ) ).front;
~nasWaitView = WaitView( ~nasWaitWindow, ~nasWaitWindow.view.bounds.insetBy( 20, 20 ) ).start;
~nasWaitWindow.onClose_({ ~nasWaitView.stop });


s.waitForBoot({	
	~nasWaitWindow.close;
	(~nasPath +/+ "buffers.rtf").load;
	(~nasPath +/+ "synthdefs.rtf").load;
	
	(
	(~nasPath +/+ "states_installation.rtf").load;
	(~nasPath +/+ "window_installation.rtf").load;
	(~nasPath +/+ "funcs_installation.rtf").load;
	(~nasPath +/+ "inputs.rtf").load;
	
	~nasCurrent = 0;
	~nasAction.value;
	);
});

);
