(
(
~nasWindow = GUI.window.new( "IDPFBWSINH", Rect(385, 241, 740, 580) ).front;

~nasWindow.view.decorator = FlowLayout( ~nasWindow.view.bounds );

);
(
~nasTasks = [];
~nasAction = { var state, keys;
	//"action".postln;
	state = ~nasStates[ (~nasCurrent ? 0).max(0) ];
	~nasTasks.do(_.stop); ~nasTasks = [];
	~nasTexts = state[ \text1 ];
	~nasTexts2 = state[ \text2 ];
	~nasTexts2Color = state[ \color2 ] ?? { Color.white.alpha_(0.9) };
	~nasCommentView.string = (state[ \comment ] ? "");
	
	~nasInputs[ \active ].valueAction =  (state[ \input ] != false).binaryValue;
	keys = state.keys;
	
	~nasFuncs.do({ |func,i|
		if( keys.includes( func.name ) )
			{ if( state[func.name] == true )
				{ func[ \button ].valueAction = 1 };
			  if(  state[func.name].isArray )
			  	{  state[func.name].pairsDo({ |key, value|
			  		var startVal;
			  		if( value.isArray )
			  			{ startVal = func[ key ].value;
			  			  ~nasTasks = ~nasTasks.add( Task({
			  			  	//"task added".postln;
			  				(value[1]*20).do({ |i|
			  					0.02.wait;
			  					{ func[ key ].valueAction = startVal.blend( value[0],
			  						 (i+1)/(value[1]*20)  ); }.defer;
			  					});
			  				}).start );
			  			}
			  			{  func[ key ].valueAction = value; };
			  		});
			  	};
			   }
			{ func[ \button ].valueAction = 0 }
		});	
	
	~nasWindow.refresh;
	};
	
~nasAuto = ( start: {
	~nasAuto[ \task ].stop;
	~nasAuto[ \task ] = Task({
		inf.do({
			{ ~naNumberBox.valueAction = (~naNumberBox.value + 1).asInt.wrap(1,7); }.defer;
			(30 rrand: 60).wait;
		})
	}).start;
},
stop: { ~nasAuto[ \task ].stop;  ~nasAuto[ \task ] = nil; }
);
);

(
~nasAutoButton = RoundButton( ~nasWindow, 50@30 )
	.states_([[ "auto" ], [ "auto", Color.gray(0.8), Color.black ]])
	.action_({ |bt| switch( bt.value,
			1, { ~nasAuto[ \start ].value; },
			0, { ~nasAuto[ \stop ].value; })
	});


~naNumberBox = NumberBox( ~nasWindow, 50@30 )
	.font_( Font( "Monaco", 24 ) )	
	.clipLo_(0).value_(0).clipHi_( ~nasStates.size-1 )
	.action_({ |nb|
		~nasCurrent = nb.value;
		~nasAction.value;
		});
		
~nasNextButton = RoundButton( ~nasWindow, 40@30 ).states_([[ 'play' ]]).action_({
	~naNumberBox.valueAction = ~naNumberBox.value + 1;
	}).canFocus_(false);

	
~nasResetButton = RoundButton( ~nasWindow, 30@30 ).states_([[ 'return' ]]).action_({
	~naNumberBox.valueAction = 0;
	}).canFocus_(false);

~nasWindow.view.keyDownAction_({ |view,char,mod,a,b| 
	if( char == $ ) { ~naNumberBox.valueAction = ~naNumberBox.value + 1; }; // space
	if( a == 127  ) { ~naNumberBox.valueAction = 0; }; // backspace
 	});
	
~nasCommentView0 = GUI.staticText.new(~nasWindow, 120@30  ).font_( Font( "Courier", 16 ) )
	.string_( "cue:" ).stringColor_( Color.red(0.4) ).align_(\center);
~nasCommentView = GUI.staticText.new(~nasWindow, 416@30  ).font_( Font( "Courier", 16 ) );
	
~nasWindow.view.decorator.nextLine;

LineView( ~nasWindow, 732@2 );

~nasBoards = { |i| GUI.userView.new( ~nasWindow, Rect( 10 + (i * 200), 10, 180, 120 ) )
	.relativeOrigin_( false ) } ! 4;
	
LineView( ~nasWindow, 732@2 );

);
(
~nasBoards.do({ |board, i|
	board.drawFunc_({ |view|
		var stringbounds, bounds;
		GUI.pen.color_( Color.blue(0.1).alpha_(0.9) );
		GUI.pen.fillRect( view.bounds );
		
		if( ~nasTexts2.notNil )
			{
			
		stringbounds = ~nasTexts2[i].bounds( Font( "Courier New", 48 ));
		bounds = view.bounds.insetBy( 5,5 );
		GUI.pen.use({	
			GUI.pen.color_( ~nasTexts2Color );
			GUI.pen.font_( Font( "Courier New", 48 ) );
			GUI.pen.translate( bounds.left, bounds.top );
			GUI.pen.scale( 
				bounds.width / stringbounds.width,
				bounds.height / stringbounds.height );
			GUI.pen.stringAtPoint( ~nasTexts2[i], 0@0 );
			});

			};
			
		if( ~nasTexts.notNil )
			{
		stringbounds = ~nasTexts[i].bounds( Font( "Courier New", 48 ));
		bounds = view.bounds.insetBy( 5,5 );
		GUI.pen.use({	
			GUI.pen.color_( Color.white.alpha_(0.9) );
			GUI.pen.font_( Font( "Courier New", 48 ) );
			GUI.pen.translate( bounds.left, bounds.top );
			GUI.pen.scale( 
				bounds.width / stringbounds.width,
				bounds.height / stringbounds.height );
			GUI.pen.stringAtPoint( ~nasTexts[i], 0@0 );
			});
			};
		
			});
			
	});
~nasWindow.refresh;
);

/*
(
~nasButtonsComposite = GUI.compositeView.new( ~nasWindow, Rect( 10, 150, 780, 120 )).flow({ |view|
	~nasButtons = ~nasStates.collect({ |func,i|
		RoundButton( view, 15@15 ).radius_(0)
			.states_( [[ i.asString ]] ).font_( Font( "Monaco", 9 ) )
			.action_({ func.value });
		});
	});
);
*/


// ~nasCurrent = 0;
// ~nasAction.value;
)