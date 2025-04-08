extends Node2D

@export var shooter: Node2D

var _player: Node2D
var _blue_bullet_shooter: LinearBulletShooter


func _ready():
	var blue_bullet = preload("res://scenes/bluebullet.tscn")
	var shoot_blue_bullet = func(elapsed_sec: float, since_last_shoot_sec: float) -> Array:
		var radians_per_shoot = 2.0 * PI / 64
		var fire_rate = 0.2
		var speed = 75
		if since_last_shoot_sec >= fire_rate:
			var v = Vector2(1, 0)
			var angle = (elapsed_sec / fire_rate) * radians_per_shoot
			return [true, v.rotated(angle) * speed]
		return [false, Vector2()]
	self._blue_bullet_shooter = LinearBulletShooter.new(blue_bullet,
														shoot_blue_bullet)

	self._player = preload("res://scenes/player.tscn").instantiate()
	self._player.ui_hits = $hud/hits
	self._player.ui_hits.text = "Hits: 0"
	self.add_child(self._player)
	self._player.transform.origin = Vector2(250, 400)

func _process(delta_sec: float):
	var bullet = self._blue_bullet_shooter.maybe_shoot(delta_sec, self._player)
	if bullet != null:
		self.shooter.add_child(bullet)
