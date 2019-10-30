Scriptname TidyUpReceiver extends ReferenceAlias
TidyUpQuest property pQuest auto

Event OnInit()
  pQuest = (GetOwningQuest() as TidyUpQuest)
  pQuest.Trace("receiver init")
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  pQuest.Trace("item added")
  Actor owner = self.GetActorReference()
  pQuest.TidyForm(akBaseItem, aiItemCount, owner)
EndEvent
