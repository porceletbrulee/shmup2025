class_name BulletManager extends Node

@export var BULLETS: Array[Bullet] = []

func _ready():
	for bullet in BULLETS:
		bullet.manager = self

func prepare(v: Vector2, target: Node2D):
	for bullet in BULLETS:
		bullet.prepare(v, target)
