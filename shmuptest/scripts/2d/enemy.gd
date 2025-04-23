class_name Enemy extends Area2D

var manager: EnemyPatternManager
var path_follow: PathFollow2D
var shooters: Array[Shooter]
var speed: float

var _started: bool = false

func _cleanup():
	self.queue_free()
	if self.path_follow != null:
		self.path_follow.queue_free()
	if self.manager != null:
		self.manager.enemy_cleaned_up()

func _process(delta_sec: float):
	if self._started:
		# units are in 20% of path per sec
		self.path_follow.progress_ratio += delta_sec * self.speed * 0.2
		if self.path_follow.progress_ratio >= 1.0:
			self._cleanup()	

func start(target: Node2D):
	self._started = true
	self.visible = true
	for shooter in shooters:
		shooter.start(self, target)
