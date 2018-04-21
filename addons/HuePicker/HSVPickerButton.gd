tool
extends Button

export(Color) var color setget set_color, get_color
signal color_changed(color)

var isReady = false

func set_color(value):
	color = value
	emit_signal('color_changed', value)

	if isReady:
		$ColorRect.color = color
		$ColorRect.self_modulate.a = color.a

func get_color():
	return color

func get_color_from_popup(color):  #Receiving the color form the hue picker
	self.color = color
	$ColorRect.color = color 
	$ColorRect.self_modulate.a = color.a
#	print ("modulating.. %s" % $ColorRect.self_modulate)

	emit_signal('color_changed', color)

func _ready():
	if color == null:  
		color = ColorN('white')
	$PopupPanel/HuePicker.color = color
	isReady = true 

func _on_HSVPickerButton_pressed():
	#Get quadrant I reside in so we can adjust the position of the popup.
	var quadrant = (get_viewport().size - rect_global_position)  / get_viewport().size
	quadrant.x = 1-round(quadrant.x); quadrant.y = 1-round(quadrant.y)

	var adjustment = Vector2(0,0)
	match quadrant:
		Vector2(0,0):  #Upper-left
#			print ("UL")
			adjustment.x += rect_size.x

		Vector2(1,0):  #Upper-right
#			print ("UR")
			adjustment.x = -$PopupPanel.rect_size.x

		Vector2(0,1):  #Lower-left
#			print ("LL")
			adjustment.x += rect_size.x
			adjustment.y = -$PopupPanel.rect_size.y

		Vector2(1,1):  #Lower-right
#			print ("LR")
			adjustment.x = -$PopupPanel.rect_size.x
			adjustment.y = -$PopupPanel.rect_size.y
			
	
	
	$PopupPanel.rect_position = rect_global_position + adjustment 
	$PopupPanel.popup()
	


func _on_PopupPanel_about_to_show():
	#Connect to the hue picker so we can succ its color
#	print ("Connectan")
	$PopupPanel/HuePicker.connect('color_changed',self,"get_color_from_popup")

func _on_PopupPanel_popup_hide():
	#Disconnect from the hue picker
	$PopupPanel/HuePicker.disconnect('color_changed', self, "get_color_from_popup")
	
	