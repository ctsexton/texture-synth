var addressFactory, sampleMenuFactory;
addressFactory = "../core/address.scd".loadRelative[0];

(
  create: {
    arg self, director, parentView, allSamples, trackIndex;
    var itemAction, items, sampleAddress;

	  sampleAddress = addressFactory.create(trackIndex, 'soundFile');

    itemAction = {};
    items = allSamples.collect({
      arg item, i;
      allSamples[i].soundFile.path -> {director.switchSoundFile(sampleAddress, allSamples[i])};
    });
    EZPopUpMenu.new(parentView, Rect(0, 0, 600, 22), nil, items);
  }
)
