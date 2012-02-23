(
// NAS GUI Buffers

s.waitForBoot({

~nasPath = ~nasPath ?? { Document.current.path.dirname };

~nasVoicesBuffers = Buffer.readDir( ~nasPath.dirname +/+ "samples/vox-steim/", 25, "aif");

Buffer.readDir(~nasPath.dirname +/+ "samples/streep/", 0, "aif");

~nasRecBuffers = { |i| Buffer.alloc(s, ((8.0 rrand: 12.0) * s.sampleRate).floor,
	 1, bufnum:i+20); } ! 4;
	 
~nasRecBuffers.do(_.zero);

});

);
