class_name Bullet extends Area2D

@onready var _visible_on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var manager: BulletManager = null

func _ready():
	self._visible_on_screen_notifier.screen_exited.connect(self.queue_free)

# target must have an on_hit function
func prepare_target(target: Node2D):
	# TODO: maybe put bullets on different collision masks so player bullets
	# and enemy bullets don't trigger this
	var target_entered = func (entered_target: Node2D):
		if entered_target == target:
			target.on_hit(self)
	self.body_entered.connect(target_entered)

func bullet_cleanup():
	self.queue_free()
