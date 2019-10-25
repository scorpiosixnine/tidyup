Scriptname TidyUpReceiver extends ReferenceAlias

Event OnInit()
  Debug.Trace("receiver init")
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  Debug.Trace("item added")
  Actor owner = self.GetActorReference()
  (GetOwningQuest() as TidyUpQuest).TidyForm(akBaseItem, aiItemCount, owner)
EndEvent
