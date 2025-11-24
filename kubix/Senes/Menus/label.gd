extends Label

func _ready() -> void:
	_play_drop_entry()

func _play_drop_entry() -> void:
	var tween = create_tween()

	# Commence au-dessus de sa position finale
	var start_position = position + Vector2(0, -100)
	position = start_position
	modulate.a = 1  # commence invisible

	# Descend vers la position normale + fade in
	tween.tween_property(self, "position", position - Vector2(0, -100), 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
