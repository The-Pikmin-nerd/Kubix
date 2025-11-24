extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	_play_entry_animation()

func _play_entry_animation() -> void:
	var tween = create_tween()

	# Commencer en dehors de l'écran (exemple : décalage vers la gauche)
	var start_position = position + Vector2(-300, 0)
	position = start_position
	modulate.a = 0  # commence invisible

	# Animation : glisse vers la position normale + fade in
	tween.tween_property(self, "position", position - Vector2(-300, 0), 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
