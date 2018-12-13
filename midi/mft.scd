var translatorMaker, midi_to_grid, grid_to_midi, rangeFactory, levelOneParams, levelTwoParams, clickParams, addressesA, addressesB, addressesC, addressFactory, timerFactory, params_to_controller, masterChannelLevelOne, masterChannelLevelTwo, masterParams_to_controller;
translatorMaker = "translator.scd".loadRelative[0];
rangeFactory = "encToRange.scd".loadRelative[0];
addressFactory = "../core/address.scd".loadRelative[0];
timerFactory = "timergate.scd".loadRelative[0];

midi_to_grid = translatorMaker.newMIDItoGRID(4, False);
grid_to_midi = translatorMaker.newGRIDtoMIDI(4);
levelOneParams = [\position, \rate, \lpfCutoff, \volume];
levelTwoParams = [\window, \rate, \hpfCutoff, \volume];
clickParams = [\posWin, \rate, \cutoff, \volume];
addressesA = [[],[],[],[]];
addressesB = [[],[],[],[]];
addressesC = [[],[],[],[]];

for (0, 3, { |trk|
	for (0, 3, { |prm|
		var newAddressA, newAddressB, newAddressC;

		newAddressA = addressFactory.create(trk, levelOneParams[prm]);
		newAddressB = addressFactory.create(trk, levelTwoParams[prm]);
    newAddressC = addressFactory.create(trk, clickParams[prm]);

		addressesA[trk] = addressesA[trk].add(newAddressA);
		addressesB[trk] = addressesB[trk].add(newAddressB);
		addressesC[trk] = addressesC[trk].add(newAddressC);
	})
});

params_to_controller = (
  \position: (level: [0], col: 0, scale: \default),
  \window: (level: [1], col: 0, scale: \default),
  \rate: (level: [0, 1], col: 1, scale: [-2, 2, 0, 127]),
  \lpfCutoff: (level: [0], col: 2, scale: \default),
  \hpfCutoff: (level: [1], col: 2, scale: \default),
  \volume: (level: [0, 1], col: 3, scale: \default)
);

masterChannelLevelOne = [\m_reverbIn, \m_lpf, \m_volume];
masterChannelLevelTwo = [\m_reverbIn, \m_hpf, \m_distortion];
masterParams_to_controller = (
  \m_reverbIn: (level: [0, 1], col: 1, scale: \default),
  \m_hpf: (level: [1], col: 2, scale: \default),
  \m_lpf: (level: [0], col: 2, scale: \default),
  \m_distortion: (level: [1], col: 3, scale: \default),
  \m_volume: (level: [0], col: 3, scale: \default),
  \m_interpolationTime: (level: [0], col: 0, scale: \default)
);

