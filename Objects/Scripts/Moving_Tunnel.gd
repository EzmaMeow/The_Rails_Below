#This is a test for a moving platform to fake movement
#using a shader may be more efficent, but this may allow swapping of parts
#though the shader approch may also be able to handle it without moving parts
class_name Moving_Tunnel extends Node3D
@export var speed : float = 10.0
@export var segment_length : float = 100 :
	set(value):
		segment_length = value
		update_scale()
@export var segment_type : PackedScene
@export var segment_count : int = 10
var segments : Array[Node3D]
		
var step:float = 0.0
		
func update_scale():
	for i in range(segments.size()):
		segments[i].scale.z = segment_length * 0.5
	
func _ready() -> void:
	for i in range(segment_count):
		var new_segment := segment_type.instantiate()
		add_child(new_segment)
		segments.append(new_segment)
		new_segment.scale.z = segment_length * 0.5
	
func _physics_process(delta: float) -> void:
	var half_size := segment_length * 0.5 * segment_count
	if (step > segment_length):
		return
		step = 0
	else:
		step += speed * delta
	for i in range(segments.size()):
		segments[i].position.z = (segment_length * i + step) - half_size 
