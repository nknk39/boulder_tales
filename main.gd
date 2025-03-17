extends Node2D

#Collision
var global_collision_counter = 0
var score_counter
var collision_sound
var min_ef_speed = 150

#Game Mechanics
var winscreen
var winscreen_counter
var loss_label_counter
var loss_label
var alpha_ball
var controller
var camera
var starting_mass
var total_mass = 0
var shader_timeout
var child_storage
var shader_collision
var pulling_area
var pot_area
var magma_touch
var teleport_sound
var absorb_anim 
var lava
var game_win_sound

var resources

var emerald_counter_win
var blue_crystal_counter_win
var golden_nugget_counter_win
var coal_counter_win

var q1stone4_isbroken
var q3stone11_isbroken
var q4stone8_isbroken

const lava_particle_timer = 0.5
var lava_particle_emitted

var destr_bar_main

#volcanoes
var volcano1
var volcano2
var volcano3
var volcano4

var last_pull_applied
var pull_timer = 0.01

#resource_goals and scores
var emerald_target_score
var blue_crystal_target_score
var golden_nugget_target_score
var coal_target_score

var emerald_score
var blue_crystal_score
var golden_nugget_score
var coal_score

#Resource counters
var golden_nuggets_counter
var blue_crystals_counter
var coal_counter
var emerald_counter

var last_collision_time = []
var time_global

#Level Seed
var seed = randi_range(3, 6)

var collision_timers = {}
var shader_start_times = {}
var resoursec_drops = {}

#Collision sound managing variables
var last_played = 0
var last_played_magma = 0
const timer = 0.05
const timer_magma = 0.15

var losing_sequence
var bg_music

#Animation
var collision_sprite

var texture_on_collision
var pos_on_collision = Vector2(0,0)
var texture_on_collision_w = 0
var texture_on_collision_h = 0
var body_name
var body_node
var frame_counter =  0

var rand_emerald_target
var rand_blue_crystals_target
var rand_golden_nuggets_target
var rand_coal_target

func _ready():
	emerald_counter_win = get_node('InGame_UI/Winscreen/PlayAgain/Emerald_Counter')
	blue_crystal_counter_win = get_node('InGame_UI/Winscreen/PlayAgain/Blue_Crystal_Counter')
	golden_nugget_counter_win = get_node('InGame_UI/Winscreen/PlayAgain/Gold_Nugget_Counter')
	coal_counter_win = get_node('InGame_UI/Winscreen/PlayAgain/Coal_Counter')
	
	emerald_counter = 0
	blue_crystals_counter = 0
	golden_nuggets_counter = 0
	coal_counter = 0
	
	winscreen_counter = 0

	last_pull_applied = 0
	
	game_win_sound = get_node('Game_Win_Sound')
	winscreen = get_node('InGame_UI').get_node('Winscreen')
	loss_label_counter = 0
	destr_bar_main = get_node('InGame_UI').get_node('DestructionBarMain')
	losing_sequence = get_node('Losing_Sequence')
	
	emerald_score = get_node('InGame_UI').get_node("cur_score_emerald")
	blue_crystal_score = get_node('InGame_UI').get_node("cur_score_blue_crystal")
	golden_nugget_score = get_node('InGame_UI').get_node("cur_score_golden_nugget")
	coal_score = get_node('InGame_UI').get_node("cur_score_coal")
	
	emerald_target_score = get_node('InGame_UI').get_node("target_score_emerald")
	blue_crystal_target_score = get_node('InGame_UI').get_node("target_score_blue_crystal")
	golden_nugget_target_score = get_node('InGame_UI').get_node("target_score_golden_nugget")
	coal_target_score = get_node('InGame_UI').get_node("target_score_coal")
	
	rand_emerald_target = randi_range(3,8)
	rand_blue_crystals_target = randi_range(5,10)
	rand_golden_nuggets_target = randi_range(5,13)
	rand_coal_target = randi_range(10,20)
	
	if rand_emerald_target < 10:
		emerald_target_score.text = str(0, 0, rand_emerald_target)
	elif rand_emerald_target >= 10:
		emerald_target_score.text = str( 0, rand_emerald_target)

	blue_crystal_target_score.text = str(0, rand_blue_crystals_target)
	golden_nugget_target_score.text = str(0, rand_golden_nuggets_target)
	coal_target_score.text = str(0, rand_coal_target)
	
	resources = get_tree().get_nodes_in_group('Resources')
	score_counter = get_node("scorecounter")
	loss_label = get_node('InGame_UI').get_node("game_loss_label")
	alpha_ball = get_node('Alphaball')
	controller = get_node('Controller')
	camera = get_node('Camera2D')
	pulling_area = get_node('Pulling_Area')
	pot_area = get_node("Pot_Area")
	
	lava = get_node('Lava')
	
	time_global = 0
	lava_particle_emitted = 0
	
	absorb_anim = get_node('Absoprtion_Resource_Animation')
	teleport_sound = get_node('Teleportation_Sound')
	collision_sound = get_node('COLLISION_SOUND')
	bg_music = get_node('BG_MUSIC_LEVEL')
	
	magma_touch = get_node('Magma_Touch')
	
	for node in get_tree().get_nodes_in_group("Destr_Stones"):
		var rigidbody = node as RigidBody2D
		rigidbody.continuous_cd = true
		total_mass += rigidbody.mass
	starting_mass = total_mass
	print("Total mass: " + str(total_mass))

