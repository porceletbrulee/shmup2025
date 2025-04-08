class_name LinearBullet extends Bullet

var _velocity = Vector2()

func prepare(velocity: Vector2, target: Node2D):
	self._velocity = velocity
	# TODO: maybe put bullets on different collision masks so player bullets
	# and enemy bullets don't trigger this
	var target_entered = func (entered_target: Node2D):
		if entered_target == target:
			target.on_hit(self)
	self.body_entered.connect(target_entered)

func _process(delta_sec: float):
	self.transform.origin += self._velocity * delta_sec
