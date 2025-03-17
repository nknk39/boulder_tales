var sprite
	var c_shape
	var emerald_pieces = 4
	var c_force = Vector2(300,300)
	
	var velocity_x = alphaball.linear_velocity.x/20
	var velocity_y = alphaball.linear_velocity.y/20

	for i in range(emerald_pieces):
		new_rigid_body = RigidBody2D.new()
		sprite = Sprite2D.new()
		c_shape = CollisionShape2D.new()
							
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
