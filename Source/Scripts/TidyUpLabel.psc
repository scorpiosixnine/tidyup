Scriptname TidyUpLabel extends ObjectReference

TidyUpQuest property pQuest auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
  pQuest.LabelMoved(self, akOldContainer, akNewContainer)
EndEvent
