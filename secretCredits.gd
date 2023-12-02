extends Node3D

var mous_pos : Vector2 = Vector2(0,0)
var screen_size : Vector2 
var old_mous_pos : Vector2
@export var ang_a : float = 0.1

func _physics_process(delta):
	mous_pos = get_window().get_mouse_position()
	screen_size = get_window().size
	self.look_at_from_position(self.position,mapPos(old_mous_pos.lerp(mous_pos,ang_a),screen_size))
	old_mous_pos = old_mous_pos.lerp(mous_pos,ang_a)

func mapPos(pos,size) -> Vector3:
	var centered := Vector2((pos.x - size.x/2)/size.x, (size.y/2 - pos.y)/size.y)
	return Vector3(centered.x * 3, centered.y * 2, -1)
