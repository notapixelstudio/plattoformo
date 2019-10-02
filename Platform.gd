tool
extends StaticBody2D

export var cell_size : int = 16 setget set_cell_size
export var width : int = 8 setget set_width
export var height : int = 2 setget set_height

func set_cell_size(value):
	cell_size = value
	refresh()

func set_width(value):
	width = value
	refresh()
	
func set_height(value):
	height = value
	refresh()
	
func _ready():
	refresh()
	
func refresh():
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.extents = 0.5*cell_size*Vector2(width, height)
	$CollisionShape2D.position = 0.5*cell_size*Vector2(width, height)
	$NinePatchRect.rect_size = cell_size*Vector2(width, height)
	