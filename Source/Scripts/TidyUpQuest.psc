Scriptname TidyUpQuest extends Quest
{Main TidyUp quest script}

TidyUpLabel property pLabels auto
Faction property pFollowerFaction auto
ReferenceAlias property rReceiver auto
FormList property pEmptyList auto
FormList property pLabelTemplates auto
bool property pEnabled auto

ObjectReference[] property pLocations auto
Keyword[] property pKeywords auto

event OnInit()
  Debug.Notification(pName + GetFullVersionString() + " Initialising.")
  SetEnabled(true)
endEvent

function TraceFunction(String name)
  pDebugMode = true

  if pDebugMode
    Trace(name + " (" + GetLabelCount() + " labels)")
    if !IsRunning()
      Trace("Quest is not running!")
    endif
  endIf

endFunction

function SetEnabled(bool enabled)
  pEnabled = enabled
  if enabled
    Trace("enabled")
    Reset()
  else
    Trace("disabled")
  endif
endFunction

function ResetQuest()
  TraceFunction("Resetting")
  Reset()
  Start()
  TraceFunction("Reset")
EndFunction

function TidyUpSpare(Actor tidier)
  TraceFunction("TidyUpSpare")
  rReceiver.ForceRefTo(tidier)
  Actor player = Game.GetPlayer() as Actor
  int count = player.GetNumItems()
  int n = 0
  int items = 0
  while(n < count)
    Form item = player.GetNthForm(n) as Form
    if !Game.IsObjectFavorited(item)
      int numberToTidy = player.GetItemCount(item)
      if player.IsEquipped(item)
        numberToTidy -= 1
      endIf
      if numberToTidy > 0
        player.RemoveItem(item, numberToTidy, true, tidier)
      endIf
    endif
    n += 1
  endWhile
  rReceiver.Clear()
endFunction

function TidyUp(Actor tidier)
  TraceFunction("tidying up")

  rReceiver.ForceRefTo(tidier)
  tidier.ShowGiftMenu(true, None, false, false)
  rReceiver.Clear()
endFunction

function TidyForm(Form item, int count, Actor tidier)
    Trace(tidier.GetDisplayName() + " will tidy up " + item.GetName() + " x " + count)
    ObjectReference destination = TidyUpContainerFor(item)
    if destination
      tidier.RemoveItem(item, count, true, destination)
    else
      FailedToTidy(item)
    endif
endFunction

function FailedToTidy(Form base)
  Trace("Don't know where to put " + base.GetName() + ", which has keywords:")
  int n = 0
  while n < base.GetNumKeywords()
    Trace(" - " + base.GetNthKeyword(n).GetString())
    n += 1
  endWhile
endFunction

ObjectReference function TidyUpContainerFor(Form item)
  int count = pKeywords.Length
  int n = 0
  while n < count
    Keyword k = pKeywords[n]
    if item.HasKeyword(k)
      ObjectReference loc = pLocations[n]
      Trace("Item " + item.GetName() + " matches keyword " + k.GetString() + " container: " + loc)
      return loc
    endif
    n += 1
  endwhile
  return None
endFunction

function LabelMoved(TidyUpLabel label, ObjectReference from, ObjectReference to)
  TraceFunction("LabelMoved: " + label.GetName() + " moved from " + from.GetDisplayName() + " to " + to.GetDisplayName())

  Actor person = to as Actor
  if person && person.IsInFaction(pFollowerFaction)
    Trace("handed label back to companion - destroying")
    ClearTidyLocation(label)
    person.RemoveItem(label, 1, true)
  else
    SetTidyLocation(label, to)
  endIf
endFunction

function SetTidyLocation(TidyUpLabel label, ObjectReference loc)
  int n = 0
  int count = label.GetNumKeywords()
  while n < count
    SetKeywordLocation(label.GetNthKeyword(n), loc)
    n += 1
  endwhile
endFunction

function ClearTidyLocation(TidyUpLabel label)
  int n = 0
  int count = label.GetNumKeywords()
  while n < count
    ClearKeywordLocation(label.GetNthKeyword(n))
    n += 1
  endwhile
endFunction

function SetKeywordLocation(Keyword kind, ObjectReference loc)
  int n = 0
  int count = pKeywords.Length
  while n < count
    Keyword slot = pKeywords[n]
    if (slot == kind) || !slot
      pLocations[n] = loc
      return
    endif
    n += 1
  endwhile
endFunction

function ClearKeywordLocation(Keyword kind)
  int n = 0
  int count = pKeywords.Length
  while n < count
    Keyword slot = pKeywords[n]
    if (slot == kind) || !slot
      pLocations[n] = None
      return
    endif
    n += 1
  endwhile
endFunction


function AddAllLabels(Actor speaker)
  TraceFunction("AddAllLabels")
  ObjectReference player = Game.GetPlayer()

  if GetLabelCount() == 0
    ; we've got no labels, we can just give the whole list
    Trace("Giving all labels to player.")
    player.AddItem(pLabelTemplates)
  else
    ; we've got some labels already, so only give the player the ones they are missing
    ; (ie the ones that they've handed back at some point)
    Trace("Player already has some labels, giving just the missing ones.")
    int count = pLabelTemplates.GetSize()
    int n = 0
    while n < count
      Form label = pLabelTemplates.GetAt(n)
      if !TidyUpContainerFor(label)
        player.AddItem(label)
      endIf
      n += 1
    endWhile
  endIf
endFunction

int function GetLabelCount()
  int n = 0
  int count = pKeywords.Length
  while n < count
    Keyword slot = pKeywords[n]
    if !slot
      return n
    endif
    n += 1
  endwhile
  return count
endFunction
