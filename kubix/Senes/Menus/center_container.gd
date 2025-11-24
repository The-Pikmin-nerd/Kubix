extends CenterContainer

func _ready() -> void:
	_play_fall_from_sky()

func _play_fall_from_sky() -> void:
	for child in get_children():
		if child is Control:
			var tween = create_tween()
			
			# Commence au-dessus de sa position normale
			var start_position = child.position + Vector2(0, -200)
			child.position = start_position
			child.modulate.a = 1  # invisible au départ
			
			# Descend vers la position normale + fade in
			tween.tween_property(child, "position", child.position + Vector2(0, 200), 1.0)\
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(child, "modulate:a", 1.0, 1.0)\
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
