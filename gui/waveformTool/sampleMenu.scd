var addressFactory, sampleMenuFactory;
addressFactory = (~global_APP_DIRECTORY +/+ "/core/address.scd").load;

(
  create: {
    arg self, director, parentView, allSamples, trackIndex;
    var itemAction, items, sampleAddress;
	  sampleAddress = addressFactory.create(trackIndex, 'sample');

    items = allSamples.collect({
      arg item, i;
      allSamples[i].name -> {director.setParameter(sampleAddress, allSamples[i])};
    });
    EZPopUpMenu.new(parentView, Rect(0, 0, 600, 22), nil, items, initVal: trackIndex);
  }
)
