extends TextureProgressBar
var main
var starting_mass
var total_mass

var one_percent
var cur_percent
var destr_percent

var prev_destr_percent
var starting_flag

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent().get_parent()
	total_mass = 10000
	starting_mass = 10000
	
	starting_flag = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	starting_mass = main.starting_mass
	total_mass = main.total_mass
	one_percent = starting_mass/100
	
	cur_percent = round(total_mass/one_percent)
	destr_percent = 100-cur_percent
	
	if starting_flag == true && destr_percent != 0:
		self.value = destr_percent
		prev_destr_percent = destr_percent
		starting_flag = false
	
	if starting_flag == false && destr_percent > prev_destr_percent:
		self.value = destr_percent
		prev_destr_percent = destr_percent		
