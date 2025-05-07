class_name GrazeArea extends Area2D

func on_graze() -> void:
	var parent: Node2D = self.get_parent()
	assert(parent.has_method("on_graze"))
	parent.on_graze()
