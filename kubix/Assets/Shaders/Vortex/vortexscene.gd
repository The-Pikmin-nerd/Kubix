extends TextureRect

func _shrink_and_disappear() -> void:
	var tween = create_tween()

	# On réduit le bouton jusqu'à 0
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func Appear() -> void:
	var tween = create_tween()

	# On réduit le bouton jusqu'à 0
	tween.tween_property(self, "scale", Vector2.ONE, 1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2.ZERO  # commence à 0
	Appear()
	await get_tree().create_timer(3).timeout
	_shrink_and_disappear()
	await get_tree().create_timer(2).timeout
	queue_free() #optimization

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
