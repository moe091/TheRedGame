extends Node

var Event = load("res://Scripts/src/events/Event.gd")
var EventLoader = load("res://Scripts/src/events/EventLoader.gd").new()
var events : Array = []
var curEventNum = 0
var curEvent: get = _getCurEvent
var controller
var ref
var parent
var groupName



func loadEvents(src, levelRef, parentNode, EventController):
	ref = levelRef
	parent = parentNode
	controller = EventController
	var data = EventLoader.loadEventChain("res://Assets/Events/" + src + ".json", self)
	events = data.events
	groupName = data.groupName

func start():
	curEventNum = -1
	doNext()
	
func trigger(subEvent):
	print("Triggering subEvent", subEvent)
	
func interact(target):
	if curEvent.interactable and "parent" in curEvent and target == curEvent.parent:
		doNext()
	
func doNext():
	if "interactable" in parent:
		parent.interactable = false
		
	curEventNum+= 1
	if curEvent:
		if curEvent.sideEvents.size() > 0:
			for e in curEvent.sideEvents:
				print("[EventGroup::doNext] TRIGGER SIDE EVENT: ", e)
				controller.trigger(e)
		
		if curEvent.cancelEvents.size() > 0:
			for e in curEvent.cancelEvents:
				print("[EventGroup::doNext] CANCEL SIDE EVENT: ", e)
				controller.cancel(e)
				
		await curEvent.do()
		
		if curEvent.triggerNext:
			doNext()
		elif curEvent.interactable:
			parent.interactable = true
		elif curEvent.condition:
			ref.awaitCondition(curEvent, doNext)
	
func _getCurEvent():
	if events.size() > curEventNum:
		return events[curEventNum]
	else:
		return null
