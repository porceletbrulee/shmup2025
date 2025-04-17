extends Node2D

@export var shooter: Node2D

var _player: Node2D
var _blue_bullet_shooter: LinearBulletShooter
var _red_bullet_shooter: LinearBulletShooter
var _diamond_path_bullet_shooter: LinearBulletShooter

func _ready():
	var blue_bullet = preload("res://scenes/bluebullet.tscn")
	var shoot_blue_bullet = func(elapsed_sec: float,
								since_last_shoot_sec: float,
								salvo_count,
								target: Node2D) -> Array:
		var radians_per_shoot = 2.0 * PI / 64
		var fire_rate = 0.2
		var speed = 75
		if since_last_shoot_sec >= fire_rate:
			var v = Vector2(1, 0)
			var angle = (elapsed_sec / fire_rate) * radians_per_shoot
			return [true, v.rotated(angle) * speed, salvo_count]
		return [false, Vector2(), salvo_count]
	self._blue_bullet_shooter = LinearBulletShooter.new(blue_bullet,
														shoot_blue_bullet)

	var red_bullet = preload("res://scenes/redbullet.tscn")
	var shoot_red_bullet = func(elapsed_sec: float,
								since_last_shoot_sec: float,
								salvo_count,
								target: Node2D) -> Array:
		var salvo_size = 4
		var salvo_break = 0.6
		var fire_rate = 0.3
		var speed = 150
		if salvo_count >= salvo_size:
			if salvo_break >= since_last_shoot_sec:
				return [false, Vector2(), salvo_count]
			return [false, Vector2(), 0]
		if since_last_shoot_sec >= fire_rate:
			var v = Vector2(1, 0)
			var angle = self.shooter.get_angle_to(target.global_position)
			return [true, v.rotated(angle) * speed, salvo_count + 1]
		return [false, Vector2(), salvo_count]
	self._red_bullet_shooter = LinearBulletShooter.new(red_bullet, shoot_red_bullet)


	var diamond_path_bullet = preload("res://scenes/diamondpathbullet.tscn")
	var shoot_diamond_path_bullet = func(elapsed_sec: float,
										 since_last_shoot_sec: float,
										 salvo_count,
										 target: Node2D) -> Array:
		if since_last_shoot_sec > 1.0:
			return [true, Vector2(0, 1), 0]
		else:
			return [false, Vector2(), salvo_count]
	self._diamond_path_bullet_shooter = LinearBulletShooter.new(diamond_path_bullet, shoot_diamond_path_bullet)

	self._player = preload("res://scenes/player.tscn").instantiate()
	self._player.ui_hits = $hud/hits
	self._player.ui_hits.text = "Hits: 0"
	self.add_child(self._player)
	self._player.transform.origin = Vector2(250, 400)

func _process(delta_sec: float):
	for bullet_shooter in [
		self._blue_bullet_shooter,
		self._red_bullet_shooter,
		self._diamond_path_bullet_shooter,
	]:
		var b = bullet_shooter.maybe_shoot(delta_sec, self._player)
		if b != null:
			self.shooter.add_child(b)
