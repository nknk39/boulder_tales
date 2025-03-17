extends Area2D
var pull_force = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for body in get_overlapping_bodies():
		if body.name == 'Alphaball':
			var direction = Vector2(0,-1)
			body.apply_central_impulse(direction * pull_force)
