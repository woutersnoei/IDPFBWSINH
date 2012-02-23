// level storage and setting tools

~nasLevels = ();

~nasLevels.path = "~/Library/Application Support/IDPFBWSINH/levels.txt".spath;

~nasLevels.initialize = { |evt, db = 0|
	~nasFuncs.keysValuesDo({ |key, value|
		~nasFuncs[ key ].levelSlider.valueAction = ~nasDBWarp.unmap( db.value( key, value ) );
	});
};

~nasLevels.read = { |evt, ifnot|
	ifnot = ifnot ? { evt.initialize };
	if( File.exists( evt.path ) ) { 
		File.use(  evt.path, "r", { |file| 
			var levels = file.readAllString.interpret;
			if( levels.respondsTo( \keysValuesDo ) ) {
				levels.keysValuesDo({ |key, value|
					~nasFuncs[ key ].levelSlider.valueAction = ~nasDBWarp.unmap(value);
				});
			} { 
				ifnot.value 
			};
		}); 
	} { 
		ifnot.value;
	};
};

~nasLevels.write = { |evt|
	File.use( evt.path, "w", { |f| 
		f.write( ~nasFuncs.collect({ |item| item.level.ampdb; }).asString
			.replace( "\n", "" ) // clear newlines
			.replace( "   ", " ") // cleanup spaces
			.replace( ", ", ",\n  " ) // add newline per item
		); 
	});
};

/* // example
~nasLevels.initialize( { |key| if( key == 'whisper' ) { -12 } { 0 } } );

~nasLevels.write;
~nasLevels.read;
*/