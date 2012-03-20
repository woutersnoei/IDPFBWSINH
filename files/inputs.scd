(
(
// NAS GUI input router GUI

~nasInputs = ();

~nasInputs[\container] = GUI.compositeView.new( ~nasWindow, 325@444  );

~nasInputs[\container].background_( Color.gray.alpha_(0.25) );
~nasInputs[\container].decorator = FlowLayout( ~nasInputs[\container].bounds );

~nasInputs[\mode] = 4;

~nasInput = ~nasInput ? 0; // input offset

~nasInputs[\args] = (bus:4, hiShelf:2, lowCut:200, tresh:-75, level:1);

~nasInputs[\startFunc] = { |evt|
	evt[\synth].release; evt[\synth] = Synth( "nas-inputs-" ++ ~nasInputs[\mode],
		~nasInputs[\args].asArgsArray ++ [ \in, ~nasInput ], s, \addToHead );
	};

~nasInputs[\stopFunc] = { |evt| evt[\synth].release; evt[\synth] = nil; };

~nasInputs[\setArgs] = { |evt| evt[\synth].set( 
	*( ~nasInputs[\args].asArgsArray ++  [ \in, ~nasInput ] )); 
};

GUI.staticText.new(  ~nasInputs[\container], 120@16 ).string_( "Inputs" )
	.font_( Font( "Monaco", 9 ) );

~nasInputs[\container].decorator.nextLine;

~nasInputs[ \active ] = RoundButton( ~nasInputs[\container], 100@20 )
	.font_( Font( "Monaco", 9 ) )
	.states_([["active"],["active", Color.gray(0.8), Color.black]])
	.action_({ |bt|
		switch( bt.value, 1, { ~nasInputs.startFunc; }, 0, { ~nasInputs.stopFunc; });
		})
	.canFocus_(false);

		
~nasInputs[ \modeView ] = GUI.popUpMenu.new(~nasInputs[\container], 100@20 )
	.font_( Font( "Monaco", 9 ) )
	.items_(["2 inputs", "4 inputs"])
	.action_({ |pu| ~nasInputs[ \mode ] = [2,4][pu.value];
		 })
	.value_((2:0,4:1)[~nasInputs[\mode]])
	.canFocus_(false)
	.visible_(true);
	
~nasInputs[\container].decorator.nextLine;

~nasInputs[\argsViews] = ();

~nasInputs[\argsViews][ \input ] = NumberBox( ~nasInputs[\container], 60@20 )
	.font_( Font( "Monaco", 9 ) )
	.value_( ~nasInput ).clipLo_(0).clipHi_(17).step_(1)
	.action_({ |nb| ~nasInput = nb.value; ~nasInputs.setArgs; });
GUI.staticText.new(  ~nasInputs[\container], 140@20 )
	.font_( Font( "Monaco", 9 ) )
	.string_( "input channel offset" );
~nasInputs[\container].decorator.nextLine;

~nasInputs[\argsViews][ \output ] = NumberBox( ~nasInputs[\container], 60@20 )
	.font_( Font( "Monaco", 9 ) )
	.value_( ~nasOutput ).clipLo_(0).clipHi_(17).step_(1)
	.action_({ |nb| ~nasOutput = nb.value; });
GUI.staticText.new(  ~nasInputs[\container], 140@20 )
	.font_( Font( "Monaco", 9 ) )
	.string_( "output channel offset" );
~nasInputs[\container].decorator.nextLine;

~nasInputsMakeArgsView = { |label, value, argName, min, max,step=1|
	~nasInputs[\argsViews][ argName ] = 
	NumberBox( ~nasInputs[\container], 60@20 ).font_( Font( "Monaco", 9 ) )
		.value_( value ).clipLo_(min).clipHi_(max).step_(step)
		.action_({ |nb| ~nasInputs[\args][ argName ] = nb.value;
			~nasInputs.setArgs;
			     });
	GUI.staticText.new(  ~nasInputs[\container], 140@20 ).font_( Font( "Monaco", 9 ) )
		.string_( label );
	~nasInputs[\container].decorator.nextLine;
		};
		
[ 
[ "dB gate treshold", ~nasInputs[\args][ \tresh ], \tresh, -120,0],
[ "dB high shelf 1200Hz", ~nasInputs[\args][ \hiShelf ], \hiShelf, -12,12],
[ "Hz low cut", ~nasInputs[\args][ \lowCut ], \lowCut, 20,400]
].do({ |item| ~nasInputsMakeArgsView.value( *item ); });

RoundButton( ~nasInputs[\container], 100@20 )
	.font_( Font( "Monaco", 9 ) ).states_( [["level meters"]] )
	.action_({ |bt| s.meter; })
	.canFocus_(false);

~nasInputs[\container].decorator.nextLine;

RoundButton( ~nasInputs[\container], 100@20 )
	.font_( Font( "Monaco", 9 ) ).states_( [["master EQ"]] )
	.action_({ |bt| MasterEQ(2); })
	.canFocus_(false);
	
~nasInputs[\container].decorator.nextLine;

RoundButton( ~nasInputs[\container], 100@20 )
	.font_( Font( "Monaco", 9 ) ).states_( [["Help"]] )
	.action_({ |bt| "".openHelpFile; })
	.canFocus_(false);

/*
GUI.staticText.new( ~nasInputs[\container], 120@20 ).font_( Font( "Monaco", 9 ) )
		.string_( "peak level meters" );
~nasInputs[\container].decorator.nextLine;

~nasInputs[\levelMeters] = 2.collect({ |i|
	GUI.staticText.new( ~nasInputs[\container], 40@20 ).font_( Font( "Monaco", 9 ) )
		.string_( "-inf" );
	});
	

~nasInputs[\levelMetersSwitch] = RoundButton( ~nasInputs[\container], 30@20 )
	.font_( Font( "Monaco", 9 ) ).states_( [["on"],["on", Color.gray(0.8),Color.black]] )
	.action_({ |bt| switch(bt.value, 
		1, {~nasInputs[\levelMeterResponder].add; },
		0, {~nasInputs[\levelMeterResponder].remove; });
		}).value_(0)
	.canFocus_(false);
			
~nasInputs[\levelMetersReset] = RoundButton( ~nasInputs[\container], 50@20 )
	.font_( Font( "Monaco", 9 ) ).states_( [["reset"]] ).action_({ 
			~nasInputs[\synth].set( 't_resetPeak', 1 ); 
			~nasInputs[\levelMeters].do(_.string_("-inf"))
			})
	.canFocus_(false);

~nasInputs[\levelMeterResponder] = OSCresponder(s.addr, '/tr', { arg time, responder, msg;
	 if( ~nasWindow.isClosed ) { responder.remove } { 
	 	case { (msg[2] / 10).floor == 1 } // gate
			{ // "gate %\n".postf(msg[3]);
				{ if( ~nasWindow.isClosed.not ) { 
				~nasInputs[\levelMeters][ msg[2] - 10 ].background =
					[ Color.clear, Color.green.alpha_(0.8)][ msg[3] ] }; }.defer;
			 }
			 { (msg[2] / 10).floor == 2 } // peak
			 {  { if( ~nasWindow.isClosed.not ) { 
				~nasInputs[\levelMeters][ msg[2] - 20 ].string =
					 msg[3].round(1).asString  }; }.defer;
			  };
		 };
	});	


~nasInputs[\synth].set( 't_resetPeak', 1 );
*/

)
);
