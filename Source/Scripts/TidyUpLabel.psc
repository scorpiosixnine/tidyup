Scriptname TidyUpLabel extends ObjectReference

TidyUpQuest property pQuest auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
  Debug.Notification("container changed")
  pQuest.LabelMoved(self, akOldContainer, akNewContainer)
EndEvent
