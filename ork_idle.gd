extends AnimatedSprite2D
var ork_chest_hit
var ork_throwing_main
var throw_flag
var control_pressed_flag

var prethrow_flag
var alphaball
var area_throwable
var throwable_area_image

var throw_timer_c
var throw_timer
var throw_timer_passed

var global_time
var chest_hit_check_timer = 8
var chest_hit_last_played

var orkthrowmain
var orkthrow1
var orkthrow2
var orkthrow3

var orkthrow1_is_playing
var orkthrow2_is_playing
var orkthrow3_is_playing

var ork_idle

var throw1_turner
var throw2_turner
var throw3_turner

var throw1
var throw2
var throw3
var throwarrow

var throw1anim
var throw2anim
var throw3anim

var postothrow

var global_mouse_position

# Called when the node enters the scene tree for the first time.
func _ready():
	throwarrow = get_parent().get_node('ArrowTurner/ThrowingPointerArrow')
	
	ork_chest_hit = get_parent().get_node('Ork_Chest_Hit')
	ork_throwing_main = get_parent().get_node('Ork_Throwing_Main')
	chest_hit_last_played = 0
	control_pressed_flag = false
	
	throwable_area_image = get_parent().get_parent().get_node('ThrowableArea')
	
	self.visible = false
	ork_throwing_main.play()
	throw_flag = true
	prethrow_flag = true
	alphaball = get_parent().get_parent().get_node('Alphaball')
	
	throw_timer_c = 0.3
	
	throw_timer_passed = false
	orkthrowmain = get_parent().get_node('Ork_Throwing_Main')
	orkthrow1 = get_parent().get_node('OrkThrowHand1Idle')
	orkthrow2 = get_parent().get_node('OrkThrowHand2Idle')
	orkthrow3 = get_parent().get_node('OrkThrowHand3Idle')
	ork_idle = get_parent().get_node('Ork_Idle')
	
	orkthrow1_is_playing = false
	orkthrow2_is_playing = false
	orkthrow3_is_playing = false
	
	throw1 = get_parent().get_node('Hand1Turner/OrkThrowHand1')
	throw1_turner = get_parent().get_node('Hand1Turner')
	throw2 = get_parent().get_node('Hand2Turner/OrkThrowHand2')
	throw2_turner = get_parent().get_node('Hand2Turner')
	throw3 = get_parent().get_node('Hand3Turner/OrkThrowHand3')
	throw3_turner = get_parent().get_node('Hand3Turner')
	
	throw1anim = get_parent().get_node('OrkThrowHand1Animation')
	throw2anim = get_parent().get_node('OrkThrowHand2Animation')
	throw3anim = get_parent().get_node('OrkThrowHand3Animation')
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):
	if throwable_area_image.visible == true && control_pressed_flag == true:
		throwable_area_image.visible = false
	
	global_time = Time.get_ticks_msec() / 1000.0
	
	if throw_timer:
		if global_time - throw_timer >= throw_timer_c:
			throw_timer_passed = true
	
	global_mouse_position = get_global_mouse_position()
	if throw_flag == false:
		if global_time - chest_hit_last_played > chest_hit_check_timer:
			var randomA = randi_range(1,2)
			if randomA == 1:
				self.visible = false
				ork_chest_hit.visible = true
				
				ork_chest_hit.play()
				ork_chest_hit.frame = 0
				chest_hit_last_played = global_time
			if randomA == 2:
				pass
	
	if prethrow_flag == false:
		if global_mouse_position.y < 380:
			if control_pressed_flag == false:
				
				orkthrow1.visible = false
				orkthrow2.visible = false
				orkthrow3.visible = true
				
				throw1_turner.visible = false 
				throw2_turner.visible = false
				throw3_turner.visible = true
			
			if area_throwable == true && Input.is_action_pressed("control1") && orkthrow1_is_playing == false && orkthrow2_is_playing == false && orkthrow3_is_playing == false:
				control_pressed_flag = true
				
				orkthrow1_is_playing = false
				orkthrow2_is_playing = false
				orkthrow3_is_playing = true
				
				orkthrowmain.visible = false
				orkthrow3.visible = false
				throw3_turner.visible = false

				throw3anim.visible = true
				throw3anim.play()
				throwable_area_image.visible = false
				
				throw_timer = global_time
				
		elif global_mouse_position.y < 500:
			if control_pressed_flag == false:
				
				orkthrow1.visible = false
				orkthrow2.visible = true
				orkthrow3.visible = false

				throw1_turner.visible = false 
				throw2_turner.visible = true
				throw3_turner.visible = false
				
			if area_throwable == true && Input.is_action_pressed("control1") && orkthrow1_is_playing == false && orkthrow2_is_playing == false && orkthrow3_is_playing == false:
				control_pressed_flag = true
				
				orkthrow1_is_playing = false
				orkthrow2_is_playing = true
				orkthrow3_is_playing = false
				
				orkthrowmain.visible = false
				orkthrow2.visible = false
				throw2_turner.visible = false
				
				throw2anim.visible = true
				throw2anim.play()
				throwable_area_image.visible = false
				
				throw_timer = global_time
		else:
			
			if control_pressed_flag == false:
				orkthrow1.visible = true
				orkthrow2.visible = false
				orkthrow3.visible = false
				
				throw1_turner.visible = true
				throw2_turner.visible = false
				throw3_turner.visible = false
			
			if area_throwable == true && Input.is_action_pressed("control1") && orkthrow1_is_playing == false && orkthrow2_is_playing == false && orkthrow3_is_playing == false:
				control_pressed_flag = true
				
				orkthrow1_is_playing = true
				orkthrow2_is_playing = false
				orkthrow3_is_playing = false
				
				orkthrowmain.visible = false
				orkthrow1.visible = false
				throw1_turner.visible = false
				
				throw1anim.visible = true
				throw1anim.play()
				throwable_area_image.visible = false
				
				throw_timer = global_time

