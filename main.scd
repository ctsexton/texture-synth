(
MIDIClient.init;
b = Buffer.read(s, '/home/cts/Pd/soundfilez/funkay1.wav');
c = Buffer.read(s, '/home/cts/Pd/soundfilez/stopandfrisk.wav');
"core/synthdefs.scd".loadRelative[0].add;
)

(
var trackFactory, trackA, trackB, addressFactory, trackAddress, guiFactory, gui, director, mftFactory, mft;

director = "core/controlDirector.scd".loadRelative[0].value();
guiFactory = "gui/top.scd".loadRelative[0];
trackFactory = "core/track.scd".loadRelative[0];
mftFactory = "midi/mftFactory.scd".loadRelative[0];

trackA = trackFactory.create(b);
trackB = trackFactory.create(c);
director.addTrack(trackA);
director.addTrack(trackB);

guiFactory.create(director);
// mft = mftFactory.create(director);
// "Done";
)
