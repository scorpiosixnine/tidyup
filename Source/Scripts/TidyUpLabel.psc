Scriptname TidyUpLabel extends ObjectReference

TidyUpQuest property pQuest auto

Event OnContainerChanged(ObjectReference newContainer, ObjectReference oldContainer)
  if oldContainer
    pQuest.LabelMovedFrom(oldContainer)
  endif
  if newContainer
    pQuest.LabelMovedTo(newContainer)
  endif
EndEvent
