Scriptname TidyUpQuest extends Quest
{Main TidyUp quest script}

Book property TidyUpLabelArmour auto
Book property TidyUpLabelClothing auto
Book property TidyUpLabelWeapons auto
TidyUpLabel property pLabels auto
Faction property pFollowerFaction auto
ReferenceAlias property rReceiver auto
FormList property pEmptyList auto
FormList property pLabelTemplates auto
bool property pEnabled auto
String[] property pNewLabelNames auto
int property pNewLabelIndex auto

event OnInit()
  Debug.Notification(pName + GetFullVersionString() + " Initialising.")
  SanityCheck()
  SetEnabled(true)
endEvent

function SanityCheck()
  pDebugMode = true

  if pDebugMode
    self.Trace("got " + GetLabelCount() + " labels")
    TidyUpLabel label = pLabels
    while label
      self.Trace("- " + label.GetDisplayName() + " (" + label.pContainer.GetDisplayName() + ")")
      label = label.pNextLabel
    endwhile

    if IsRunning()
      self.Trace("Quest is running.")
    endif

    if IsActive()
      self.Trace("Quest is active.")
    endif
  endIf

endFunction

function SetEnabled(bool enabled)
  pEnabled = enabled
  if enabled
    self.Trace("enabled")
    Reset()
  else
    self.Trace("disabled")
  endif
endFunction

function Reset()
  pNewLabelNames = new String[21]
  pNewLabelNames[0] = "VendorItemArmor"
  pNewLabelNames[1] = "VendorItemArrow"
  pNewLabelNames[2] = "VendorItemBook"
  pNewLabelNames[3] = "VendorItemClothing"
  pNewLabelNames[4] = "VendorItemClutter"
  pNewLabelNames[5] = "VendorItemFireword"
  pNewLabelNames[6] = "VendorItemFood"
  pNewLabelNames[7] = "VendorItemFoodRaw"
  pNewLabelNames[8] = "VendorItemGem"
  pNewLabelNames[9] = "VendorItemIngredient"
  pNewLabelNames[10] = "VendorItemJewelry"
  pNewLabelNames[11] = "VendorItemKey"
  pNewLabelNames[12] = "VendorItemOreIngot"
  pNewLabelNames[13] = "VendorItemPoison"
  pNewLabelNames[14] = "VendorItemPotion"
  pNewLabelNames[15] = "VendorItemRecipe"
  pNewLabelNames[16] = "VendorItemScroll"
  pNewLabelNames[17] = "VendorItemSoulGem"
  pNewLabelNames[18] = "VendorItemSpellTome"
  pNewLabelNames[19] = "VendorItemStaff"
  pNewLabelNames[20] = "VendorItemTool"
EndFunction

function TidyUpSpare(Actor speaker)
  self.Trace("tidying up spare stuff")
  SanityCheck()
endFunction

function TidyUp(Actor speaker)
  self.Trace("tidying up")
  SanityCheck()

  rReceiver.ForceRefTo(speaker)
  speaker.ShowGiftMenu(true, None, false, false)
  rReceiver.ForceRefTo(None)
endFunction

function TidyItem(ObjectReference item, Actor tidier)
  Form base = item.GetBaseObject()
  if base
    self.Debug(tidier.GetDisplayName() + " will tidy up " + base.GetName())
    ObjectReference destination = TidyUpContainerFor(base)
    if destination
      tidier.RemoveItem(item, 1, true, destination)
    endif
  else
    self.Warning("item base missing")
  endif
endFunction

function TidyForm(Form item, int count, Actor tidier)
    self.Trace(tidier.GetDisplayName() + " will tidy up " + item.GetName() + " x " + count)
    ObjectReference destination = TidyUpContainerFor(item)
    if destination
      tidier.RemoveItem(item, count, true, destination)
    endif
endFunction

ObjectReference function TidyUpContainerFor(Form item)
  String name = item.GetName()
  TidyUpLabel label = pLabels
  while label
    int n = 0
    int count = label.pKeywords.Length
    while n < count
      Keyword match = label.pKeywords[n]
      if item.HasKeyword(match)
        self.Trace("Item " + name + " matches label" + label.GetDisplayName())
        return label.pContainer
      endif
    endwhile
    label = label.pNextLabel
  endwhile
  return None
endFunction

function LabelMoved(TidyUpLabel label, ObjectReference from, ObjectReference to)
  self.Trace("label " + label.GetDisplayName() + " moved from " + from.GetDisplayName() + " to " + to.GetDisplayName())
  SanityCheck()

  Actor person = to as Actor
  if person && person.IsInFaction(pFollowerFaction)
    self.Trace("handed label back to companion - destroying")
    ForgetLabel(label)
    person.RemoveItem(label, 1, true)
    label.Delete()
  endIf
endFunction

function AddAllLabels(Actor speaker)
  SanityCheck()

  self.Trace("adding new labels: " + pNewLabelNames.Length)
  pNewLabelIndex = 0

  ObjectReference player = Game.GetPlayer()
  player.AddItem(TidyUpLabelArmour, pNewLabelNames.Length)
endFunction

function AddLabel(String labelName, Actor speaker)
  SanityCheck()

  self.Trace("adding label " + labelName)
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
    self.Trace("label not found")
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
  self.Trace("created label")
  int count = label.pKeywords.Length
  int n = 0
  while n < count
    self.Trace(label.pKeywords[n].GetString())
  endwhile
  self.Trace(label)

  if pNewLabelIndex < pNewLabelNames.Length
    String name = pNewLabelNames[pNewLabelIndex]
    label.SetName("Label: Put " + name + " here")
    pNewLabelIndex += 1
    Keyword[] keywords = new Keyword[1]
    keywords[0] = Keyword.GetKeyword(name)
    label.pKeywords = keywords
  endIf
  RememberLabel(label)
endFunction

function RememberLabel(TidyUpLabel label)
  if !label
    self.Warning("remembering null label")
  endif

  if !GotLabel(label)
    label.pNextLabel = pLabels
    pLabels = label
    SanityCheck()
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

  self.Trace("forgot label")
  SanityCheck()
endFunction
