extends RigidBody2D
var collision_counter = 7
var metal_chest_animation
var metal_chest1
var chest_flag

var main
var alphaball

# Called when the node enters the scene tree for the first time.
func _ready():
	metal_chest1 = get_parent().get_node('Metal_Chest1')
	metal_chest_animation = get_parent().get_node('Metal_Chest_Animation')
	
	main = get_parent().get_parent()
	alphaball = get_parent().get_parent().get_node('Alphaball')
	
	chest_flag = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if collision_counter >= 10 && chest_flag == true:
		chest_flag = false
		metal_chest_animation.position = metal_chest1.position
		metal_chest_animation.frame = 0
		metal_chest_animation.visible = true
		metal_chest_animation.play()
		
		metal_chest1.visible = false

func _on_metal_chest_animation_animation_finished():
	var emerald_pieces = 5
	var blue_crystal_pieces = 10
	
	var new_rigid_body
	var sprite
	var c_shape
	
	var offset_x = randf_range(-5, 5)
	var offset_y = randf_range(-5, 5)

	var velocity_x = alphaball.linear_velocity.x/20
	var velocity_y = alphaball.linear_velocity.y/20
	
	var c_force = Vector2(300,300)
	
	for i in range(emerald_pieces):
		new_rigid_body = RigidBody2D.new()
		sprite = Sprite2D.new()
		c_shape = CollisionShape2D.new()
						
		new_rigid_body.position = metal_chest1.position + Vector2(offset_x, offset_y)
		new_rigid_body.mass = 0.05
						
		sprite.texture = preload("res://Emerald.png")
		new_rigid_body.name = 'emerald'
		main.emerald_counter += 1
						
		var poly_c = CollisionPolygon2D.new()
		poly_c.polygon = PackedVector2Array([Vector2(-5, 0), Vector2(0, 10), Vector2(5, 0), Vector2(0,-10)])
		var convex_shape = ConvexPolygonShape2D.new()
		convex_shape.points = poly_c.polygon
		c_shape.shape = convex_shape

		new_rigid_body.add_child(sprite)
		new_rigid_body.add_child(c_shape)
		new_rigid_body.z_index = 4
		main.call_deferred("add_child", new_rigid_body)
		var resource_group = "Resources"
		new_rigid_body.add_to_group(resource_group)
						
		new_rigid_body.linear_velocity.x += velocity_x
		new_rigid_body.linear_velocity.y += velocity_y
		new_rigid_body.apply_central_impulse(c_force)

	for i in range(blue_crystal_pieces):
		new_rigid_body = RigidBody2D.new()
		sprite = Sprite2D.new()
		c_shape = CollisionShape2D.new()
					
		new_rigid_body.position = metal_chest1.position + Vector2(offset_x, offset_y)
		new_rigid_body.mass = 0.05
					
		sprite.texture = preload("res://square_gem_blue.png")
		new_rigid_body.name = 'blue_crystal'
		main.blue_crystals_counter += 1
					
		var poly_c = CollisionPolygon2D.new()
		poly_c.polygon = PackedVector2Array([Vector2(-7, 0), Vector2(0, 10), Vector2(7, 0), Vector2(0,-10)])
		var convex_shape = ConvexPolygonShape2D.new()
		convex_shape.points = poly_c.polygon
		c_shape.shape = convex_shape

		new_rigid_body.add_child(sprite)
		new_rigid_body.add_child(c_shape)
		new_rigid_body.z_index = 4
		main.call_deferred("add_child", new_rigid_body)
		var resource_group = "Resources"
		new_rigid_body.add_to_group(resource_group)
					
		new_rigid_body.linear_velocity.x += velocity_x
		new_rigid_body.linear_velocity.y += velocity_y
		new_rigid_body.apply_central_impulse(c_force) 

	metal_chest1.queue_free()