func _process(_delta):
	
	score_counter.text = str(global_collision_counter)
	score_counter.text = str(global_collision_counter)
	
	if emerald_counter < 10:
		emerald_score.text = str(0,0,emerald_counter)
	elif emerald_counter < 100 && emerald_counter >= 10:
		emerald_score.text = str(0,emerald_counter)
		
	if blue_crystals_counter < 10:
		blue_crystal_score.text = str(0,0,blue_crystals_counter)
	elif blue_crystals_counter < 100 && blue_crystals_counter >= 10:
		blue_crystal_score.text = str(0,blue_crystals_counter)
	
	if golden_nuggets_counter < 10:
		golden_nugget_score.text = str(0,0,golden_nuggets_counter)
	elif golden_nuggets_counter < 100 && golden_nuggets_counter >= 10:
		golden_nugget_score.text = str(0,golden_nuggets_counter)
		
	if coal_counter < 10:
		coal_score.text = str(0,0,coal_counter)
	elif coal_counter < 100 && coal_counter >= 10:
		coal_score.text = str(0,coal_counter)
	
	if emerald_counter >= rand_emerald_target && blue_crystals_counter >= rand_blue_crystals_target && golden_nuggets_counter >= rand_golden_nuggets_target && coal_counter >= rand_coal_target && winscreen_counter == 0: 
		emerald_counter_win.text = emerald_score.text
		blue_crystal_counter_win.text = blue_crystal_score.text
		golden_nugget_counter_win.text = golden_nugget_score.text
		coal_counter_win.text = coal_score.text
		
		
		bg_music.stop()
		get_tree().paused = true
		if game_win_sound.is_playing() == false:
			game_win_sound.play()
		winscreen.visible = true
		winscreen_counter += 1
	
	var b_stones = get_tree().get_nodes_in_group("Bounce_Stones")
	var b_d_stones = get_tree().get_nodes_in_group("Bounce_Destr_Stones")
	var d_stones = get_tree().get_nodes_in_group("Destr_Stones")
	var resources = get_tree().get_nodes_in_group("Resources")
	var treasures = get_tree().get_nodes_in_group("Treasures")
	var geodes = get_tree().get_nodes_in_group('Geodes')
	
	for resource in resources:
		if resource.position.y <= 215:
			resource.queue_free()
	
	var process_time = Time.get_ticks_msec() / 1000.0
	time_global = process_time
	
	for stone in b_stones + d_stones + b_d_stones + treasures + geodes:
		if shader_start_times.has(stone.get_name()):
			var elapsed_time = process_time - shader_start_times[stone.get_name()]
			if elapsed_time >  0.1: #  0.3 seconds in milliseconds
				for child in stone.get_children():
					if child is Sprite2D:
						child.material = null
						shader_start_times.erase(stone)
						
	frame_counter +=  1
	if process_time - last_pull_applied > pull_timer:
		last_pull_applied = process_time
		for resource in resources:
			var pull_force = 1.0
			var center = pulling_area.global_position
			var direction = (center - resource.global_position).normalized()
			resource.apply_impulse(direction*pull_force)
		
	if destr_bar_main.value >= 40:
		loss_label.visible = true
		
	if loss_label.visible == true && loss_label_counter == 0:
		bg_music.stop()
		get_tree().paused = true
		if losing_sequence.is_playing() == false:
			losing_sequence.play()
		loss_label_counter += 1
		
