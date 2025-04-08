extends CharacterBody2D

@export var SPEED: float = 150.0

var hits: int = 0
var ui_hits: Label = null

func _physics_process(delta):
	self.handle_movement(delta)

func handle_movement(_delta_sec: float):
	self.velocity.x = 0.0
	self.velocity.y = 0.0

	if Input.is_action_pressed("ui_left"):
		self.velocity.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		self.velocity.x += 1.0
	if Input.is_action_pressed("ui_up"):
		self.velocity.y -= 1.0
	if Input.is_action_pressed("ui_down"):
		self.velocity.y += 1.0

	if velocity.is_zero_approx():
		return
		
	self.velocity = self.velocity.normalized()
	self.velocity *= self.SPEED
	
	self.move_and_slide()

func on_hit(bullet: Bullet):
	self.hits += 1
	self.ui_hits.text = "Hits: {0}".format([hits])
	bullet.queue_free()
