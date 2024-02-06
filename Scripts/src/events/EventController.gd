extends Node

var EventChain = load("res://Scripts/src/events/EventChain.gd")
var EventMap = load("res://Scripts/src/events/EventMap.gd")
var groups : Dictionary = {}
var activeGroups : Array = []


func loadChain(path, ref, parent):
	var g = EventChain.new()
	g.loadEvents(path, ref, parent, self)
	groups[g.groupName] = g
	
func loadMap(path, ref, parent):
	var m = EventMap.new()
	m.loadEvents(path, ref, parent, self)
	groups[m.groupName] = m

func startGroup(groupName):
	groups[groupName].start()
	activeGroups.append(groupName)
	
func stopGroup(groupName):
	groups[groupName].stop()
	activeGroups.erase(groupName)

func interact(target):
	for n in activeGroups:
		groups[n].interact(target)

#TODO:: ERROR HANDLING
func trigger(eventName):
	if eventName.contains("."):
		var parts = eventName.split(".")
		print("[DEBUG] Triggering sub event " + parts[1] + " in root " + parts[0])
		groups[parts[0]].trigger(parts[1])
	else:
		print("[DEBUG] Triggering root event: ", eventName)
		groups[eventName].start()
	#if the name contains a "." then it is referring to a sub Event. 
	#split on the ".", left half is the group and right half is the event
	#then call groups[leftPart].trigger(groups[rightPart])
	
	#if no ".", then just call groups[eventName].start()
	
#TODO:: ERROR HANDLING
func cancel(eventName):
	if eventName.contains("."):
		var parts = eventName.split(".")
		groups[parts[0]].cancel(parts[1])
	else:
		groups[eventName].cancel()
