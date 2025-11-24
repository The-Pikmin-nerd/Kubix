extends Node2D

func _ready() -> void:
	_play_slide_in()

func _play_slide_in() -> void:
	var tween = create_tween()

	# Commence à gauche hors de l'écran (-300 pixels)
	var start_position = position + Vector2(-300, 0)
	position = start_position
	modulate.a = 1  

	# Animation : glisse vers la position normale + fade in
	tween.tween_property(self, "position", position - Vector2(-300, 0), 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
