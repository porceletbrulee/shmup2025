class_name Shooter extends Resource

var shot_gap_sec: float
var _bullet_callback: Callable
var _origin: Node2D
var _target: Node2D

var _timer: Timer

func _init(
	pshot_gap_sec: float,
	bullet_callback: Callable,
	timer_parent: Node,
):
	self.shot_gap_sec = pshot_gap_sec
	self._bullet_callback = bullet_callback

	self._timer = Timer.new()
	self._timer.autostart = false
	self._timer.one_shot = false
	self._timer.timeout.connect(self._shoot)

	timer_parent.add_child(self._timer)

func _shoot():
	self._bullet_callback.call(self._origin, self._target)
	self._timer.start(self.shot_gap_sec)

func start(origin: Node2D, target: Node2D):
	self._origin = origin
	self._target = target
	#self._timer.start(self.shot_gap_sec)
	self._shoot()
	
func stop():
	self._timer.stop()
