Scriptname TidyUpQuest extends Quest
{Main TidyUp quest script}

TidyUpLabel property pLabels auto
Faction property pFollowerFaction auto
ReferenceAlias property rReceiver auto
FormList property pEmptyList auto
FormList property pLabelTemplates auto
bool property pEnabled auto

event OnInit()
  Debug.Notification(pName + GetFullVersionString() + " Initialising.")
  SetEnabled(true)
endEvent

function TraceFunction(String name)
  pDebugMode = true

  if pDebugMode
    Trace(name)
    Trace("Got " + GetLabelCount() + " labels.")

    if IsRunning()
      Trace("Quest is running.")
    endif

    if IsActive()
      Trace("Quest is active.")
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

function TidyUpSpare(Actor speaker)
  TraceFunction("tidying up spare stuff")
endFunction

function TidyUp(Actor speaker)
  TraceFunction("tidying up")

  rReceiver.ForceRefTo(speaker)
  speaker.ShowGiftMenu(true, None, false, false)
  rReceiver.Clear()
endFunction

function TidyItem(ObjectReference item, Actor tidier)
  Form base = item.GetBaseObject()
  if base
    self.Debug(tidier.GetDisplayName() + " will tidy up " + base.GetName())
    ObjectReference destination = TidyUpContainerFor(base)
    if destination
      tidier.RemoveItem(item, 1, true, destination)
    else
      Warning("Don't know where to put " + base.GetName())
      int n = 0
      while n < base.GetNumKeywords()
        Trace(base.GetNthKeyword(n).GetString())
        n += 1
      endWhile
    endif
  else
    Warning("item base missing")
  endif
endFunction

function TidyForm(Form item, int count, Actor tidier)
    Trace(tidier.GetDisplayName() + " will tidy up " + item.GetName() + " x " + count)
    ObjectReference destination = TidyUpContainerFor(item)
    if destination
      tidier.RemoveItem(item, count, true, destination)
    endif
endFunction

ObjectReference function TidyUpContainerFor(Form item)
  String name = item.GetName()
  TidyUpLabel label = pLabels
  while label
    if !(label.pContainer as Actor)
      int n = 0
      int count = label.pKeywords.Length
      while n < count
        Keyword match = label.pKeywords[n]
        if item.HasKeyword(match)
          Trace("Item " + name + " matches label" + label.GetLabelName())
          return label.pContainer
        endif
        n += 1
      endwhile
    endif
    label = label.pNextLabel
  endwhile
  return None
endFunction

function LabelMoved(TidyUpLabel label, ObjectReference from, ObjectReference to)
  TraceFunction("LabelMoved")
  Trace("label " + label.GetDisplayName() + " moved from " + from.GetDisplayName() + " to " + to.GetDisplayName())

  Actor person = to as Actor
  if person && person.IsInFaction(pFollowerFaction)
    Trace("handed label back to companion - destroying")
    ForgetLabel(label)
    person.RemoveItem(label, 1, true)
    label.Delete()
  endIf
endFunction

function AddAllLabels(Actor speaker)
  TraceFunction("AddAllLabels")
  ObjectReference player = Game.GetPlayer()
  player.AddItem(pLabelTemplates)
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
  TraceFunction("created label")
  RememberLabel(label)
endFunction

function RememberLabel(TidyUpLabel label)
  TraceFunction("RememberLabel")
  if !label
    Warning("remembering null label")
  endif

  if !GotLabel(label)
    label.pNextLabel = pLabels
    pLabels = label
  endIf
endFunction

function ForgetLabel(TidyUpLabel labelToForget)
  TraceFunction("ForgetLabel")
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

  Trace("forgot label " + labelToForget.GetDisplayName())
endFunction
