class_name BulletManager extends Node

@export var bullets: Array[Bullet] = []
var _bullets_cleaned_up: int = 0

func _ready():
	for bullet in bullets:
		bullet.manager = self

func prepare(v: Vector2, target: Node2D):
	for bullet in bullets:
		# TODO: maybe make a PathBulletManager that normalizes v on path length
		bullet.prepare(v, target)

func bullet_cleaned_up(bullet: Bullet):
	# for now, assume self.bullets is not dynamic
	self._bullets_cleaned_up += 1
	if self._bullets_cleaned_up >= self.bullets.size():
		assert(self._bullets_cleaned_up == self.bullets.size())
		self.queue_free()
