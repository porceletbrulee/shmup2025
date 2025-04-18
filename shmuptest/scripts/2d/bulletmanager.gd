class_name BulletManager extends Node

@export var bullets: Array[Bullet] = []

func _ready():
	for bullet in bullets:
		bullet.manager = self

func prepare(v: Vector2, target: Node2D):
	for bullet in bullets:
		bullet.prepare(v, target)
