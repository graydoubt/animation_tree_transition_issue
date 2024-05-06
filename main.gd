extends CanvasLayer


var triggered: bool = false

@export var automatic: bool = true


func _on_button_down():
	triggered = true


func _on_button_up():
	triggered = false


## Called from the fire animation
func _fire():
	print("%s::_fire() -> pew pew! (%d)" % [self, Time.get_ticks_msec()])
