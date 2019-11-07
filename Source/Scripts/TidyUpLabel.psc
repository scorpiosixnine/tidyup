Scriptname TidyUpLabel extends ObjectReference

TidyUpQuest property pQuest auto
ObjectReference property pContainer auto
TidyUpLabel property pNextLabel auto
Keyword[] property pKeywords auto
int property pFormID auto
String property pName auto

String function GetLabelName()
  if pName != ""
    return pName
  else
    return pKeywords[0].GetString()
  endif
endFunction

function RememberID()
  pFormID = GetFormID()
  pName = GetName()
  pQuest.Trace("reset form id to " + pFormID + " for " + pName)
endfunction

Event OnInit()
  RememberID()
  pQuest.CreatedLabel(self)
EndEvent

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
  if pName == ""
    RememberID()
  endif

  pContainer = akNewContainer
  pQuest.LabelMoved(self, akOldContainer, akNewContainer)
EndEvent
