extends Node3D

@onready var OpenAnim: AnimationPlayer = $OpenAnim

func open() -> void:
	OpenAnim.play("open")