func throw (mouse_position):	
	var scale_x = mouse_position.x - 192
	var scale_y = mouse_position.y - 187
	var scaleD = Vector2(scale_x, scale_y)

	var launchForce = Vector2(scaleD.x*3, scaleD.y*3)
	var maxLaunchForce = 1000.0
	
	var launchForceMagnitude = launchForce.length()
	if launchForceMagnitude > maxLaunchForce:
		launchForce = launchForce.normalized() * maxLaunchForce
	alphaball.apply_impulse(launchForce, launchForce)

func _on_ork_chest_hit_animation_looped():
	var randomB = randi_range(1,2)
	if randomB == 1:
		ork_chest_hit.play()
	else:
		ork_chest_hit.visible = false
		self.visible = true


func _on_ork_throwing_main_animation_finished():
	prethrow_flag = false
	
	ork_throwing_main.visible = false
	orkthrow1.visible = true
	throw1_turner.visible = true
	throwable_area_image.visible = true

func _on_ork_throw_hand_1_animation_animation_finished():
	prethrow_flag = true
	throw_flag = false
	throw1anim.visible = false
	throw1anim.stop()
	
	ork_idle.frame = 1
	ork_idle.visible = true
	ork_idle.play()
	
	throwarrow.visible = false
	
	alphaball.position = Vector2(192,187)
	postothrow = alphaball.position
	
	alphaball.freeze = false
	alphaball.visible = true
	
	if area_throwable == true:
		throw(global_mouse_position)

func _on_ork_throw_hand_2_animation_animation_finished():
	prethrow_flag = true
	throw_flag = false
	throw2anim.visible = false
	throw2anim.stop()
	
	ork_idle.frame = 1
	ork_idle.visible = true
	ork_idle.play()
	
	throwarrow.visible = false
	
	postothrow = alphaball.position
	alphaball.position = Vector2(192,187)
	
	alphaball.freeze = false
	alphaball.visible = true
	
	if area_throwable == true:
		throw(global_mouse_position)

func _on_ork_throw_hand_3_animation_animation_finished():
	prethrow_flag = true
	throw_flag = false
	throw3anim.visible = false
	throw3anim.stop()
	
	ork_idle.frame = 1
	ork_idle.visible = true
	ork_idle.play()
	
	throwarrow.visible = false

	postothrow = alphaball.position
	alphaball.position = Vector2(192,187)
	
	alphaball.freeze = false
	alphaball.visible = true

	if area_throwable == true:
		throw(global_mouse_position)


func _on_throwable_area_mouse_entered():
	area_throwable = true


func _on_throwable_area_mouse_exited():
	area_throwable = false
