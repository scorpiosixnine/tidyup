Scriptname TidyUpLabel extends ObjectReference

TidyUpQuest property pQuest auto
ObjectReference property pContainer auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
  pContainer = akNewContainer
  pQuest.LabelMoved(self, akOldContainer, akNewContainer)
EndEvent
