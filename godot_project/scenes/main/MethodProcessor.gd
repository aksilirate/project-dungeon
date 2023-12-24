class_name MethodProcessor extends Node




var methods_in_process: Array[Callable] = []






func call_method(callable: Callable, args: Array) -> void:
	if methods_in_process.has(callable):
		return
	
	methods_in_process.push_back(callable)
	await callable.callv(args)
	methods_in_process.erase(callable)
