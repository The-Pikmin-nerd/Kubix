@tool

extends Node3D

var cam

func _ready():
	if Engine.is_editor_hint():
		cam = EditorInterface.get_editor_viewport_3d(0).get_camera_3d()
	else:
		cam = get_viewport().get_camera_3d()
	

func _process(_delta):
	var outside = cam.position.y < -0.5 or cam.position.y > 0.5 or Vector2(cam.position.x, cam.position.z).length() > 5.3
	$VolumetrixBoxOutside.visible = outside
	$VolumetrixBoxInside.visible = not outside
