Scriptname TidyUpReceiver extends ReferenceAlias

TidyUpQuest property pQuest auto

Event OnInit()
  Debug.Notification("receiver init")
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  Actor owner = self.GetActorReference()
  pQuest.TidyForm(akBaseItem, aiItemCount, owner)
EndEvent
