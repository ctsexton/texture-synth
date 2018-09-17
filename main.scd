(
var main;
main = {
	var samplePath, samples, trackFactory, tracks, addressFactory, trackAddress, guiFactory, gui, director, mftFactory, mft;

  samplePath = {
    try(
      {"TRY".postln; thisProcess.nowExecutingPath.dirname;},
      {"CATCH".postln; File.getcwd;}
    );
  }.value();
	director = "core/controlDirector.scd".loadRelative[0].value();
	guiFactory = "gui/top.scd".loadRelative[0];
	trackFactory = "core/track.scd".loadRelative[0];
	mftFactory = "midi/mft.scd".loadRelative[0];
	"core/synthdefs.scd".loadRelative[0].add;

  QtGUI.palette = QPalette.dark;

	MIDIClient.init;

	samples = ['08_Chains.wav', '13_Contact Mic 1.wav', '09_Floor Tom.wav', '01_Piano.wav'];

	t = samples.collect({
		arg name;
		var buffer, track;
		buffer = Buffer.read(s, samplePath +/+ 'samples/' +/+ name);
		track = trackFactory.create(buffer);
		director.addTrack(track);
		track;
	});

	guiFactory.create(director);
	mft = mftFactory.create(director);
	// "Done";
};

s.waitForBoot(main);
)
