class_name UIController extends Node

static var _instance: UIController = UIController.new()

static func instance() -> UIController:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance
