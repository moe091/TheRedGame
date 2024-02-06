extends Node

var Event = load("res://Scripts/src/events/Event.gd")
var EventLoader = load("res://Scripts/src/events/EventLoader.gd").new()
var curEvent: get = _getCurEvent
var controller
var ref
var parent
var groupName



func loadEvents(src, levelRef, parentNode, EventController):
	print("[EventGroup::loadEvents] LOAD EVENTS NOT IMPLEMENTED")

func start():
	print("[EventGroup::start] START NOT IMPLEMENTED")
	
func stop():
	print("[EventGroup::stop] STOP NOT IMPLEMENTED")
	
func trigger(subEvent):
	print("[EventGroup::trigger] TRIGGER NOT IMPLEMENTED")
	
func cancel():
	print("[EventGroup::cancel] CANCEL NOT IMPLEMENTED")
	
func interact(target):
	print("[EventGroup::interact] INTERACT NOT IMPLEMENTED")
	
func doNext():
	print("[EventGroup::doNext] INTERACT NOT IMPLEMENTED")
	
func _getCurEvent():
	print("[EventGroup::_getCurEvent] GETCUREVENT NOT IMPLEMENTED")
