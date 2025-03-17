extends RigidBody2D

var score
var collision_counter 

# Called when the node enters the scene tree for the first time.
func _ready():
	self.mass = 90
	score = 15
	collision_counter = -10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if collision_counter >= -7:
		self.freeze = false
