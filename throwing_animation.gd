extends Node2D
var throw_main
var throw1
var throw1turner
var throw1idle

var throw2
var throw2turner
var throw2idle

var throw3
var throw3turner
var throw3idle
var throw_scale

var arrowturner
var arrowturner_pos
var throwarrow

var ork_idle

var global_mouse_position
var angle_to_mouse

var upper_border

var alphaball
# Called when the node enters the scene tree for the first time.
func _ready():
	throw_main = get_parent().get_node('Ork_Throwing_Main')
	alphaball = get_parent().get_parent().get_node('Alphaball')
	ork_idle = get_parent().get_node('Ork_Idle')
	
	throw1 = get_parent().get_node('Hand1Turner/OrkThrowHand1')
	throw1turner = get_parent().get_node('Hand1Turner')
	throw1idle = get_parent().get_node('OrkThrowHand2Idle')
	
	throw2 = get_parent().get_node('Hand2Turner/OrkThrowHand2')
	throw2turner = get_parent().get_node('Hand2Turner')
	throw2idle = get_parent().get_node('OrkThrowHand2Idle')
	
	throw3 = get_parent().get_node('Hand3Turner/OrkThrowHand3')
	throw3turner = get_parent().get_node('Hand3Turner')
	throw3idle = get_parent().get_node('OrkThrowHand3Idle')
	
	arrowturner = get_parent().get_node('ArrowTurner')
	throwarrow = get_parent().get_node('ArrowTurner/ThrowingPointerArrow')
	throwarrow.offset = Vector2(0,-1)
	
	upper_border = get_parent().get_parent().get_node('UpperBorder/CollisionPolygon2D')
	arrowturner_pos = arrowturner.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_mouse_position = get_global_mouse_position()
	angle_to_mouse = arrowturner_pos.angle_to_point(global_mouse_position)
	
	throwarrow.look_at(global_mouse_position)
	throwarrow.material.set_shader_parameter("mouse_position", global_mouse_position)
	
	if alphaball.position.y > 330:
		upper_border.disabled = false
		
	if throwarrow.rotation_degrees >= 120:
		throwarrow.rotation_degrees = 120
		
	if throwarrow.rotation_degrees <= 35:
		throwarrow.rotation_degrees = 35
