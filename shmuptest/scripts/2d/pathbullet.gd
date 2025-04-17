class_name PathBullet extends Bullet

@export var path_follow: PathFollow2D

var _speed: float

# default direction is down == Vector2(0, 1)
func prepare(velocity: Vector2, target: Node2D):
	self._speed = velocity.length()
	self.prepare_target(target)
	# TODO: allow rotation of path element

func _process(delta_sec: float):
	# units are in 20% of path per sec
	self.path_follow.progress_ratio += delta_sec * self._speed * 0.2
	if self.path_follow.progress_ratio >= 1.0:
		self.bullet_cleanup()

func bullet_cleanup():
	super()
	self.manager.queue_free()
