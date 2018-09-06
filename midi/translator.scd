(
newMIDItoGRID: {
	arg self, gridSideLength, velocityMode = True;
	var direction;
	direction = {arg vel;
		if (vel > 64, 1, 0);
	};
	{
		arg nn, vel;
		var x, y, v;
		x = nn.mod(gridSideLength);
		y = nn.div(gridSideLength);
		if (velocityMode == True,
			{v = vel / 127},
			{v = direction.value(vel)}
		);
		[x, y, v];
	};
},
newGRIDtoMIDI: {
	arg self, gridSideLength;
	{
		arg x, y;
		y * gridSideLength + x;
	};
}
)