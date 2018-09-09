(
var samplePath = thisProcess.nowExecutingPath.dirname;
MIDIClient.init;
a = Buffer.read(s, samplePath +/+ 'samples/08_Chains.wav');
b = Buffer.read(s, samplePath +/+ 'samples/13_Contact Mic 1.wav');
c = Buffer.read(s, samplePath +/+ 'samples/09_Floor Tom.wav');
d = Buffer.read(s, samplePath +/+ 'samples/01_Piano.wav');
"core/synthdefs.scd".loadRelative[0].add;
)

(
var trackFactory, trackA, trackB, trackC, trackD, addressFactory, trackAddress, guiFactory, gui, director, mftFactory, mft;

director = "core/controlDirector.scd".loadRelative[0].value();
guiFactory = "gui/top.scd".loadRelative[0];
trackFactory = "core/track.scd".loadRelative[0];
mftFactory = "midi/mft.scd".loadRelative[0];

trackA = trackFactory.create(a);
trackB = trackFactory.create(b);
trackC = trackFactory.create(c);
trackD = trackFactory.create(d);
director.addTrack(trackA);
director.addTrack(trackB);
director.addTrack(trackC);
director.addTrack(trackD);

guiFactory.create(director);
mft = mftFactory.create(director);
// "Done";
)
