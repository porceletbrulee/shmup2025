class_name LinearBullet extends Bullet

var _velocity = Vector2()

func prepare(velocity: Vector2, target: Node2D):
	self._velocity = velocity
	self.prepare_target(target)

func _process(delta_sec: float):
	self.transform.origin += self._velocity * delta_sec
