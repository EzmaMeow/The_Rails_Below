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

@export var local_physic : Physic_State3D = Physic_State3D.new()
var segments : Array[Node3D]
		
var step:float = 0.0

var breaking = 0.0

#this is to be given to any vaild node becomes part of its
#space as well as removed when not. may use an object or resource in the future
#but dict for prototyping
#gravity is a modifier of the gravity
#not sure if it should be a fixed value instead. I want to use the
#system gravity if possible


#NOTE: array may be better on size, but removing elements can be costly
#if handling many. A diffrent type(like dictionary) or a diffrent system
#would be needed if handling many bodies that often switch between safe and unsafe
var unsafe_bodies : Array[PhysicsBody3D]
		
func update_scale():
	for i in range(segments.size()):
		segments[i].scale.z = segment_length * 0.5
	
func _ready() -> void:
	for i in range(segment_count):
		var new_segment := segment_type.instantiate()
		add_child(new_segment)
		segments.append(new_segment)
		new_segment.scale.z = segment_length * 0.5
	
func add_local_physic(body:PhysicsBody3D):
	var local_physics : Dictionary = body.get_meta('local_physics',{})
	local_physics[self] = local_physic
	body.set_meta('local_physics',local_physics)

func remove_local_physic(body:PhysicsBody3D):
	var local_physics : Dictionary = body.get_meta('local_physics',{})
	local_physics.erase(self)
	if local_physics.is_empty():
		body.remove_meta('local_physics')
		return
	body.set_meta('local_physics',local_physics)
		
func body_enter_safe_area(body: Node3D):
	if (!body):
		print_debug(self, ' null body ref in body_enter_safe_area')
		return
	if (body as PhysicsBody3D):
		unsafe_bodies.erase(body)
		remove_local_physic(body)
	#NOTE: temp way to force it to resume moving
	if (body as Character3D):
		breaking = 0.0
	print_debug(body, 'enter safe area')
	
func body_exit_safe_area(body: Node3D):
	if (!body):
		print_debug(self, ' null body ref in body_enter_safe_area')
		return

	if (body as PhysicsBody3D):
		unsafe_bodies.append(body)
		add_local_physic(body)
	#NOTE: temp way to force it to break when a character is unsafe
	if (body as Character3D):
		breaking = 0.1
	print_debug(body, 'exit safe area')
	
func _physics_process(delta: float) -> void:
	var half_size := segment_length * 0.5 * segment_count
	var current_speed = (speed - breaking) * delta
	if (breaking > 0.0 and breaking < speed):
		breaking += delta*speed*0.25
	elif (breaking > speed):
		breaking = speed
		
	local_physic.velocity = Vector3(0.0,0.0,speed - breaking)
	#for body in unsafe_bodies:
	#	body.position += Vector3(0.0,0.0,current_speed)
	if (step > segment_length):
		step = 0
	else:
		step += current_speed
	for i in range(segments.size()):
		segments[i].position.z = (segment_length * i + step) - half_size 