(
  create: {
    arg self, director, storage, masterDirector;
    var mft, mftActionLevelOne, mftActionLevelTwo, port, connection, rateDoubleClick, reverseTimers, resetTimers, rateReset, output, masterChannelActionUp, masterChannelActionDown, masterFeedback, poswinTimers, poswinDoubleClick;

    mftActionLevelOne = {
      arg knobInput;
      var noteNumber, address;
      address = addressesA[knobInput[1]][knobInput[0]];
      director.accumParameter(address, knobInput[2]);
    };
    mftActionLevelTwo = {
      arg knobInput;
      var noteNumber, address;
      address = addressesB[knobInput[1]][knobInput[0]];
      director.accumParameter(address, knobInput[2]);
    };

    masterChannelActionUp = {
      arg knobInput;
      var param = masterChannelLevelOne[knobInput[0] - 1];
      masterDirector.accumParameter((name: param, track: 0), knobInput[2]);
    };
    masterChannelActionDown = {
      arg knobInput;
      var param = masterChannelLevelTwo[knobInput[0] - 1];
      masterDirector.accumParameter((name: param, track: 0), knobInput[2]);
    };
    
    reverseTimers = Array.fill(3, {timerFactory.create(0.25)});
    rateDoubleClick = {
      arg track;
      switch (reverseTimers[track].getStatus, 
        false, {reverseTimers[track].open},
        true, {director.reverseParameter(addressesC[track][1]); reverseTimers[track].close},
        {}
      )
    };
    resetTimers = Array.fill(3, {timerFactory.create(0.3)});
    rateReset = {
      arg track, trigger;
      switch (trigger,
        true, { resetTimers[track].open() },
        false, {
          resetTimers[track].fireIfClosed({director.resetParameter(addressesC[track][1])})
        }, {}
      )
    };

    poswinTimers = Array.fill(3, {timerFactory.create(0.25)});
    poswinDoubleClick = {
      arg track;
      switch (poswinTimers[track].getStatus, 
        false, {poswinTimers[track].open},
        true, {director.resetParameter(addressesA[track][0]); director.resetParameter(addressesB[track][0]); poswinTimers[track].close},
        {}
      )
    };

    port = MIDIIn.findPort("Midi Fighter Twister", "Midi Fighter Twister MIDI 1");
    connection = MIDIIn.connect(0, port);
    output = MIDIOut.newByName("Midi Fighter Twister", "Midi Fighter Twister MIDI 1");
    output.latency = 0;

    MIDIdef.new(\mft_in, {
      |velocity, noteNumber, channel|
      var gridMsg;
      gridMsg = midi_to_grid.value(noteNumber, velocity);
      switch (channel,
        0, { mftActionLevelOne.value(gridMsg) },
        4, { mftActionLevelTwo.value(gridMsg) },
        {}
      );
    }, msgNum: (0..11), msgType: \control, srcID: port.uid);

    MIDIdef.new(\rate_buttons, {
      |velocity, noteNumber, channel|
      var gridMsg, track;
      gridMsg = midi_to_grid.value(noteNumber, velocity);
      track = gridMsg[1];
      if (velocity > 0, { rateDoubleClick.value(track) });
      rateReset.value(track, (velocity > 0));
    }, chan: 1, msgNum: [1,5,9], msgType: \control, srcID: port.uid);

    MIDIdef.new(\poswin_buttons, {
      |velocity, noteNumber, channel|
      var gridMsg, track;
      gridMsg = midi_to_grid.value(noteNumber, velocity);
      track = gridMsg[1];
      if (velocity > 0, { poswinDoubleClick.value(track) });
    }, chan: 1, msgNum: [0,4,8], msgType: \control, srcID: port.uid);

    MIDIdef.new(\interp_ctrl, {
      |noteNumber, velocity, channel|
      var gridMsg = midi_to_grid.value(velocity, noteNumber);
      storage.accumInterpolationTime(gridMsg[2]);
    }, msgNum: 12, msgType: \control, srcID: port.uid);

    MIDIdef.new(\master_controls, {
      |noteNumber, velocity, channel|
      var gridMsg = midi_to_grid.value(velocity, noteNumber);
      switch (channel,
        0, { masterChannelActionUp.value(gridMsg) },
        4, { masterChannelActionDown.value(gridMsg) },
        {}
      );
    }, msgNum: (13..15), msgType: \control, srcID: port.uid);

    masterFeedback = {
      arg address, value;
      var parameter, mapping;
      parameter = address['name'];
      mapping = masterParams_to_controller[parameter];
      mapping.level.do({
        arg i;
        var noteNum, channel, velocity, scale;
        scale = mapping.scale;
        if (scale == \default, 
          {velocity = (value * 127).asInteger},
          {velocity = value.linlin(scale[0], scale[1], scale[2], scale[3]).asInteger}
        );
        noteNum = grid_to_midi.value(mapping.col, address['track'] + 3);
        channel = i * 4;
        output.control(channel, noteNum, velocity);
      });
    };

    (
      receiveParameter: {
        arg self, address, value;
        var parameter, mapping;

        switch (address.name,
          \m_reverbIn, {masterFeedback.value(address, value)},
          \m_hpf, {masterFeedback.value(address, value)},
          \m_lpf, {masterFeedback.value(address, value)},
          \m_distortion, {masterFeedback.value(address, value)},
          \m_volume, {masterFeedback.value(address, value)},
          \m_interpolationTime, {masterFeedback.value(address, value)},
          {
            parameter = address['name'];
            mapping = params_to_controller[parameter];
            mapping.level.do({
              arg i;
              var noteNum, channel, velocity, scale;
              scale = mapping.scale;
              if (scale == \default, 
                {velocity = (value * 127).asInteger},
                {velocity = value.linlin(scale[0], scale[1], scale[2], scale[3]).asInteger}
              );
              noteNum = grid_to_midi.value(mapping.col, address['track']);
              channel = i * 4;
              output.control(channel, noteNum, velocity);
            });
          }
        )
      },
      receiveInterpolationTime: {
        |self, time|
        output.control(0, 12, time * 0.2 * 127);
      }
    )
  }
)
