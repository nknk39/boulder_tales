extends Sprite2D

var is_control1_pressed = false
var parent_node
var new_sprite
var ork_idle

# Define the radius of the bounding circle
var boundary_radius = 55 # Change this value as neededS

# Called when the node enters the scene tree for the first time.
func _ready():
	parent_node = get_parent()
	ork_idle = get_parent().get_node('Throwing_Animations').get_node('Ork_Idle')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ork_idle.prethrow_flag == true && ork_idle.throw_timer_passed == true:
		if Input.is_action_just_pressed("control1"):
			self.visible = true
			self.position = get_global_mouse_position()
			is_control1_pressed = true
			
			new_sprite = Sprite2D.new()
			new_sprite.position = self.position
			var texture = preload("res://trigger.png")
			
			new_sprite.texture = texture
			new_sprite.visible = true
			parent_node.add_child(new_sprite)
		elif Input.is_action_just_released("control1"):
			self.visible = false
			is_control1_pressed = false
			if new_sprite != null:
				new_sprite.queue_free()
				new_sprite = null
		elif is_control1_pressed and Input.is_action_pressed("control1"):
			var mouse_pos = get_global_mouse_position()
			
			# Convert the local position of the main node to global position
			var boundary_center = to_global(parent_node.position)
			
			# Calculate the distance between the mouse position and the boundary center
			var dist = (mouse_pos - boundary_center).length()
			
			# If the distance is greater than the boundary radius, move the sprite to the edge of the boundary
			if dist > boundary_radius:
				var dir = (mouse_pos - boundary_center).normalized()
				new_sprite.position = boundary_center + dir * boundary_radius
			else:
				new_sprite.position = mouse_pos

func _input(_event):
	pass
	
func get_child_position():
	if new_sprite != null:
		return self.to_local(new_sprite.global_position)
	else:
		return Vector2.ZERO
