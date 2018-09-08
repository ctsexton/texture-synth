(
create: {
	arg self, initVal;

	(
		val: initVal,
		accum: {|self, input|
			var direction;

			direction = input * 2 - 1;
			self.val = self.val + direction;
			self.val;
		},
		get: {
			arg self;
			self.val;
		}
	)

}
)