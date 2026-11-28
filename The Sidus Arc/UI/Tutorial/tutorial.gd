extends CanvasLayer

@onready var label = $TextBox/Margin/Label
@onready var box = $TextBox

const tutorial: Array[String] = [
	"Here is your mana and health. You will use mana to cast spells and it will naturally regenerate. Your health will only replenish between levels, so be careful.",
	
	"Here is your hand. You will draw a card per turn. You can cast a spell by clicking on the card and then selecting a tile and pressing cast.",
	"Each card may have some amount of capabilities. That can be an attack, or a movement.",
	
	"Click here when you are finished with your turn.",
	
	"A hex with a red highlight on it is dangerous, an enemy will attack it.",
	"A hex with a blue highlight on it indicates an enemy will move to it."
]

const box_locations: Array[Vector2] = [
	Vector2(100, 520),
	
	Vector2(400, 520),
	Vector2(400, 520),
	
	Vector2(800, 520),
	
	Vector2(400, 375),
	Vector2(400, 375),
]

var can_player_place: bool = false
var current_tutorial: Array[String] = []
var current_box_locations: Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not visible:
		return
	
	if PlayerStateMachine.instance().get_player_can_place_cards():
		can_player_place = true
		PlayerStateMachine.instance().set_player_can_place_cards(false)
	
	if Input.is_action_just_pressed("cutscene_continue"):
		continue_tutorial()
	

func start_tutorial() -> void:
	visible = true
	current_tutorial = tutorial.duplicate()
	current_box_locations = box_locations.duplicate()
	
	label.text = current_tutorial.front()
	box.position = current_box_locations.front()

func continue_tutorial() -> void:
	current_tutorial.pop_front()
	current_box_locations.pop_front()
	
	if current_tutorial.is_empty():
		end_tutorial()
		return
	
	label.text = current_tutorial.front()
	box.position = current_box_locations.front()

func end_tutorial() -> void:
	visible = false
	if can_player_place:
		PlayerStateMachine.instance().set_player_can_place_cards(true)
