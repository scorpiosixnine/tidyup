Scriptname TidyUpQuest extends Quest
{Main TidyUp quest script}

Book property TidyUpLabelArmour auto
Book property TidyUpLabelClothing auto
Book property TidyUpLabelWeapons auto

TidyUpLabel property pLabels auto
Keyword property pCompanionKeyword auto
Faction property pFollowerFaction auto
Actor property pTidier auto
ReferenceAlias property rReceiver auto

event OnInit()
  Debug.Notification(pName + GetFullVersionString() + " Initialising.")
  SanityCheck()
endEvent

function SanityCheck()
  pDebugMode = true

  if pDebugMode
    self.Debug("got " + GetLabelCount() + " labels")
  endIf

endFunction

function TidyUp(Actor speaker)
  self.Debug("tidying up")
  SanityCheck()

  TidyUpLabel label = pLabels
  while label
    self.Debug("Got label " + label.GetDisplayName() + " in " + label.pContainer.GetDisplayName())
    label = label.pNextLabel
  endwhile

  int count = speaker.GetNumItems()
  ; ObjectReference[] inventory = new ObjectReference[128]
  ; int n = 0
  ; while (n < count) && (n < 128)
  ;   inventory[n] = speaker.GetNthForm(n) as ObjectReference
  ;   n += 1
  ; endwhile


  rReceiver.ForceRefTo(speaker)
  pTidier = speaker
  speaker.ShowGiftMenu(true, None, false, false)
  pTidier = None
  rReceiver.ForceRefTo(None)

  ; int newCount = speaker.GetNumItems()
  ; self.Debug("speaker item count was" + count)
  ; self.Debug("new speaker item count " + count)
  ;
  ; int n = count
  ; while n < newCount
  ;   ObjectReference object = speaker.GetNthForm(n) as ObjectReference
  ;   self.Debug("added " + object.GetBaseObject().GetName())
  ;   n += 1
  ; endwhile
endFunction

function PotentiallyTidy(ObjectReference item)
  if pTidier
    self.Debug(pTidier.GetDisplayName() + " will tidy up " + item.GetDisplayName())
  endif
endFunction

function LabelMoved(TidyUpLabel label, ObjectReference from, ObjectReference to)
  self.Debug("label " + label.GetDisplayName() + " moved from " + from.GetDisplayName() + " to " + to.GetDisplayName())
  SanityCheck()

  Actor person = to as Actor
  if person && person.IsInFaction(pFollowerFaction)
    self.Debug("handed label back to companion - destroying")
    ForgetLabel(label)
    person.RemoveItem(label, 1, true)
    label.Delete()
  endIf
endFunction

function AddLabel(String labelName, Actor speaker)
  SanityCheck()

  Debug.Notification("adding label " + labelName)
  ObjectReference player = Game.GetPlayer()
  Book template

  if labelName == "Armour"
    template = TidyUpLabelArmour
  elseif labelName == "Clothing"
    template = TidyUpLabelClothing
  else
    template = TidyUpLabelWeapons
  endif

  if !template
    self.Debug("label not found")
  endif

  player.AddItem(template)
endFunction

int function GetLabelCount()
  int n = 0
  TidyUpLabel label = pLabels
  while label
    n += 1
    label = label.pNextLabel
  endwhile
  return n
endFunction

bool function GotLabel(TidyUpLabel labelToCheck)
  TidyUpLabel label = pLabels
  while label
    if label == labelToCheck
      return true
    endif
    label = label.pNextLabel
  endwhile
  return false
endFunction

function CreatedLabel(TidyUpLabel label)
  self.Debug("created label")
  self.Debug(label)
  RememberLabel(label)
endFunction

function RememberLabel(TidyUpLabel label)
  if !label
    self.Debug("remembering null label")
  endif

  if !GotLabel(label)
    label.pNextLabel = pLabels
    pLabels = label
    self.Debug("labels count is now " + GetLabelCount())
  endIf
endFunction

function ForgetLabel(TidyUpLabel labelToForget)
  if pLabels == labelToForget
    pLabels = pLabels.pNextLabel

  else
    TidyUpLabel label = pLabels
    while label
      if label.pNextLabel == labelToForget
        label.pNextLabel = label.pNextLabel
        return
      endif
    endwhile
  endIf

  self.Debug("forgot label")
  self.Debug("labels count is now " + GetLabelCount())
endFunction
