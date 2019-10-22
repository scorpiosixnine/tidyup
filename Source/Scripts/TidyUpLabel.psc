Scriptname TidyUpLabel extends ObjectReference

TidyUpQuest property pQuest auto
ObjectReference property pContainer auto
TidyUpLabel property pNextLabel auto
Keyword[] property pKeywords auto
FormList property pTemp auto

Event OnInit()
 pQuest.CreatedLabel(self)
EndEvent

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
  pContainer = akNewContainer
  pQuest.LabelMoved(self, akOldContainer, akNewContainer)
EndEvent
