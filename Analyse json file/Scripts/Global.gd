extends Node2D


func ReturnFactorial(num):
	if num == 1:
		return 1;
	else:
		return num*ReturnFactorial(num-1);

class ExampleClass:
	
	var INFOS = {
		'abacaxi': 'abacaxi',
	}
	
	func setInfo(info, value) -> void:
		var error = true
		for z in INFOS:
			if z == info:
				error = false
				break
		if error == true:
			printerr('setInfo failed! info: '+str(info))
			breakpoint
		else:
			INFOS[info] = value
	
	func getInfo(info):
		var error = true
		for z in INFOS:
			if z == info:
				error = false
				break
		if error == true:
			printerr('getInfo failed! info: '+str(info))
			breakpoint
		else:
			return INFOS[info]

func set_process_bit(obj, value):
	obj.set_process(value)
	obj.set_physics_process(value)
	obj.set_process_input(value)
	obj.set_process_internal(value)
	obj.set_process_unhandled_input(value)
	obj.set_process_unhandled_key_input(value)
