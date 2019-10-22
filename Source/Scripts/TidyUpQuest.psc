Scriptname TidyUpQuest extends Quest
{Main TidyUp quest script}

Book property TidyUpLabelArmour auto
Book property TidyUpLabelClothing auto
Book property TidyUpLabelWeapons auto
FormList property TidyUpLabels auto

event OnInit()
  Debug.Notification(pName + GetFullVersionString() + " Initialising.")
endEvent

function TidyUp(Actor speaker)
  int count =  TidyUpLabels.GetSize()
  int n = 0
  while(n < count)
    TidyUpLabel label = TidyUpLabels.GetAt(n) as TidyUpLabel
    if label
      self.Debug("Got label " + label.GetName() + " in " + label.pContainer.GetName())
    endif
  endwhile
endFunction

function LabelMoved(ObjectReference label, ObjectReference from, ObjectReference to)
  self.Debug("label " + label.GetName() + " moved from " + from.GetName() + " to " + to.GetName())
endFunction

function AddLabel(String labelName, Actor speaker)
  pDebugMode = true
  Debug.Notification("adding label " + labelName)
  ObjectReference player = Game.GetPlayer()
  Book label

  if labelName == "Armour"
    label = TidyUpLabelArmour
  elseif labelName == "Clothing"
    label = TidyUpLabelClothing
  else
    label = TidyUpLabelWeapons
  endif

  if !label
    self.Debug("label not found")
  endif

  player.AddItem(label)
  RememberLabel(label)
endFunction

function RememberLabel(Book label)
  if !TidyUpLabels.HasForm(label)
    TidyUpLabels.AddForm(label)
  endIf
endFunction

function ForgetLabel(Book label)
  TidyUpLabels.RemoveAddedForm(label)
endFunction
