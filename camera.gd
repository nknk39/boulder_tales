extends Camera2D
var controller
var shake_amount = 0.0
var shake_duration = 0.0
var shake_timer = 0.0
var max_displacement = 0.7  # Set your desired maximum displacement
var x_coordinate
var y_coordinate
var trigger_pos
var custom_offset = Vector2()

var ork_idle
var stamina_bar

# Original starting position
var original_position = Vector2()

# Interpolation variables
var interpolate_factor = 0.1
var interpolation_progress = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	controller = get_parent().get_node("Controller")
	ork_idle = get_parent().get_node('Throwing_Animations').get_node("Ork_Idle")
	original_position = position  # Save the original starting position
	stamina_bar = get_parent().get_node('InGame_UI/StaminaBar')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var control1_released = Input.is_action_just_released("control1")

	# Check if the shake is active
	if shake_timer > 0.0:
		shake_timer -= delta
		custom_offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))

		# Normalize the vector and multiply by the maximum displacement
		custom_offset = custom_offset.normalized() * max_displacement
	else:
		custom_offset = Vector2()

	# Apply the offset to the camera position
	position += custom_offset

	# Check position conditions only if the shake is done
	if shake_timer <= 0.0:
		trigger_pos = controller.get_child_position()
		x_coordinate = trigger_pos.x
		y_coordinate = trigger_pos.y

		if control1_released && stamina_bar.value >= 20 && !(x_coordinate >= -10 and y_coordinate >= -5 and x_coordinate <= 10 and y_coordinate <= 5) && ork_idle.throw_flag == false:
			start_shake(10, 0.5)

		# Interpolate back to the original position after the last shake
		if position != original_position:
			interpolation_progress += interpolate_factor * delta
			position = position.lerp(original_position, interpolation_progress)
			if interpolation_progress >= 1.0:
				interpolation_progress = 0.0

func start_shake(amount, duration):
	shake_amount = amount
	shake_duration = duration
	shake_timer = duration

func _input(event):
	if stamina_bar.value >= 20 && event.is_action_released("control1") and !(x_coordinate >= -10 and y_coordinate >= -5 and x_coordinate <= 10 and y_coordinate <= 5) && ork_idle.throw_flag == false:
		start_shake(10, 0.5)
