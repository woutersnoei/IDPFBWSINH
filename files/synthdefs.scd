(
// NAS GUI SynthDefs

//// TEMP MODIFIED FOR RECORDING !! (outbuses)

s.waitForBoot({

///// INPUT ROUTER
(
SynthDef("nas-inputs-4", { // 4 inputs
	arg in=3, bus=4, hiShelf=2, lowCut=200, tresh = -75, level=1.0, gate=1;
	var input, inputEQ, amplitude, output;
	input = AudioIn.ar(in + [0,1,2,3]) * Env.cutoff(0.05).kr(2,gate);
	inputEQ = BHiShelf.ar( HPF.ar(input, lowCut), db: hiShelf);
	output = Compander.ar(inputEQ, inputEQ, tresh.dbamp, 10, 1, 0.01, 0.01) * level;
	Out.ar(bus, output );
	}).load(s);
	
SynthDef("nas-inputs-2", { // 2 inputs
	arg in=3, bus=4, hiShelf=2, lowCut=200, tresh = -75, level=1.0, gate=1, t_resetPeak = 0;
	var input, inputEQ, amplitude, output, amp,peak;
	input = AudioIn.ar(in + [0,1]) * Env.cutoff(0.05).kr(2,gate);	inputEQ = BHiShelf.ar( HPF.ar(input, lowCut), db: hiShelf);
	output = Compander.ar(inputEQ, inputEQ, tresh.dbamp, 10, 1, 0.01, 0.01) * level;
	amp = Amplitude.kr( inputEQ );
	peak = Peak.kr( amp, t_resetPeak );
	SendTrig.kr( amp > tresh.dbamp, 10 + [0,1], 1 );
	SendTrig.kr( amp < tresh.dbamp, 10 + [0,1], 0 );
	SendTrig.kr( Slope.kr( peak ).abs - 0.0001, 20 + [0,1], peak.ampdb ); 
	Out.ar(bus, output.stutter(2) );
	}).load(s);
);

///// RTFX A,B,C,D
(
SynthDef("nas-rtfx-a", { // long tones :: 1 channel
	arg in=4, i_minFr=600.0, i_varFr=300.0, treshLevel= -35, gate=1, pan=0, 
		pWidth=0.125, level = 1.0, attackTime = 0.001, releaseTime = 1.8,
		out = 0, doneAction=2; // doneAction=14 for groups
	var input;
	var dupAmt=10;
	var noiseFunc;
	noiseFunc = {
	(LFCub.ar( Rand(i_minFr.dup(dupAmt), (i_varFr + i_minFr).dup(dupAmt)) ).sum / 10) 
		* (LFCub.ar( Rand(i_minFr.dup(dupAmt), (i_varFr + i_minFr).dup(dupAmt)) ) / 10).sum; };
	input = In.ar(in).excess(treshLevel.dbamp);
	Out.ar(out, Env([0,1,1,0],[0.5, 0, 1.0],'lin', 1).kr(doneAction, gate) * Pan2.ar(
		Slew.ar(Amplitude.ar(input , attackTime, releaseTime), 0.01,40) * 
			[noiseFunc.value, noiseFunc.value] * level * 2.0, 
		[pan - pWidth, pan + pWidth]).sum);
	}).load(s);
);
(
SynthDef("nas-rtfx-b", { // water-effect :: 4 channels
	arg in=4, shift1 = 1.0, level=1.0, volume = 0,
		pWidth = 0.125, fblevel = 2.5, out = 0, gate = 1;
	var output, fbin, input, linen;
	fbin = LocalIn.ar(8) * fblevel; // 8 channel buffers
	input = In.ar(in, 4) * volume * 1.5;
	output = Resonz.ar(fbin.rotate(1) + input, 
		LFNoise0.kr( {1.4 + 0.3.rand2}!8 ).range(200, 2000), 0.1 );
	output = PitchShift.ar(output, Rand(0.2.dup(8),0.4.dup(8)), 1, 0.5, 1.0);
	LocalOut.ar(output);
	linen = Linen.kr( gate, 0.5, 1, 1, 2 )**2;
	Out.ar(out, Pan2.ar( output * level, ((0,2..14) / 7) -1).sum * linen);
	}).load(s);
);
(
SynthDef("nas-rtfx-c", { |in = 4, pan = 0, level = 1,
		tresh = -70, higher = 0, out = 0,gate=1| 
	// percussive :: 1 channel
	var amp, trig, inKlank, outKlank, outSelect, linen;
	amp = Amplitude.ar( 
		BHiPass.ar(In.ar(in, 1), 1400 ), 0.01, 0.01).excess(tresh.dbamp);
	trig = Trig1.ar( amp - 0.001, 0.09 );
	
	inKlank = Decay.ar( PulseDivider.ar(trig, 9, (0,1..8)), 0.1) 
		* amp.min(-12.dbamp) 
		* ( GrayNoise.ar(20.0) + WhiteNoise.ar(10));
		 
	outKlank = Klank.ar(Array.fill(9, { |i|
		`[	ExpRand((40 * (i+1)).dup(4), 3000.dup(4)),
			Rand(0.005.dup(4), 0.02.dup(4)),
			Rand(0.03.dup(4), 0.3.dup(4))] })
		, inKlank) ring1: 
	SinOsc.ar( 
		(Array.rand(9, 220.0, 1200.0) * LFNoise1.kr([0.2, 0.3]).range(0.25, 3)) 
			* (1 + ( higher * 3 )) );
	linen = Linen.kr( gate, 0.01, 1, 0.1, 2 )**2;
	
	Out.ar(out, Pan2.ar(  outKlank.sum * level , pan) * linen );
	}, variants: 
		(	1: [ \in, 4, \pan, -1], 
			2: [ \in, 5, \pan, -0.66], 
			3: [ \in, 6, \pan,  0.66], 
			4: [ \in, 7, \pan,  1])).load(s);
);
(
SynthDef("nas-rtfx-c-auto", { |pan = 0, level =1, dens=10, time = 0, out = 0, gate=1|
	var amp, trig, inKlank, outKlank, output;
	var lIn, linen, fxLevel;
	lIn = (time + 0.2).min(1);
	fxLevel = ((time - 0.1) * 8).clip(0,0.8);
	inKlank = Decay.ar(Dust.ar(lIn.dup(16) * 10), 0.05 + lIn.excess(0.75)) 
		* ( BLowPass.ar(GrayNoise.ar(0.25) + WhiteNoise.ar(0.5),
			8000 * (1.025 - lIn) ));
		 
	outKlank = Klank.ar(Array.fill(12, { |i|
		`[	ExpRand((40 * (i+1)).dup(4), 3000.dup(4)),
			Rand(0.005.dup(4), 0.02.dup(4)),
			Rand(0.05.dup(4), 0.5.dup(4))] })
		, inKlank) ring1: 
	SinOsc.ar( Array.rand(9, 220.0, 1200.0) * LFNoise1.kr([0.2, 0.3]).range(0.25, 3) 
		* (1 - (lIn.excess(0.25) * 1.95)));
	//outSelect = Select.ar(TRand.ar(0,8, trig), outKlank);
	output = BHiPass.ar(
		Splay.ar( outKlank * level * (lIn.fold2(0.5)**2).min( 0.2 ) ) 
		, ( 4000 * ((1.0125 - (lIn * 1.25).min(1.0))**2) ) + 20 );
	linen = Linen.kr( gate, 2, 1, 3, 2 )**2;
	//output = FreeVerb.ar( output );
	Out.ar(out, output * linen * 10);
	Out.ar(4, output * lIn * linen * 10 * fxLevel);
	
	}).load(s);
);
(	
SynthDef("nas-rtfx-d", { // fb-pitchshift
	arg in=4, shift1 = 1.0, disp = 0, inLevel = 1, level=1, 
		pWidth = 0.125, feedback = 0.0, out = 0, gate=1;
	var output, fbin, input;
	var lIn, linen;
	lIn = inLevel;
	level = level * lIn;
	fbin = LeakDC.ar(LocalIn.ar(8) * feedback * 1.78 * (lIn**3)) ;
	input = In.ar(in, 4);
	
	output = input ring2: fbin.rotate(1);
	output = PitchShift.ar(output, Rand(0.4.dup(8),0.8.dup(8)), shift1, 
				disp, 1.0);
	LocalOut.ar(output);
	linen = Linen.kr( gate, 0.5, 1, 3, 2 )**2;
	Out.ar(out, Pan2.ar( output * level, ((0,2..14) / 7) -1).sum * linen);
	}).load(s);
);		

////// BUFFER REC/PLAY/VAR 1-4

(
SynthDef("nas-buf-rec", { | in1=4, in2=5, in3=6, in4=7, recLevel=1.0, preLevel=1, gate=1 |
	var env;
	var out;
	var in;
	in = [in1,in2,in3,in4].collect({ |item| In.ar(item) });
	env = Env([0,1,1,0], [1,1,0.1], \lin, 1).kr(2, gate); 
	4.do({ |i|
		RecordBuf.ar( in[i], 20+i, 0, recLevel * env, preLevel )
		});
	}).load(s);
);
(
SynthDef("nas-buf-slow", { |level=1, lpFreq=1200, speed = 0.5, out = 0, gate=1|
	var outPB, outPB2, linen;
	outPB = Array.fill(4, { |i|
		PlayBuf.ar(1, 20+i, [ 1.14, 1.04, 0.96, 1.22 ][i] * speed, 1, 
			Rand(0,BufFrames.ir(20+i)), 1) }); 
	outPB2= BLowPass.ar(
		Pan2.ar(outPB * level, [-1, -0.33, 0.33, 1]).sum
		, lpFreq );
	
	linen = Linen.kr( gate, 0.5, 1, 1, 2 )**2;
	Out.ar(out, outPB2 * linen * 0.25);
	}).load(s);
);
(
SynthDef("nas-buf-straight", { | level=1, speed = 1.0, out = 0, gate=1|
	var outPB, outPB2, outPB4;
	var lIn, linen;
	//lIn = In.kr(levelBus);
	//level = (lIn.excess(0.1)**2).min(0.25) * level * 1.5;
	lIn = level * 1.5;
	level = lIn;
	outPB = Array.fill(4, { |i|
		PlayBuf.ar(1, 20+i, [ 1.14, 1.04, 0.96, 1.22 ][i] * speed * (lIn.max(0.5) * 2), 
			1, Rand(0,BufFrames.ir(20+i)), 1) +
		( PlayBuf.ar(1, 20+i, [ -1.04, -1.17, -1.13, -0.91 ][i] * speed, 
			1, Rand(0,BufFrames.ir(20+i)), 1) * lIn.excess(0.5) )}); 
	outPB2= Pan2.ar(outPB * level, [-1, -0.33, 0.33, 1]).sum;
	outPB4 = outPB2 * 0.125 * SinOsc.ar( [440,440] * LFNoise1.kr([0.1, 0.1]).range(0.5, 4) );
	linen = Linen.kr( gate, 0.5, 1, 1, 2 )**2;
	Out.ar(out, (outPB4 + outPB2) * linen * 0.125);
	}).load(s);
);
(
SynthDef("nas-buf-v1", { // variation 1 (water)
	arg level=1, lpFreq=1200, speed = 0.5, 
	shift1 = 1.0, pWidth = 0.125, fblevel = 2.5, out = 0, gate=1;
	var output, fbin, input;
	var outPB, outPB2;
	var linen;
	outPB = Array.fill(4, { |i|
		PlayBuf.ar(1, 20+i, [ 1.14, 1.04, 0.96, 1.22 ][i] * speed, 1, 
			Rand(0,BufFrames.ir(20+i)), 1) }); 
	outPB2= BLowPass.ar(
		Pan2.ar(outPB * level, [-1, -0.33, 0.33, 1]).sum
		, lpFreq );
	fbin = LocalIn.ar(4) * fblevel;
	output = Resonz.ar(fbin.rotate(1) + outPB2, 
		LFNoise0.kr( {1.4 + 0.3.rand2}!4 ).range(200, 2000), 0.1 );
	output = PitchShift.ar(output, Rand(0.2.dup(4),0.4.dup(4)), 1, 0.5, 1.0);
	linen = Linen.kr( gate, 0.5, 1, 1, 2 )**2;
	LocalOut.ar(output);
	Out.ar(out, Pan2.ar( output * level, ((0,1..3) / 1.5) - 1).sum * linen * 0.25);
	}).load(s);
);
(
SynthDef("nas-buf-v2", { // variation 2 (dark)
	arg level=1, lpFreq=300, speed = 0.4, out = 0, gate=1;
	var noise;
	var outPB, outPB2;
	var linen;
	//level = (In.kr(levelBus).excess(0.1)**3) * level;
	level = level * 0.5;
	outPB = Array.fill(4, { |i|
		PlayBuf.ar(1, 20+i, [ 1.14, 1.04, 0.96, 1.22 ][i] * speed, 1, 
			Rand(0,BufFrames.ir(20+i)), 1) +
		PlayBuf.ar(1, 20+i, [ -0.51, 0.48, 0.53, 0.45 ][i] * speed, 1, 
			Rand(0,BufFrames.ir(20+i)), 1)}); 
	outPB2= BLowPass.ar(
		Pan2.ar(outPB, [-1, -0.33, 0.33, 1]).sum
		, 1200 ).distort * level;
	noise = BLowPass.ar( 
		GrayNoise.ar( level * 0.1.dup ).distort, lpFreq);
	linen = Linen.kr( gate, 0.5, 1, 1, 2 )**2;
	Out.ar(out, (noise + outPB2) * linen * 0.25);
	}).load(s);	
);
(
SynthDef("nas-buf-v3", { |level=1, lpFreq=1400, speed = 0.6, gate=1, out=0|
	// variation 3 (high)
	var outPB, outPB2, outPB4;
	var noise;
	var linen;
	//level = (In.kr(levelBus).excess(0.1)**2) * level;
	level = level * 0.5;
	outPB = Array.fill(4, { |i|
		PlayBuf.ar(1, 20+i, [ 1.14, 1.04, 0.96, 1.22 ][i] * speed, 1, 
			Rand(0,BufFrames.ir(20+i)), 1) }); 
	outPB2= BHiPass.ar(
		Pan2.ar(outPB *  level, [-1, -0.33, 0.33, 1]).sum
		, lpFreq );
	noise = BHiPass.ar( 
		GrayNoise.ar( level * 0.0075.dup ).distort, lpFreq);
		
	outPB4 = outPB2 *
		SinOsc.ar( [440,440] * LFNoise1.kr([0.1, 0.1]).range(0.5, 4) );
	linen = Linen.kr( gate, 0.5, 1, 1, 2 )**2;
	Out.ar(out, (outPB4 + outPB2 + noise) * linen * 0.25);
	}).load(s);
);
(
SynthDef("nas-buf-v4", { |level=1, lpFreq=1200, speed = 0.7, out=0,gate=1|
	// variation 4 (glass)
	var outPB, outPB2, outPB3, outPB4;
	var noise, linen, output;
	//level = (In.kr(levelBus).excess(0.1)**3) * level;
	outPB = Array.fill(4, { |i|
		PlayBuf.ar(1, 20+i, [ 1.14, 1.04, 0.96, 1.22 ][i] * speed, 1, 
			Rand(0,BufFrames.ir(20+i)), 1)
		+
		PlayBuf.ar(1, 20+i, [ -1.3, -0.95, -1.1, -1.01 ][i] * speed, 1, 
			Rand(0,BufFrames.ir(20+i)), 1) }); 
	outPB2= BHiPass.ar(
		Pan2.ar(outPB * level , [-1, -0.33, 0.33, 1]).sum
		, lpFreq );
	noise = BHiPass.ar( 
		GrayNoise.ar( level.dup * 0.001 ).distort, lpFreq);
	outPB3 = Klank.ar(`[[1325,1531,1632], 0.01, [0.4,0.6,0.8]],
		outPB2 + noise);
	outPB4 = outPB3 * 0.1 *
		SinOsc.ar( [440,440] * LFNoise1.kr([0.1, 0.1]).range(0.25, 3) );
	linen = Linen.kr( gate, 0.5, 1, 1, 2 )**2;
	output = outPB3 + outPB4 + (noise.rotate(1) * 0.1);
	Out.ar(out, output * linen * 0.125 );
	Out.ar(4, output * linen * 0.25 );
	}).load(s);
);

////// STRIPE
(
SynthDef("nas-stripe", { arg bufnum = 0, pan=0, level=1, fxLevel=0,
		rate=1, gate=1, bw=0, out=0;  
	var output, env, linen;
	output = 4.collect({ |i| PlayBuf.ar(1, bufnum + i, BufRateScale.kr( bufnum )); });
	env = Env([0,2,0.05,0],[0.1,8.5,1], [\lin, \exp, \lin]).kr(2);
	linen = Linen.kr( gate, 0, 1, 0.1, 2 )**2;
	Out.ar( out, Splay.ar(output) * env * level * 3 );
	Out.ar( 4, output * env * level);
	 }).load(s);
);

////// WHISPER
(
SynthDef("nas-whisper", { arg bufnum = 25, pan=0, level=1,
				rate=1, gate=0, filter=0, out=0;  //gate = loop
	var output, fxLevel;
	level = level * (-12.dbamp);
	fxLevel = filter * 0.25;
	output = PlayBufFree.ar(1, bufnum, rate * BufRateScale.kr( bufnum ), 
			loop: gate) * 0.75; // level correction
	output = BBandPass.ar(
		HPF.ar( (output * ((filter**2).linlin(0,1,0,30).dbamp) )
			// (1 + ((filter**2)*16))
		 ring1: GrayNoise.ar(filter * 0.6), 400 ), 
		[Rand(150,2000), Rand(150,2000)], 10**(1 - (filter*3))
		).sum;
	Out.ar(out, Pan2.ar(output * level, pan) * 2 ); 
	Out.ar(Rand(4,7), output * fxLevel * level * 2);
	}).load(s);
);

"IDPFBWSINH synthdefs loaded".postln;

});

);