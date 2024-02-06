extends Node

var eventName : String
var type : String
var data
var condition : String = ""
var interactable : bool = false
var preDelay : float = 0
var postDelay : float = 0
var duration : float = 0
var triggerNext : bool = false
var hideCurrentDialog : bool = false #for dialog types, will hide dialog when done 'duration' seconds after TRIGGERED(ignore pre/post-delay)
var hidePreviousDialog : bool = false #for all types, will hide dialog when TRIGGERED
var sideEvents : Array = []
var cancelEvents : Array = []
var group
var parent
var next
var args
var cancelled : bool = false

var getTree : Callable

func do(): #TODO: add pre-delay before doing any of this. For trigger next, call 'next' after postDelay
	if preDelay > 0:
		await getTree.call().create_timer(preDelay).timeout
		
	if cancelled:
		return
		
	if (hidePreviousDialog):
		parent.hideSpeech()
	if type == "dialog":
		parent.speak(data, duration, hideCurrentDialog) #add callback function to speak, called after delay??
	elif type == "method":
		data.call()
		
	if postDelay > 0:
		await getTree.call().create_timer(postDelay).timeout

	return

#NOTE:: Add an onCancel property to events, to decide what to do when cancelled event is called. e.g. nothing, doNext, trigger other event, etc.
func cancel(): #if cancel is called before event executes(including during preDelay) then do() won't do anything
	cancelled = true
