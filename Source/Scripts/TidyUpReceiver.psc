Scriptname TidyUpReceiver extends ReferenceAlias

TidyUpQuest property pQuest auto

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  Actor owner = self.GetActorReference()
  pQuest.TidyForm(akBaseItem, aiItemCount)
EndEvent
