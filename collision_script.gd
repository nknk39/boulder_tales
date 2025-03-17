extends RigidBody2D

var score
var collision_counter 

# Called when the node enters the scene tree for the first time.
func _ready():
	self.mass = 60
	score = 10
	collision_counter = -8

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if collision_counter >= -6:
		self.freeze = false
