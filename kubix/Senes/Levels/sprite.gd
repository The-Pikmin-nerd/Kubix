extends Sprite2D

func _ready() -> void:
	# Départ avec un scale nul (invisible / compressé)
	scale = Vector2(0, 0)
	await get_tree().create_timer(2).timeout
	var tween := create_tween()

	# Scale 0 → 1 en 1 seconde
	tween.tween_property(self, "scale", Vector2(0.1, 0.1), 1.0)

	# Rotation 0 → 360° en 1 seconde, en parallèle
	tween.parallel().tween_property(self, "rotation_degrees", 360.0, 1.0)
