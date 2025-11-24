extends CharacterBody2D
const JUMP_VELOCITY = -400.0
var fall = 1

func _physics_process(delta: float) -> void:
	if fall != 1:
		velocity += get_gravity() * delta
	move_and_slide()


func _on__button_up() -> void:
	fall = 0
	await get_tree().create_timer(2.15).timeout
	print("2.15 s timeout finish redirect on level1")
	get_tree().change_scene_to_file("res://Senes/Levels/LevelOne.tscn")
