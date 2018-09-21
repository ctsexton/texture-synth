var addressFactory, sampleMenuFactory;
addressFactory = (~global_APP_DIRECTORY +/+ "/core/address.scd").load;

(
  create: {
    arg self, director, parentView, allSamples, trackIndex;
    var itemAction, items, sampleAddress;

	  sampleAddress = addressFactory.create(trackIndex, 'soundFile');

    items = allSamples.collect({
      arg item, i;
      allSamples[i].soundFile.path -> {director.switchSoundFile(sampleAddress, allSamples[i])};
    });
    EZPopUpMenu.new(parentView, Rect(0, 0, 600, 22), nil, items);
  }
)