func _on_alphaball_body_entered(body):
	if body.is_in_group("Treasures") || body.is_in_group("Geodes"):
		body.collision_counter += 1
	
	if body.is_in_group("Geodes") && body.collision_counter >= 0:
		if body.name == 'EmeraldGeode':
			var square_piece_number = 4
			for i in range(square_piece_number):
				var sprite
				var c_shape
				var new_rigid_body
				
				var velocity_x = alpha_ball.linear_velocity.x/20
				var velocity_y = alpha_ball.linear_velocity.y/20
				var c_force = Vector2(1000,1000)
				
				new_rigid_body = RigidBody2D.new()
				sprite = Sprite2D.new()
				c_shape = CollisionShape2D.new()
				
				new_rigid_body.mass = 0.05
				
				sprite.texture = preload("res://Emerald.png")
				new_rigid_body.name = 'emerald'
				
				var poly_c = CollisionPolygon2D.new()
				poly_c.polygon = PackedVector2Array([Vector2(-5, 0), Vector2(0, 10), Vector2(5, 0), Vector2(0,-10)])
				var convex_shape = ConvexPolygonShape2D.new()
				convex_shape.points = poly_c.polygon
				c_shape.shape = convex_shape

				new_rigid_body.add_child(sprite)
				new_rigid_body.add_child(c_shape)
				new_rigid_body.z_index = 4
				self.call_deferred("add_child", new_rigid_body)
				
				var resource_group = "Resources"
				new_rigid_body.add_to_group(resource_group)
				
				var emerald_group = "Emeralds"
				new_rigid_body.add_to_group(emerald_group)
				
				new_rigid_body.linear_velocity.x += velocity_x
				new_rigid_body.linear_velocity.y += velocity_y
				new_rigid_body.apply_central_impulse(c_force)
				print('Spawned!')
			body.queue_free()
		if body.name == 'BlueCrystalGeode':
			var square_piece_number = 8
			for i in range(square_piece_number):
				var sprite
				var c_shape
				var new_rigid_body
				
				var velocity_x = alpha_ball.linear_velocity.x/20
				var velocity_y = alpha_ball.linear_velocity.y/20
				var c_force = Vector2(1000,1000)
				
				new_rigid_body = RigidBody2D.new()
				sprite = Sprite2D.new()
				c_shape = CollisionShape2D.new()
				
				new_rigid_body.mass = 0.05
				
				sprite.texture = preload("res://square_gem_blue.png")
				new_rigid_body.name = 'blue_crystal'
				
				var poly_c = CollisionPolygon2D.new()
				poly_c.polygon = PackedVector2Array([Vector2(-7, 0), Vector2(0, 10), Vector2(7, 0), Vector2(0,-10)])
				var convex_shape = ConvexPolygonShape2D.new()
				convex_shape.points = poly_c.polygon
				c_shape.shape = convex_shape

				new_rigid_body.add_child(sprite)
				new_rigid_body.add_child(c_shape)
				new_rigid_body.z_index = 4
				self.call_deferred("add_child", new_rigid_body)
				
				var resource_group = "Resources"
				new_rigid_body.add_to_group(resource_group)
				
				var blue_crystals_group = "BlueCrystals"
				new_rigid_body.add_to_group(blue_crystals_group)
				
				new_rigid_body.linear_velocity.x += velocity_x
				new_rigid_body.linear_velocity.y += velocity_y
				new_rigid_body.apply_central_impulse(c_force) 
				print('Spawned!')
			body.queue_free()
		
	last_collision_time.append(time_global)
			
	#Collision sound contion
	var alpha_time = Time.get_ticks_msec() / 1000.0
	
	if alpha_time - last_played > timer && alpha_ball.linear_velocity.length() > 70 && body.name != 'Lava': 
		last_played = alpha_time
		collision_sound.play()
	
	#Get body name
	if body is RigidBody2D:
		body_name = body.name
	
	#Shader and crash logic
	if body_name != null:
		if body.is_in_group("Bounce_Stones") || body.is_in_group("Bounce_Destr_Stones") && alpha_ball.linear_velocity.length() > 200:
			var cur_velocity = alpha_ball.linear_velocity
			var direction = cur_velocity.normalized()
			var magnitude = cur_velocity.length() + 300
			
			var new_velocity = direction*magnitude
			alpha_ball.linear_velocity = new_velocity
			
		if alpha_ball.linear_velocity.length() >= min_ef_speed:
			
			if body.is_in_group("Destr_Stones"):
				split_on_collision(body)
			
			if body.name == 'Lava' && time_global - lava_particle_emitted > lava_particle_timer:
				lava_particle_emitted = time_global
				
				var lava_particle1 = RigidBody2D.new()
				var lava_particle2 = RigidBody2D.new()
				var lava_particle3 = RigidBody2D.new()
				
				var c_force1 = Vector2(0,0)
				var c_force2 = Vector2(0,0)
				var c_force3 = Vector2(0,0)
				
				var sprite1 = Sprite2D.new()
				var sprite2 = Sprite2D.new()
				var sprite3 = Sprite2D.new()
				sprite1.texture = preload('res://lava_particle.png')
				sprite2.texture = preload('res://lava_particle.png')
				sprite3.texture = preload('res://lava_particle.png')
				
				var c_shape1 = CollisionShape2D.new()
				var c_shape2 = CollisionShape2D.new() 
				var c_shape3 = CollisionShape2D.new()
				
				var rect_shape = RectangleShape2D.new()
				rect_shape.extents = Vector2(4,4)
				c_shape1.shape = rect_shape
				c_shape2.shape = rect_shape
				c_shape3.shape = rect_shape

				lava_particle1.add_child(sprite1)
				lava_particle1.add_child(c_shape1)
				lava_particle1.collision_mask =  0
				
				lava_particle2.add_child(sprite2)
				lava_particle2.add_child(c_shape2)
				lava_particle2.collision_mask =  0
				
				lava_particle3.add_child(sprite3)
				lava_particle3.add_child(c_shape3)
				lava_particle3.collision_mask =  0
				
				var rand = randi_range(20,30)
				if rand > 25:
					lava_particle1.position.x = alpha_ball.position.x + rand
					lava_particle1.position.y = alpha_ball.position.y - rand
					
					lava_particle2.position.x = alpha_ball.position.x + rand
					lava_particle2.position.y = alpha_ball.position.y - rand
					
					lava_particle3.position.x = alpha_ball.position.x - rand
					lava_particle3.position.y = alpha_ball.position.y - rand
					
					c_force1 = Vector2(100, -100)
					c_force2 = Vector2(80, -80)
					c_force3 = Vector2(-90, -90)
				elif rand < 25:
					lava_particle1.position.x = alpha_ball.position.x - rand
					lava_particle1.position.y = alpha_ball.position.y - rand
					
					lava_particle1.position.x = alpha_ball.position.x - rand
					lava_particle1.position.y = alpha_ball.position.y - rand

					lava_particle1.position.x = alpha_ball.position.x + rand
					lava_particle1.position.y = alpha_ball.position.y - rand
					
					c_force1 = Vector2(-100, -100)
					c_force2 = Vector2(-80, -80)
					c_force3 = Vector2(90, -90)
						
				get_tree().root.call_deferred("add_child", lava_particle1)
				get_tree().root.call_deferred("add_child", lava_particle2)
				get_tree().root.call_deferred("add_child", lava_particle3)
				
				if lava_particle1:
					lava_particle1.apply_central_impulse(c_force1)
				if lava_particle2:
					lava_particle1.apply_central_impulse(c_force2)
				if lava_particle3:
					lava_particle1.apply_central_impulse(c_force3)
					
				
			if body.is_in_group("Destr_Stones") || body.is_in_group("Bounce_Destr_Stones") || body.is_in_group("Treasures") || body.is_in_group("Geodes"):
				global_collision_counter += 1
				
				for child in body.get_children():
					if child is Sprite2D:
						child_storage = child
						
						#fix the condition. it bugs the timer out
						shader_collision = ShaderMaterial.new()
						shader_collision.shader = load('res://collision.gdshader')
						child_storage.material = shader_collision
								
						var brighness_level = 8.0 
						shader_collision.set_shader_parameter("brightness", brighness_level)
						
						shader_start_times[body.get_name()] = Time.get_ticks_msec() / 1000.0

func split_on_collision(original):
	if original.collision_counter < 0:
		original.collision_counter += 1
	
	elif original.collision_counter >= 0:
		
		global_collision_counter += original.score
		var mass = original.mass
		var position = original.global_position
		
		var collision_shape_name = original.get_name() + "_Collision"
		var collision_shape = original.get_node(collision_shape_name)
		var shape = collision_shape.polygon
		
		var cube_size = 5

		var area = calculate_area(shape)
		var whole_area = area - fmod(area, 1)
		var square_piece_number = whole_area / cube_size
		square_piece_number = (square_piece_number - fmod(square_piece_number, 1))/60
		if square_piece_number < 1:
			square_piece_number = 1
		
		for i in range(square_piece_number):
			var sprite
			var c_shape
			var new_rigid_body
			
			var velocity_x = alpha_ball.linear_velocity.x/20
			var velocity_y = alpha_ball.linear_velocity.y/20
			var c_force = Vector2(1000,1000)
			
			var rand = randi_range(1,100)
			if rand <= 5:
				new_rigid_body = RigidBody2D.new()
				sprite = Sprite2D.new()
				c_shape = CollisionShape2D.new()
				
				new_rigid_body.position = original.position
				new_rigid_body.mass = 0.05
				
				sprite.texture = preload("res://Emerald.png")
				new_rigid_body.name = 'emerald'
				
				var poly_c = CollisionPolygon2D.new()
				poly_c.polygon = PackedVector2Array([Vector2(-5, 0), Vector2(0, 10), Vector2(5, 0), Vector2(0,-10)])
				var convex_shape = ConvexPolygonShape2D.new()
				convex_shape.points = poly_c.polygon
				c_shape.shape = convex_shape

				new_rigid_body.add_child(sprite)
				new_rigid_body.add_child(c_shape)
				new_rigid_body.z_index = 4
				self.call_deferred("add_child", new_rigid_body)
				
				var resource_group = "Resources"
				new_rigid_body.add_to_group(resource_group)
				
				var emerald_group = "Emeralds"
				new_rigid_body.add_to_group(emerald_group)
				
				new_rigid_body.linear_velocity.x += velocity_x
				new_rigid_body.linear_velocity.y += velocity_y
				new_rigid_body.apply_central_impulse(c_force) 
			if rand <= 10:
				new_rigid_body = RigidBody2D.new()
				sprite = Sprite2D.new()
				c_shape = CollisionShape2D.new()
				
				new_rigid_body.position = original.position
				new_rigid_body.mass = 0.05
				
				sprite.texture = preload("res://square_gem_blue.png")
				new_rigid_body.name = 'blue_crystal'
				
				var poly_c = CollisionPolygon2D.new()
				poly_c.polygon = PackedVector2Array([Vector2(-7, 0), Vector2(0, 10), Vector2(7, 0), Vector2(0,-10)])
				var convex_shape = ConvexPolygonShape2D.new()
				convex_shape.points = poly_c.polygon
				c_shape.shape = convex_shape

				new_rigid_body.add_child(sprite)
				new_rigid_body.add_child(c_shape)
				new_rigid_body.z_index = 4
				self.call_deferred("add_child", new_rigid_body)
				
				var resource_group = "Resources"
				new_rigid_body.add_to_group(resource_group)
				
				var blue_crystals_group = "BlueCrystals"
				new_rigid_body.add_to_group(blue_crystals_group)
				
				new_rigid_body.linear_velocity.x += velocity_x
				new_rigid_body.linear_velocity.y += velocity_y
				new_rigid_body.apply_central_impulse(c_force) 
			elif rand <= 50:
				new_rigid_body = RigidBody2D.new()
				sprite = Sprite2D.new()
				c_shape = CollisionShape2D.new()

				new_rigid_body.position = original.position
				new_rigid_body.mass = 0.05
				
				var circle_shape = CapsuleShape2D.new()
				circle_shape.radius = 3
				circle_shape.height = 10
				c_shape.shape = circle_shape
				
				sprite.texture = preload("res://gold_nugget.png") # replace with the path to your texture
				
				new_rigid_body.name = 'gold_nugget'
				
				new_rigid_body.add_child(sprite)
				new_rigid_body.add_child(c_shape)
				new_rigid_body.z_index = 4
				self.call_deferred("add_child", new_rigid_body)
				
				var resource_group = "Resources"
				new_rigid_body.add_to_group(resource_group)
				
				var gold_nugget_group = "GoldNuggets"
				new_rigid_body.add_to_group(gold_nugget_group)
				
				new_rigid_body.linear_velocity.x += velocity_x
				new_rigid_body.linear_velocity.y += velocity_y
				new_rigid_body.apply_central_impulse(c_force) 	
			else:
		# Default case: Create a single part
				new_rigid_body = RigidBody2D.new()
				sprite = Sprite2D.new()
				c_shape = CollisionShape2D.new()
				
				var circle_shape = CapsuleShape2D.new()
				circle_shape.height = 6.5
				circle_shape.radius = 6
				c_shape.shape = circle_shape
				
				new_rigid_body.position = original.position
				new_rigid_body.mass = 0.05
				
				sprite.texture = preload("res://Coal.png")
				new_rigid_body.name = 'coal'
				
				new_rigid_body.add_child(sprite)
				new_rigid_body.add_child(c_shape)
				new_rigid_body.z_index = 4
				self.call_deferred("add_child", new_rigid_body)
				
				var resource_group = "Resources"
				new_rigid_body.add_to_group(resource_group)
				
				var coal_group = "Coals"
				new_rigid_body.add_to_group(coal_group)
				
				new_rigid_body.linear_velocity.x += velocity_x
				new_rigid_body.linear_velocity.y += velocity_y
				new_rigid_body.apply_central_impulse(c_force) 
				
		total_mass -= original.mass
		print(total_mass)
		
		original.queue_free()

