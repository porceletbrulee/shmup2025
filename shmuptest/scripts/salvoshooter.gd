class_name SalvoShooter extends RefCounted

var shot_gap_sec: float
var salvo_gap_sec: float
var salvo_size: int
var _bullet_callback: Callable

var _curr_shots: int
var _timer: Timer

func _init(
	pshot_gap_sec: float,
	psalvo_gap_sec: float,
	psalvo_size: int,
	bullet_callback: Callable,
	timer_parent: Node,
):
	self.shot_gap_sec = pshot_gap_sec
	self.salvo_gap_sec = psalvo_gap_sec
	self.salvo_size = psalvo_size
	self._bullet_callback = bullet_callback

	self._curr_shots = 0

	self._timer = Timer.new()
	self._timer.autostart = false
	self._timer.one_shot = false
	self._timer.timeout.connect(self._shoot)

	timer_parent.add_child(self._timer)

func _shoot():
	self._bullet_callback.call()
	self._curr_shots += 1
	if self._curr_shots >= self.salvo_size:
		self._curr_shots = 0
		self._timer.start(self.salvo_gap_sec)
	else:
		self._timer.start(self.shot_gap_sec)

func start():
	self._shoot()
