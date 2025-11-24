extends CharacterBody2D
const JUMP_VELOCITY = -400.0
var fall = 1

func _physics_process(delta: float) -> void:
	if fall != 1:
		velocity += get_gravity() * delta
	move_and_slide()


func _on__button_up() -> void:
	fall = 0
	await get_tree().create_timer(1.4).timeout
