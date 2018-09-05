(
create: {
	arg self, buffer, playbackBus;
	(
		position: 0,
		window: 1,
		rate: 1,
		lowCutoff: 10000,
		hiCutoff: 10,
		volume: 1,
		buffer: buffer,
		playbackIndex: playbackBus
	)
}
)
