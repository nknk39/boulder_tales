extends RigidBody2D

var score
var collision_counter 

# Called when the node enters the scene tree for the first time.
func _ready():
	self.mass = 30
	score = 5
	collision_counter = -5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if collision_counter >= -3:
		self.freeze = false
