(
~nasStates = [
 ( 	comment: "player #4 starts walking",
 	input: false,
 	b: [\button, 0, \volumeStopButton,1,\volumeSlider,1],
 	d: [\button, 0, \feedbackSlider, 0, \dispSlider, 0],
 	solo: [\button, 0, \timeStopButton,1,\timeSlider,0],
 	whisper: [\button, 0, \filterSlider, 0]
 	),

 ( 	comment: "all players have drawn one line",
 	text1: [ "", "", "", "|      " ],
 	a: true, rec: true, b: [\button,0,\volumeStopButton,1,\volumeSlider,1] ),

 ( 	comment: "the sentence is completed",
 	text1: [ " I ", "  CAME", "INTO", "THE WORLD." ],
 	a: true, b: [\button,1,\volumeSlider,0,\volumePlayButton,1], rec: true ),

 ( 	comment: "player #3 starts cleaning",
 	text1: [ " I ", "  CAME", "", "THE WORLD." ],
 	text2: [ "", "", "INTO", "" ],
	color2: Color(1.0, 1.0, 1.0, 0.5),
	playSlow: true,
	b: [\button,0,\volumeSlider,1,\volumeStopButton,1]
 	),

 ( 	comment: "player #3 stops cleaning",
 	text1: [ " I ", "BECAME", "", "THE WORLD." ],
 	whisper: true ),
 
 ( 	comment: "all players walk to boards and start cleaning",
 	text1: [ " I ", "BECAME", "", "THE WORLD." ],
 	var1: true
 	 ),

 (   comment: "all players stop cleaning",
 	whisper: true ),

 ( 	comment: "all players stop writing",
 	text1: [ "I MOVED", "I LOOKED", "I TOUCHED", "I TASTED" ],
 	b: true ),
 
 ( 	comment: "all players start cleaning ",
 	text1: [ "I MOVED", "I LOOKED", "I TOUCHED", "I TASTED" ],
 	var3: true ),

 ( 	comment: "all players stop cleaning",
 	text1: [ "I    ED", "I     ED", "I      ED", "I     ED" ],
 	whisper: true ),

 ( 	comment: "all players stop writing",
 	text1: [ "I LEARNED", "I LEARNED", "I LEARNED", "I LEARNED" ],
 	b: true ),

 ( 	comment: "all players walk to boards and start cleaning",
 	text1: [ "I LEARNED", "I LEARNED", "I LEARNED", "I LEARNED" ],
 	var4:true ),
 	
 ( 	comment: "all players stop cleaning",
 	whisper:true ),

 (	comment: "timed exactly on the dot (yellow)",
 	text1: [ "I SAiD I ", "I SAiD I ", "I SAiD I ", "I SAiD I " ],
	text2: [ "        .", "        .", "        .", "        ." ],
	color2: Color(0.8, 0.8, 0.0, 0.9) ),

 (	comment: "timed exactly on the first finger snap",
 	text1: [ "I SAiD I.", "I SAiD I.", "I SAiD I.", "I SAiD I." ],
 	str:true),

 (	comment: "players #1 and #2 stop cleaning",
 	text1: [ "", "", "I SAiD I.", "I SAiD I." ] ),

 ( 	comment: "players #3 and #4 start cleaning",
 	text1: [ "I APPROVED\nOF MYSELF.", "I DISAPPROVED\nOF MYSELF.", 
 		"I SAiD I.", "I SAiD I." ],
 	cl:true ),

 (	comment: "players #3 and #4 stop cleaning",
 	text1: [ "I APPROVED\nOF MYSELF.", "I DISAPPROVED\nOF MYSELF.", "", "" ],
 	cl:true ),

 (	comment: "players #1 and #2 start cleaning",
 	text1: [ "I APPROVED\nOF MYSELF.", "I DISAPPROVED\nOF MYSELF.", 
 		"I iNDULGED iN\n ", "I iNDULGED iN\n " ],
 	cl:true, cr:true ),

(	comment: "players #1 and #2 start writing",
 	text1: [ "", "", 
 		"I iNDULGED iN\nSELF-AFFiRMATiON.", "I iNDULGED iN\nSELF-EXPRESSiON." ],
 	cr:true ),
/*

 (	comment: "text on boards has changed to:",
 	text1: [ "I iNDULGED iN\nSELF-SATiSFACTiON.", "I iNDULGED iN\nSELF-ACCUSATiON.", 
 		"I iNDULGED iN\nSELF-", "I iNDULGED iN\nSELF-" ] ),

 (	comment: "text on boards has changed to:",
 	text1: [ "I iNDULGED iN\nSELF-SATiSFACTiON.", "I iNDULGED iN\nSELF-ACCUSATiON.", 
 		"I iNDULGED iN\nSELF-.....", "I iNDULGED iN\nSELF-PROMOTiON." ] ),

 (	comment: "text on boards has changed to:",
 	text1: [ "I iNDULGED iN\nSELF-DEFENCE.", "I iNDULGED iN\nSELF-DESTRUCTiON.", 
 		"I iNDULGED iN\nSELF-PiTY", "I iNDULGED iN\nSELF-....." ] ),

 (	comment: "text on boards has changed to:",
 	text1: [ "I iNDULGED iN\nSELF-.....", "I iNDULGED iN\nSELF-DOUBT.", 
 		"I iNDULGED iN\nSELF-.....", "I iNDULGED iN\nSELF-ESTEEM." ] ),

 (	comment: "text on boards has changed to:",
 	text1: [ "I iNDULGED iN\nSELF-SACRiFiCE.", "I iNDULGED iN\nSELF-.....", 
 		"I iNDULGED iN\nSELF-iSHNESS.", "I iNDULGED iN\nSELF-iNDULGENCE." ] ),
 */

 (	comment: "all players are only writing dots (...)",
 	text1: [ "I iNDULGED iN\nSELF-.....", "I iNDULGED iN\nSELF-.....", 
 	"I iNDULGED iN\nSELF-.....", "I iNDULGED iN\nSELF-....." ],
 	cl: true, cr: true ),
 
(	comment: "all players start cleaning",
 	text1: [ "I iNDULGED iN\nSELF-.....", "I iNDULGED iN\nSELF-.....", 
 	"I iNDULGED iN\nSELF-.....", "I iNDULGED iN\nSELF-....." ],
 	//solo: true, 
 	cl: true, cr: true ),

(	comment: "all players stop cleaning",
	// solo:true, 
	whisper:true ),

(	comment: "all players stop writing and return to seats",
 	text1: [ " I ", "USED", "SOUNDS", "THOUGHTLESSLY." ],
 	solo: [\button,1,\timeStopButton,1,\timeReturnButton,1], cl: true, cr: true
 	 ),
 	
 (	comment: "player #3 walks to board (about 2 minutes)",
 	text1: [ " I ", "USED", "SOUNDS", "THOUGHTLESSLY." ],
 	text2:  " (electronics solo) \n\n\n\n\n".dup(4),
 	color2: Color.yellow,
 	solo: [\button,1,\timePlayButton,1] ),
 	
  (	comment: "player #3 starts cleaning",
 	text1: [ " I ", "USED", "", "THOUGHTLESSLY." ],
 	text2: [ "", "", "SOUNDS", "" ],
	color2: Color(1.0, 1.0, 1.0, 0.5),
	solo: [\button,0,\timeStopButton,1,\timeReturnButton,1],
	d: [\button, 0, \feedbackSlider, 0, \dispSlider, 0],
	whisper: [\button, 0, \filterSlider, 0]),


 (	comment: "player #3 is stops cleaning",
 	text1: [ " I ", "USED", "", "THOUGHTLESSLY." ],
 	play:true
 	 ),
 	
 (	comment: "player #3 stops writing",
 	text1: [ " I ", "USED", "OBJECTS", "THOUGHTLESSLY." ],
 	d: [\button,1,\feedbackSlider,0.2,\dispSlider,0.05] ),
 	
  (	comment: "players #2 and #4 start cleaning",
 	text1: [ " I ", "", "OBJECTS", "" ],
 	text2: [ "", "USED", "", "THOUGHTLESSLY." ],
 	color2: Color(1.0, 1.0, 1.0, 0.5),
 	d: [\button,1,\feedbackSlider,0.2,\dispSlider,0.05] ),

 (	comment: "players #2 and #4 stop cleaning",
	text1: [ " I ", "", "OBJECTS", "" ],
	play: true ),

 (	comment: "player #3 starts cleaning",
 	text1: [ " I ", "CALLED", "OBJECTS", "DEAD." ],
 	d: [\button,1,\feedbackSlider,0.2,\dispSlider,0.05] 
 	),

 (	comment: "player #3 stops cleaning",
 	text1: [ " I ", "CALLED", "", "DEAD." ],
 	play: true ),

 (	comment: "player #3 stops writing",
 	text1: [ " I ", "CALLED", "GOD", "DEAD." ],
 	d: [\button,1,\feedbackSlider,0.2,\dispSlider,0.05] ),
 	
 (	comment: "player #4 starts cleaning",
 	text1: [ " I ", "CALLED", "GOD", "DEAD." ],
 	var2: true ),

 (	comment: "player #4 stops cleaning",
 	text1: [ " I ", "CALLED", "GOD", "" ],
 	play: true ),

 (	comment: "player #4 stops writing",
 	text1: [ " I ", "CALLED", "GOD", "INFALLIBLE" ],
 	d: [\button,1,\feedbackSlider,0.2,\dispSlider,0.1] ),
 
  (	comment: "player #3 starts cleaning",
 	text1: [ " I ", "CALLED", "GOD", "INFALLIBLE" ],
 	var3: true ),

 (	comment: "player #3 stops cleaning",
 	text1: [ " I ", "CALLED", "", "INFALLIBLE" ],
 	play: true ),

 (	comment: "player #3 stops writing",
 	text1: [ " I ", "CALLED", "ART", "INFALLIBLE" ],
 	d: [\button,1,\feedbackSlider,0.2,\dispSlider,0.2] ),
 	
  (	comment: "player #4 starts cleaning",
 	text1: [ " I ", "CALLED", "ART", "INFALLIBLE" ],
 	var4: true ),

 (	comment: "player #4 stops cleaning",
 	text1: [ " I ", "CALLED", "ART", "IN     BLE" ],
 	play: true ),

 (	comment: "player #4 stops writing",
 	text1: [ " I ", "CALLED", "ART", "IN     BLE" ],
	text2: [ "", "", "", "  valua   " ],
	color2: Color(0.8, 0.0, 0.0, 0.9),
	d: [\button,1,\feedbackSlider,0.3,\dispSlider,0.4] ),
	
	// ADDED/CHANGED FOR VIDEO VERSION
	
 (	comment: "player #3 starts cleaning",
 	text1: [ " I ", "CALLED", "ART", "IN     BLE" ],
 	text2: [ "", "", "", "  valua   " ],
	color2: Color(0.8, 0.0, 0.0, 0.9),
 	var2: true ),

 (	comment: "player #3 stops cleaning",
 	text1: [ " I ", "CALLED", "", "IN     BLE" ],
 	text2: [ "", "", "", "  valua   " ],
	color2: Color(0.8, 0.0, 0.0, 0.9),
 	play: true ),

 (	comment: "player #3 stops writing",
 	text1: [ " I ", "CALLED", "LOVE", "IN     BLE" ],
	text2: [ "", "", "", "  valua   " ],
	color2: Color(0.8, 0.0, 0.0, 0.9),
	d: [\button,1,\feedbackSlider,0.3,\dispSlider,0.4] ),
	
 (	comment: "player #4 starts cleaning",
 	text1: [ " I ", "CALLED", "LOVE", "IN     BLE" ],
 	text2: [ "", "", "", "  valua   " ],
	color2: Color(0.8, 0.0, 0.0, 0.9),
 	var4: true ),
 	
 (	comment: "player #4 stops cleaning",
 	text1: [ " I ", "CALLED", "LOVE", "" ],
 	play: true ),

 (	comment: "player #4 stops writing",
 	text1: [ " I ", "CALLED", "LOVE", "BLIND" ],
	d: [\button,1,\feedbackSlider,0.3,\dispSlider,0.4] ),
	
 (	comment: "all players start cleaning",
 	text1: [ " I ", "CALLED", "LOVE", "BLIND" ],
	var1: true ),

	// END ADDED/CHANGED FOR VIDEO VERSION

 (	comment: "all players stop cleaning",
 	whisper: true ),

 (	comment: "timed exactly on the last dot (yellow)",
 	text1: [ "I PLAYED\nWiTH\nFOOD ", "I PLAYED\nWiTH\nFiRE ", 
 		"I PLAYED\nWiTH\nHUMAN LiVES ", "I PLAYED\nWiTH\nMYSELF " ],
 	text2: [ "        \n \n    .", "        \n \n    .", 
 		"        \n \n           .", "        \n \n      ." ],
 	color2: Color(0.9, 0.9, 0.0, 1) ),

 ( 	comment: "all players start cleaning",
 	text1: [ "I PLAYED\nWiTH\nFOOD.", "I PLAYED\nWiTH\nFiRE.", 
 		"I PLAYED\nWiTH\nHUMAN LiVES.", "I PLAYED\nWiTH\nMYSELF." ],
 	str: true ),

 ( 	comment: "all players stop cleaning",
  	whisper: true ),
  	
  ( 	comment: "all players start writing" ),
 
 (	comment: "any player starts writing with wet chalk",
 	text1: ["I TWiSTED WORDS.
I FAKED iLLNESSES.
I FiNiSHED SENTENCES
OF PEOPLE STUTTERiNG
I TORE SCABS OFF
HALF-HEALED WOUNDS.
I SPERMED ON
RENTED CARPETS.", 
	"I OVERCOOKED PASTA.
I HELD MAPS UPSiDE DOWN.
I POSTPONED DiFFiCULT
CONVERSATiONS.
I DiDN'T READ THE MANUAL.
I LAUGHED AT OTHER
PEOPLE'S MISERY.", 
	"I LiED ABOUT MY AGE.
I BROKE PROMiSES.
I FORGOT TO TURN OFF MY
MOBiLE PHONE DURiNG CONCERTS.
I LOST BORROWED OBJECTS.
I DiDN'T LiVE UP TO 
EXPECTATiONS.", 
	"I CRiED FOR NO REASON.
I BELiEVED iN GOD.
I DELAYED PEOPLE'S FLiGHTS
BY WALKiNG SLOWLY iN
NARROW HALLWAYS.
I SPiLT THE BEANS.
I MISUSED GOVERNMENT PROPERTY."],
	d: [\button,1,\feedbackSlider,0.98,\dispSlider,0.7],
	rec: true,
	play: true
	),

 (	comment: "all players are done writing",
 	text1: ["I TWiSTED WORDS.
I FAKED iLLNESSES.
I FiNiSHED SENTENCES
OF PEOPLE STUTTERiNG
I TORE SCABS OFF
HALF-HEALED WOUNDS.
I SPERMED ON
RENTED CARPETS.", 
	"I OVERCOOKED PASTA.
I HELD MAPS UPSiDE DOWN.
I POSTPONED DiFFiCULT
CONVERSATiONS.
I DiDN'T READ THE MANUAL.
I LAUGHED AT OTHER
PEOPLE'S MISERY.", 
	"I LiED ABOUT MY AGE.
I BROKE PROMiSES.
I FORGOT TO TURN OFF MY
MOBiLE PHONE DURiNG CONCERTS.
I LOST BORROWED OBJECTS.
I DiDN'T LiVE UP TO 
EXPECTATiONS.", 
	"I CRiED FOR NO REASON.
I BELiEVED iN GOD.
I DELAYED PEOPLE'S FLiGHTS
BY WALKiNG SLOWLY iN
NARROW HALLWAYS.
I SPiLT THE BEANS.
I MISUSED GOVERNMENT PROPERTY."],
	text2: [ "I", "ASKED", "FOR", "IT" ],
	color2: Color(1.0, 1.0, 1.0, 0.25),
	d: [\button,1,\feedbackSlider,0.98,\dispSlider,0.95],
	play: true
	),
	
 (	comment: "all players start cleaning",
 	text1: ["I TWiSTED WORDS.
I FAKED iLLNESSES.
I FiNiSHED SENTENCES
OF PEOPLE STUTTERiNG
I TORE SCABS OFF
HALF-HEALED WOUNDS.
I SPERMED ON
RENTED CARPETS.", 
	"I OVERCOOKED PASTA.
I HELD MAPS UPSiDE DOWN.
I POSTPONED DiFFiCULT
CONVERSATiONS.
I DiDN'T READ THE MANUAL.
I LAUGHED AT OTHER
PEOPLE'S MISERY.", 
	"I LiED ABOUT MY AGE.
I BROKE PROMiSES.
I FORGOT TO TURN OFF MY
MOBiLE PHONE DURiNG CONCERTS.
I LOST BORROWED OBJECTS.
I DiDN'T LiVE UP TO 
EXPECTATiONS.", 
	"I CRiED FOR NO REASON.
I BELiEVED iN GOD.
I DELAYED PEOPLE'S FLiGHTS
BY WALKiNG SLOWLY iN
NARROW HALLWAYS.
I SPiLT THE BEANS.
I MISUSED GOVERNMENT PROPERTY."],
	input: false,
	text2: [ "I", "ASKED", "FOR", "IT" ],
	color2: Color(1.0, 1.0, 1.0, 0.25),
	d: [\button,1,\feedbackSlider,0.95,\dispSlider,0.95] ),

 (	comment: "all players are done cleaning",
 	text2: [ "I", "ASKED", "FOR", "IT" ],
	color2: Color(1.0, 1.0, 1.0, 0.2),
	d: [\button,1,\feedbackSlider,0.95,\dispSlider,0.95],
	playSlow: true,
	whisper: true ),

 (	comment: "the end",
 	text2: [ "I", "ASKED", "FOR", "IT" ],
	color2: Color(1.0, 1.0, 1.0, 0.5),
	input: false,
	d: [\button,1,\feedbackSlider,0.9,\dispSlider,0] ),
	
 (	comment: "--",
 	text2: [ "I", "ASKED", "FOR", "IT" ],
	color2: Color(1.0, 1.0, 1.0, 0.5),
	input: false )


]
);