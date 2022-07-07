extends Node
# class_name ErrorHandling

func criticalError(message: String):
	push_error(message)
	printerr(message)
	get_tree().quit()