func calculate_area(shape):
	var area = 0.0
	var j = shape.size() - 1
	for i in range(shape.size()):
		area += (shape[j].x + shape[i].x) * (shape[j].y - shape[i].y)
		j = i
	return abs(area / 2.0)

func _on_lava_slow_body_entered(body):
	if time_global - last_played_magma > timer_magma && body.name == 'Alphaball': 
		last_played_magma = time_global
		magma_touch.play()
	if body is RigidBody2D:
		if body.name != 'Alphaball':
			var body_velocity = body.linear_velocity
			body.linear_velocity = body_velocity *  0.0001
			
func _on_pot_area_body_entered(body):
	call_deferred("remove_resources", body)

func _on_absoprtion_resource_animation_animation_looped():
	absorb_anim.visible = false

func remove_resources(body):
	if body.is_in_group('Resources') && body.name != 'Alhpaball':
		if body.is_in_group("Emeralds"):
			emerald_counter += 1
		elif body.is_in_group("BlueCrystals"):
			blue_crystals_counter += 1
		elif body.is_in_group("GoldNuggets"):
			golden_nuggets_counter += 1
		elif body.is_in_group("Coals"):
			coal_counter += 1
		
		absorb_anim.position = body.position
		absorb_anim.visible = true
		absorb_anim.play()
		absorb_anim.frame = 0
		teleport_sound.play()
		body.queue_free() 
