extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Resources") || body.is_in_group("Destr_Stones"): 
		body.queue_free()
