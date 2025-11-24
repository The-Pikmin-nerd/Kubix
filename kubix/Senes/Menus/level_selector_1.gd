extends Node2D

func _ready() -> void:
	_play_fall_from_sky()

func _play_fall_from_sky() -> void:
	for child in get_children():
		if child is Control:
			var tween = create_tween()
			
			# Commence au-dessus de sa position normale
			var start_position = child.position + Vector2(0, -800)
			child.position = start_position
			child.modulate.a = 1  # invisible au départ
			
			# Descend vers la position normale + fade in
			tween.tween_property(child, "position", child.position + Vector2(0, 800), 1.0)\
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(child, "modulate:a", 1.0, 1.0)\
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func _shrink_and_disappear() -> void:
	var tween = create_tween()

	# On réduit le bouton jusqu'à 0
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on__button_up() -> void:
	await get_tree().create_timer(1.5).timeout
	_shrink_and_disappear()
