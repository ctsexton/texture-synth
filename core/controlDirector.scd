{
	var userInterfaces, tracks, subscriptionFactory, storage, tracks_enabled;
	userInterfaces = [];
	tracks = [];
  storage = nil;
  tracks_enabled = [];

	(
    registerStorage: {
      arg self, newStorage;
      storage = newStorage;
    },
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
      tracks_enabled = tracks_enabled.add(true);
		},
    numTracks: {
      arg self;
      tracks.size;
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
		accumParameter: {
			arg self, address, accum;
			var track, updatedValue, parameter;

			track = tracks[address['track']];
			parameter = address['name'];
			updatedValue = track.accumParameter(parameter, accum);
			self.updateAllUIs(address, updatedValue);
		},
		togglePlayback: {
			arg self, address, value;
      var trackIndex;
      trackIndex = address['track'];
			if (value == 1,
				{ tracks[trackIndex].start()},
				{ tracks[trackIndex].stopSynth() }
			);
      self.updateAllUIs(address, value);
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
		},
    getAllSettings: {
      arg self;
      tracks.collect({
        arg track;
        track.makeMemento();
      });
    },
    restoreSettings: {
      arg self, settings;
      settings.do({
        arg item, trackIndex;
        item.keysValuesDo({
          arg key, value;
          var address;
          if (tracks_enabled[trackIndex] == true, {
            address = (track: trackIndex, name: key);
            self.setParameter(address, value);
          })
        })
      })
    },
    toggleTrack: {
      arg self, track;
      tracks_enabled[track] = tracks_enabled[track].not;
      tracks_enabled[track];
    }
	)
}
