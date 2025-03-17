extends AnimatedSprite2D

var q1stone4
var q3stone11
var q4stone8

var protrusion1
var protrusion2
var protrusion3

var metal_chest1
var metal_chest2
var metal_chest3
var metal_chest_animation
var metal_chest_animation_flag

var wooden_chest

var metal_chest_diff = 28
var wooden_chest_diff = 38

var main
var rng1

func _ready():
	self.play()
		
	protrusion1 = get_parent().get_node('Chests').get_node('Protrusion1')
	protrusion2 = get_parent().get_node('Chests').get_node('Protrusion2')
	protrusion3 = get_parent().get_node('Chests').get_node('Protrusion3')
	
	main = get_parent()
	
	metal_chest1 = get_parent().get_node('Chests').get_node('Metal_Chest1')
	metal_chest2 = get_parent().get_node('Chests').get_node('Metal_Chest2')
	metal_chest3 = get_parent().get_node('Chests').get_node('Metal_Chest3')
	metal_chest_animation = get_parent().get_node('Chests').get_node('Metal_Chest_Animation')
	
	wooden_chest = get_parent().get_node('Chests').get_node('Wooden_Chest')
	
	rng1 = randi_range(1,3)
func _process(_delta):
		if main.q1stone4_isbroken == true && rng1 == 1:
			self.stop()
			self.visible = false
			metal_chest_animation_flag = true
		if main.q4stone8_isbroken == true && rng1 == 2:
			self.stop()
			self.visible = false
			metal_chest_animation_flag = true
		if main.q3stone11_isbroken == true && rng1 == 3:
			self.stop()
			self.visible = false
			metal_chest_animation_flag = true
