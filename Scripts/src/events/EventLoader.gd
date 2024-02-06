extends Resource

var Event = load("res://Scripts/src/events/event.gd")
var props = ["eventName", "type", "condition", "data", "interactable", "preDelay", "postDelay", "duration", "triggerNext",
	"hideCurrentDialog", "hidePreviousDialog", "parent", "next", "args", "sideEvents", "cancelEvents"]

#func loadEvent(src, ref):
#	print("LOAD EVENT CALLED", src)
#	var file = FileAccess.open(src, FileAccess.READ)
#	var loadedData = JSON.parse_string(file.get_as_text())
#
#	print("LOADED JSON: ", loadedData)
#	var event = Event.new()
#
#	for p in props: #p is the (possible) name of a property, loadedData is where the property/value is
#		if p in loadedData:
#			if p == "parent":
#				event.set(p, ref.get(loadedData.get(p)))
#				print("Setting PARENT Property to", ref.get(loadedData.get(p)))
#			else:
#				event.set(p, loadedData.get(p))
#				print("Setting Property " + p + " to ", loadedData.get(p))
#
#	if event.type == "method":
#		print("TYPE IS METHOD. EVENT.DATA = ", event.data)
#		event.data = ref.get(event.data)
#
#	return event
	
	
func loadEventChain(src, group):
	var file = FileAccess.open(src, FileAccess.READ)
	var loadedData = JSON.parse_string(file.get_as_text())
	var events = []
	
	for e in loadedData.events:
		var event = loadEvent(e, group)
		if events.size() > 0:
			events[events.size() - 1].next = event
		events.append(event)
		
	return {"events": events, "groupName": loadedData.name}
		
		
		
func loadEventMap(src, group):
	var file = FileAccess.open(src, FileAccess.READ)
	var loadedData = JSON.parse_string(file.get_as_text())
	var events = {}
	
	for e in loadedData.events:
		print("E=", e)
		var event = loadEvent(loadedData.events[e], group)
		event.group = group
		event.eventName = e
		events[e] = event
	
	return {"events": events, "groupName": loadedData.name}
	
	
	
func loadEvent(loadedData, group):	
	var event = Event.new()
	event.getTree = group.ref.get_tree #hacky fix. event can't use get_tree because it's not a node in the scene tree
	for p in props: #p is the (possible) name of a property, loadedData is where the property/value is
		if p in loadedData:
			if p == "parent":
				event.set(p, group.ref.get(loadedData.get(p)))
			else:
				event.set(p, loadedData.get(p))
				
	if event.type == "method":
		event.data = group.ref.get(event.data)
			
	if !"parent" in event:
		event.parent = group.parent
		
	return event
			
