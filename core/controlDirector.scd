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
				subscriptions: subscriptions;
			);

			userInterfaces = userInterfaces.add(uiModel);

		},
		addTrack: {
			arg self, track;
			tracks = tracks.add(track);
		},
		getBuffer: {
			arg self;
			tracks[0].buffer;
		},
		getPlaybackIndex: {
			arg self;
			tracks[0].playbackIndex;
		},
		getParameter: {
			arg self, address;
			var parameter;

			parameter = address;
			tracks[0].getParameter(parameter);
		},
		setParameter: {
			arg self, address, value;
			var track, parameter, updatedValue;

			parameter = address;
			track = tracks[0];

			updatedValue = track.setParameter(parameter, value);
			self.updateAllUIs(parameter, updatedValue);
		},
		accumParameter: {
			arg self, parameter, accum;
			var track, updatedValue;

			track = tracks[0];
			updatedValue = track.accumParameter(parameter, accum);
			self.updateAllUIs(parameter, updatedValue);
		},
		updateAllUIs: {
			arg self, parameter, value;
			userInterfaces.do({
				arg item;
				if (item.subscriptions.includesKey(parameter),
					{
						item.ui.receiveParameter(parameter, value);
				});
			});
		}
	)
}