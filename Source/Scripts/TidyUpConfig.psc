Scriptname TidyUpConfig extends SKI_ConfigBase

TidyUpQuest property pQuest auto

int[] _toggles
bool[] _toggleValues
int[] _toggleTags
String[] _toggleIDs
int _toggleCount = 0
int _toggleMax = 0

int _topsCount = 0
String[] _topNames
bool[] _topEnabled

int _femaleCount = 0
String[] _femaleNames
bool[] _femaleEnabled

int _maleCount = 0
String[] _maleNames
bool[] _maleEnabled

int _inventoryCount = 0
String[] _inventoryNames
bool[] _inventoryEnabled
int[] _inventoryIndexes

String _generalPage = "General"

String[] _kinds

event OnConfigInit()
  Pages = new string[3]
  Pages[0] = _generalPage
endEvent

event OnConfigOpen()
  pQuest.Trace("ConfigOpen")

endEvent

event OnConfigClose()
  pQuest.Debug("ConfigClose")
endEvent

int function GetVersion()
  return pQuest.pBuildNumber
endFunction

event OnVersionUpdate(int newVersion)
  pQuest.Log("TidyUp updated to version " + pQuest.GetFullVersionString())
  pQuest.Reset()
endEvent

event OnPageReset(string page)
  {Called when a new page is selected, including the initial empty page}

  pQuest.Debug("PageReset " + page)

  if (page == _generalPage) || (page == "")
    SetupGeneralPage()
  endif
endEvent

event OnOptionSelect(int option)
  int n = 0
  while(n < _toggleCount)
    if option == _toggles[n]
      bool newValue = !_toggleValues[n]
      _toggleValues[n] = newValue
      SetToggleOptionValue(_toggles[n], newValue)
      UpdateToggle(_toggleIDs[n], newValue, _toggleTags[n])
    endif
    n += 1
  endWhile
endEvent

event OnOptionMenuOpen(int option)
	{Called when the user selects a menu option}

	SetMenuDialogStartIndex(0)
	SetMenuDialogDefaultIndex(0)
	SetMenuDialogOptions(_kinds)
endEvent

function UpdateToggle(String identifier, bool value, int tag)
  if identifier == "Debugging"
    pQuest.pDebugMode = value
  elseif identifier == "Enabled"
    pQuest.pEnabled = value
  endif
endFunction

function SetupGeneralPage()
  SetCursorFillMode(TOP_TO_BOTTOM)

  AddHeaderOption("TidyUp " + pQuest.GetFullVersionString())
  AddEmptyOption()
  AddTextOption("By scorpiosixnine.", "")

  SetCursorPosition(1)
  AddHeaderOption("Settings " + pQuest.GetFullVersionString())
  SetupToggle("Enabled", "Enabled", pQuest.pEnabled)

  AddEmptyOption()
  AddHeaderOption("Debug Options")
  SetupToggle("Debugging", "Enable Logging", pQuest.pDebugMode)
endFunction


function SetupToggle(String identifier, String name, bool initialState, int tag = 0)
  if _toggleCount < _toggleMax
    _toggles[_toggleCount] = AddToggleOption(name, initialState)
    _toggleValues[_toggleCount] = initialState
    _toggleIDs[_toggleCount] = identifier
    _toggleTags[_toggleCount] = tag
    _toggleCount += 1
  endif
endFunction

function SetupSettingsFor(String identifier, int count, String[] names, bool[] values)
  int n = 0
  while(n < count)
    SetupToggle(identifier, names[n], values[n], n)
    ; AddMenuOption("Kind", identifier)
    n += 1
  endWhile
endFunction
