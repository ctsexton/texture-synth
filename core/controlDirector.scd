{
	var userInterfaces, tracks, subscriptionFactory;
	userInterfaces = [];
	tracks = [];

	(
		registerUI: {
			arg self, userInterface, subscriptionsToAdd;
			var uiModel, subscriptions;

			subscriptions = ();
			subscriptionsToAdd.do({
				arg item;
				subscriptions.put(item, 1);
			});

			uiModel = (
				ui: userInterface,
				subscriptions: subscriptions
			);

			userInterfaces = userInterfaces.add(uiModel);

		},
		addTrack: {
			arg self, track;
			tracks = tracks.add(track);
		},
		getBuffer: {
			arg self, trackIndex;
			tracks[trackIndex].buffer;
		},
    getSoundFile: {
			arg self, trackIndex;
			tracks[trackIndex].soundFile;
    },
		getPlaybackIndex: {
			arg self, trackIndex;
			tracks[trackIndex].playbackIndex;
		},
		getParameter: {
			arg self, address;
			var parameter;

			parameter = address['name'];
			tracks[address['track']].getParameter(parameter);
		},
		setParameter: {
			arg self, address, value;
			var track, parameter, updatedValue;

			parameter = address['name'];
			track = tracks[address['track']];

			updatedValue = track.setParameter(parameter, value);
			self.updateAllUIs(address, updatedValue);
		},
    switchSoundFile: {
			arg self, address, newSoundFile;
			tracks[address['track']].switchSample(newSoundFile);
			self.updateAllUIs(address, newSoundFile);
    },
		accumParameter: {
			arg self, address, accum;
			var track, updatedValue, parameter;

			track = tracks[address['track']];
			parameter = address['name'];
			updatedValue = track.accumParameter(parameter, accum);
			self.updateAllUIs(address, updatedValue);
		},
		togglePlayback: {
			arg self, trackIndex, value;
			if (value == 1,
				{ tracks[trackIndex].start() },
				{ tracks[trackIndex].stopSynth() }
			);
		},
		updateAllUIs: {
			arg self, address, value;
			var parameter;
			parameter = address['name'];
			userInterfaces.do({
				arg item;
				if (item.subscriptions.includesKey(parameter),
					{
						item.ui.receiveParameter(address, value);
				});
			});
		}
	)
}
