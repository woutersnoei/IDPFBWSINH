(
// NAS GUI functions (and gui elements)
(
~nasFuncs = ();

// function names
[ 
['a', "rt-effect A      ", "nas-rtfx-a"],  // 0
['b', "rt-effect B      ", "nas-rtfx-b"],
['cl', "rt-effect C left ", "nas-rtfx-c.2"],
['cr', "rt-effect C right", "nas-rtfx-c.3"],
['d', "rt-effect D      ", "nas-rtfx-d"],
['rec', "record buffer     ", "nas-buf-rec"],  // 5
['play', "  play buffer     ", "nas-buf-straight"],
['playSlow', "  play buffer slow", "nas-buf-slow"],
['var1', "buffer variation 1", "nas-buf-v1"],		// 8
['var2', "buffer variation 2", "nas-buf-v2"],
['var3', "buffer variation 3", "nas-buf-v3"],
['var4', "buffer variation 4", "nas-buf-v4"],
['whisper', "whisper", "nas-whisper"],				//12
['solo', "electronics solo", "nas-rtfx-c-auto"],		//13
['str', "play one stripe", "nas-stripe"],
].do({ |item,i| 
	~nasFuncs[ item[0] ] = (
		label: item[1], 
		name: item[0], 
		defName: item[2], 
		id:i,
		level: 1,
		playFunc: { |evt ...args| evt[\synth].release; 
			evt[\synth] = Synth( evt[\defName], args, s, \addToTail );
			},
		stopFunc: { |evt| evt[\synth].release; evt[\synth]=nil; },
		setLevel: { |evt, level| 
			evt[\level] = ~nasDBWarp.map(level).dbamp;
			evt[\synth].set(\level, evt[\level]);
			},
		setExtra: { |evt| if(evt[\extra].notNil)
			{ evt[\synth].set( *evt[\extra].asArgsArray ) };
			}
		);
	
	if( ['d','playSlow','var4','whisper', 'solo'].includes(item[0]) ) 
		{ ~nasFuncs[ item[0] ][ \addLine ] = true; };
	 });
	 
// extra args
	 
~nasFuncs[ 'b' ][ \extraArgs ] = [ [ \slider, "volume" ], [ \transport, \volume, 60 ] ];

~nasFuncs[ 'd' ][ \extraArgs ] = [ [ \slider, "feedback" ], [ \slider, "disp" ] ];

~nasFuncs[ 'rec' ][ \extraArgs ] = [ [ \button, "clear" ] ];

~nasFuncs[ 'whisper' ][ \extraArgs ] = [ [ \slider, "filter" ] ];

~nasFuncs[ 'solo' ][ \extraArgs ] = [ [ \slider, "time" ], [ \transport, \time, 126 ] ];

// alternative playFuncs

~nasFuncs[ 'a' ][ \playFunc ] = { |evt ...args|
	var synths;
	evt[ \synth ].release;
	evt[ \synth ] = Group.basicNew( s ); // synth is actually a Group 

	synths = { Synth.basicNew( "nas-rtfx-a", s); } ! 4;
	s.sendBundle(nil, evt[ \synth ].newMsg( s, \addToTail ),
		*synths.collect({ |item, i| 
			item.newMsg( evt[ \synth ], 
				[ \in, i+4,
				  \pan, [-1,-0.875,0.875, 1][i],
				  \doneAction, 14 ] ++ args ) }) );
	};
	
~nasFuncs[ 'cl' ][ \playFunc ] = { |evt ...args|  // 2 synths if 4 inputs
	evt[\synth].do( _.release ); 
	evt[\synth] = { |i| Synth( "nas-rtfx-c." ++ (2-i), args, s, \addToTail ) }
			! ((~nasInputs[\mode] ? 2) /2);
	};
	

~nasFuncs[ 'cl' ][ \stopFunc ] = { |evt ...args|
	evt[\synth].do( _.release );
	evt[\synth] = nil;
	};
	
~nasFuncs[ 'cl' ][ \setLevel ] = { |evt, level| 
			evt[\level] = ~nasDBWarp.map(level).dbamp;
			evt[\synth].do( _.set(\level, evt[\level]) );
			};
	
~nasFuncs[ 'cr' ][ \playFunc ] = { |evt ...args|
	evt[\synth].do( _.release ); 
	evt[\synth] = { |i| Synth( "nas-rtfx-c." ++ (i+3), args, s, \addToTail ) }
			! ((~nasInputs[\mode] ? 2) /2);
	};
	
~nasFuncs[ 'cr' ][ \stopFunc ] = { |evt ...args|
	evt[\synth].do( _.release );
	evt[\synth] = nil;
	};
	
~nasFuncs[ 'cr' ][ \setLevel ] = { |evt, level| 
			evt[\level] = ~nasDBWarp.map(level).dbamp;
			evt[\synth].do( _.set(\level, evt[\level]) );
			};

	
~nasFuncs[ 'rec' ][ \clearButtonAction ] = { ~nasRecBuffers.do(_.zero); };

~nasFuncs[ 'whisper' ][ \player ] = ( time: 2.0, space: (0,1..~nasVoicesBuffers.size) );

~nasFuncs[ 'whisper' ][ \player ][ \space ] = (0,1..397);

~nasFuncs[ 'whisper' ][ \player ][ \task ] =
	Task { 
		loop { 
			Synth( "nas-whisper", [
				'bufnum', ~nasFuncs[ 'whisper' ][ \player ][ \space ].choose + 25, 
				'pan', 1.0.rand2, 
				'level', ~nasFuncs[ 'whisper' ][ \level ].rand * 0.5,
				'rate', 1.0 + 0.1.rand2,
				'filter',  ~nasFuncs[ 'whisper' ][ \extra ][ \filter ]  
				], addAction: \addToHead);
			~nasFuncs[ 'whisper' ][\player][ \time ].rand.wait;
			};
		};

~nasFuncs[ 'whisper' ][ \playFunc ] = { |evt ...args|
		~nasFuncs[ 'whisper' ][ \player ][ \task ].start;
		};

~nasFuncs[ 'whisper' ][ \stopFunc ] = { |evt ...args|
		~nasFuncs[ 'whisper' ][ \player ][ \task ].stop;
		};
		
~nasFuncs[ 'solo' ][\playFunc] = { |evt ...args| evt[\synth].release; 
			evt[\synth] = Synth( evt[\defName], args, s, \addToHead );
			};
		
~nasFuncs[ 'solo' ][ \timeEnvs ] = ( 
	whisperFilter: Env( [0, 0, 1, 1, 0, 0], [ 36, 12, 54, 12, 12 ].normalizeSum ),
	fbDSlider: Env( [0.0, 0.2, 0.8, 0.98, 0.7, 0.0, 0.0], [ 24, 24, 48, 18, 6, 6 ].normalizeSum ),
	diDSlider: Env( [0.0,0.2,1.0, 0.05,0.001,0.0001,0.0], 
		[ 14, 1.5, 42, 14, 14, 40.5 ].normalizeSum )
	);
	
~nasFuncs[ 'solo' ][ \setExtra ] = { |evt|
	var whOn, dOn, iOn;
	evt[\synth].set( *evt[\extra].asArgsArray );
	{
	if( evt[ 'button' ].value == 1 )
		{
		// auto whisper
		~nasFuncs[ 'whisper' ][ 'filterSlider' ].valueAction =
			evt[ \timeEnvs ][ \whisperFilter ].at( evt[\extra][\time] ); 
			
		whOn = evt[\extra][\time].inRange(0.5,0.99);
		if( ~nasFuncs[ 'whisper' ][ 'button' ].value != whOn.binaryValue )
			{ ~nasFuncs[ 'whisper' ][ 'button' ].valueAction = whOn.binaryValue };
		
		// auto rtfx-d	
		~nasFuncs[ 'd' ][ 'feedbackSlider' ].valueAction =
			evt[ \timeEnvs ][ \fbDSlider ].at( evt[\extra][\time] ); 
		~nasFuncs[ 'd' ][ 'dispSlider' ].valueAction =
			evt[ \timeEnvs ][ \diDSlider ].at( evt[\extra][\time] ); 	
		dOn = evt[\extra][\time].inRange(0.05,0.95);
		if( ~nasFuncs[ 'd' ][ 'button' ].value != dOn.binaryValue )
			{ ~nasFuncs[ 'd' ][ 'button' ].valueAction = dOn.binaryValue };
		
		// switch ins of temporarily
		if( ~nasInputs[ \active ].value != dOn.not.binaryValue )
			{  ~nasInputs[ \active ].valueAction = dOn.not.binaryValue } 
		
		}
	}.defer;

};
		
~nasFuncs[ 'str' ][\playFunc] = { |evt ...args| evt[\synth].release; 
			evt[\synth] = Synth( evt[\defName], args, s, \addToHead );
			};

);


// GUI 
~nasFuncsContainer = GUI.compositeView.new( ~nasWindow, 400@440  );
~nasFuncsContainer.relativeOrigin_( false );

~nasFuncsContainer.decorator = FlowLayout( ~nasFuncsContainer.bounds );



(
~nasDBWarp = \db.asSpec.maxval_(6);

~nasFuncLabels = [
	StaticText(  ~nasFuncsContainer, 80@16 ).string_( " Level" ).font_(  Font( "Monaco", 9 ) ),
	StaticText(  ~nasFuncsContainer, 140@16 ).string_( " Name" ).font_(  Font( "Monaco", 9 ) ),
	StaticText(  ~nasFuncsContainer, 80@16 ).string_( " Settings" ).font_(  Font( "Monaco", 9 ) )
];

~nasFuncsContainer.decorator.nextLine; 

~nasFuncs.values.sort({ |a,b| a.id <= b.id }).do({ |item,i|
	item[ \levelSlider ] = SmoothSlider( ~nasFuncsContainer, 80@16 )
		.value_(~nasDBWarp.unmap(item[\level]))
		.canFocus_( false )
		.mode_( \move )
		.action_({ |sl| item.setLevel(sl.value); });
	item[ \levelSlider ].doAction;
	item[ \button ] = RoundButton(  ~nasFuncsContainer, 140@16 ).font_( Font( "Monaco", 9 ) )
		.states_([[ item.label.asString ],[ item.label.asString, Color.gray(0.8), Color.black]])
		.canFocus_( false )
		.action_({ |bt| switch( bt.value, 
			1, { item.playFunc(\level, item[\level], *item[\extra].asArgsArray ) },
			0, { item.stopFunc() });
			});
			
	item[ \extraArgs ].do({ |extraArgsArray|
		var container;
		switch( extraArgsArray[0],
			\slider, { 
				container = GUI.vLayoutView.new( ~nasFuncsContainer, 80@16 );
				item[\extra] = item[\extra] ? ();
				item[\extra][extraArgsArray[1].asSymbol] = 0;
				item[ (extraArgsArray[1] ++ 
						extraArgsArray[0].firstToUpper).asSymbol ] =
					SmoothSlider( container, 80@7 ).hiliteColor_( Color.gray(0.3) )
						.canFocus_( false )
						.mode_( \move )
						.action_({ |sl|
							item[\extra] = item[\extra] ? ();
							item[\extra][extraArgsArray[1].asSymbol] = sl.value;
							item.setExtra;
							})
						.value_(0);
				GUI.staticText.new( container, 80@9 ).font_( Font( "Monaco", 9 ) )
					.string_( extraArgsArray[1].asString )
					.align_( \center );
					},
			\button, { 
			item[ (extraArgsArray[1] ++ extraArgsArray[0].firstToUpper).asSymbol ] =
				RoundButton(  ~nasFuncsContainer, 60@16 )
					.font_( Font( "Monaco", 9 ) )
					.canFocus_( false )
					.states_([[ extraArgsArray[1] ]])
					.action_({ |bt|
		item[ (extraArgsArray[1] ++ extraArgsArray[0].firstToUpper ++ "Action").asSymbol ]
			.value( bt );
						}) ; },
						
			\transport, { 
				
				item[ \transportTask ] = Task({
					var slider;
					slider = item[ (extraArgsArray[1] ++ "Slider").asSymbol ];
					while { item[ \extra ][ extraArgsArray[1] ] <= 1.0  }
					      { item[ \extra ][ extraArgsArray[1] ]
					      	= item[ \extra ][ extraArgsArray[1] ] +
					      		 (0.1/extraArgsArray[2]);
					        item.setExtra;
					        { if( ~nasWindow.isClosed.not )
					        		{ slider.value = item[ \extra ][ extraArgsArray[1] ] } 
					        	}.defer;
					        0.1.wait;
					      };
					         
					{ if( ~nasWindow.isClosed.not )
						{ item[ (extraArgsArray[1] ++ "PlayButton" ).asSymbol ].value = 0 };
					}.defer;
				});
				
				container = ();
				container[ 'h' ] = GUI.hLayoutView.new( ~nasFuncsContainer, 80@16 );
				
				item[ (extraArgsArray[1] ++ "PlayButton" ).asSymbol ] = 
					RoundButton( container[ 'h' ], 24@16 )
						.states_([[ 'play' ], [ 'play', Color.gray(0.8), Color.black ]])
							.font_( Font( "Monaco", 9 ) )
							.canFocus_( false )
							.action_({ |bt|
								if( bt.value == 1 )
								 { item[ \transportTask ].start };
								 bt.value = 1; 
								});
								
				item[ (extraArgsArray[1] ++ "StopButton" ).asSymbol ] = 
					RoundButton( container[ 'h' ], 24@16 )
						.states_([[ 'stop' ]])
							.font_( Font( "Monaco", 9 ) )
							.canFocus_( false )
							.action_({ item[ \transportTask ].stop;
								item[ (extraArgsArray[1] ++ "PlayButton" ).asSymbol ].value = 0
								});
								
				item[ (extraArgsArray[1] ++ "ReturnButton" ).asSymbol ] = 
					RoundButton( container[ 'h' ], 24@16 )
						.states_([[ 'return' ]])
							.font_( Font( "Monaco", 9 ) )
							.canFocus_( false )
							.action_({ item[ \extra ][ extraArgsArray[1] ] = 0;
						item[ (extraArgsArray[1] ++ "Slider").asSymbol ].valueAction = 
					        		    item[ \extra ][ extraArgsArray[1] ];  
					        	});
								
				/*

				[ 'play', 'stop', 'return' ].do({ |state, i|
					item[ (extraArgsArray[1] ++ state.firstToUpper 
							++ "Button" ).asSymbol ] = 
						RoundButton( container[ 'h' ], 24@16 ).states_([[ state ]])
							.font_( Font( "Monaco", 9 ) )
							.canFocus_( false )
							.action_( [ 
								{ item[ \transportTask ].start },
								{ item[ \transportTask ].stop },
								{ item[ \extra ][ extraArgsArray[1] ] = 0;
								  item[ (extraArgsArray[1] ++ "Slider").asSymbol ].value = 
					        		    item[ \extra ][ extraArgsArray[1] ]  }
							][i]);
					});
				*/
					
				 }
			);
	});
	if( item[ \addLine ] == true )
		{
		~nasFuncsContainer.decorator.nextLine; 
		GUI.staticText.new( ~nasFuncsContainer, 228@16);
		 };
		
	~nasFuncsContainer.decorator.nextLine;
	
	});
	
	~nasFuncsContainer.decorator.nextLine;
	
	~nasLevelButtons = [
		RoundButton( ~nasFuncsContainer, 38@16 )
			.states_( [ [ "read", Color.black, Color.green(0.75,0.5) ] ] )
			.action_( { ~nasLevels.read } ),
		RoundButton( ~nasFuncsContainer, 38@16 )
			.states_( [ [ "save", Color.black, Color.red(0.75,0.5) ] ] )
			.action_( { ~nasLevels.write } ),
		RoundButton( ~nasFuncsContainer, 38@16 )
			.states_( [ [ "reset", Color.black, Color.web.orange.alpha_(0.5) ] ] )
			.action_( { ~nasLevels.initialize } ),
	];
	
	~nasLevelButtons.do({ |bt|
		bt.radius_( 4 )
		.border_( 0 )
		.font_( Font( "Monaco", 9 ) )
		.canFocus_( false );
	});
	
	StaticText( ~nasFuncsContainer, 80@16 )
		.string_( "levels" )
		.font_( Font( "Monaco", 9 ) );
	
	~nasLevels.read;
);

~nasWindow.bounds

)