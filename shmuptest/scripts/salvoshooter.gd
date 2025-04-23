class_name SalvoShooter extends Shooter

var salvo_gap_sec: float
var salvo_size: int

var _curr_shots: int

func _init(
	pshot_gap_sec: float,
	psalvo_gap_sec: float,
	psalvo_size: int,
	bullet_callback: Callable,
	timer_parent: Node,
):
	super(pshot_gap_sec, bullet_callback, timer_parent)
	self.salvo_gap_sec = psalvo_gap_sec
	self.salvo_size = psalvo_size
	self._curr_shots = 0

func _shoot():
	self._bullet_callback.call(self._origin, self._target)
	self._curr_shots += 1
	if self._curr_shots >= self.salvo_size:
		self._curr_shots = 0
		self._timer.start(self.salvo_gap_sec)
	else:
		self._timer.start(self.shot_gap_sec)
