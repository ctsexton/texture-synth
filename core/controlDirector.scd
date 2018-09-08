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
		setParameter: {
			arg self, address, value;
			var track, parameter;

			parameter = address;
			track = tracks[0];

			track.setParameter(parameter, value);
			userInterfaces.do({
				arg item;
				if (item.subscriptions.includesKey(parameter),
					{
						item.ui.receiveParameter(parameter, value);
				});
			})


		},
		getParameter: {
			arg self, address;
			var parameter;

			parameter = address;
			tracks[0][parameter];
		},
		accumParameter: {
			arg self, parameter, accum;
			var direction, oldVal;
			oldVal = tracks[0][parameter];
			direction = (accum * 2 - 1) * 0.01;
			self.setParameter(parameter, oldVal + direction);

			/*if (oldVal <= 0 && accum == 1,
				{
					direction = (accum * 2 - 1) * 0.01;
					tracks[0].setParameter(parameter, oldVal + direction);
				}
			);
			if (oldVal >= 1 && accum == 0,
				{
					direction = (accum * 2 - 1) * 0.01;
					tracks[0].setParameter(parameter, oldVal + direction);
				}
			)*/
		}
	)
}