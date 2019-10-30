Scriptname TidyUpConfig extends SKI_ConfigBase

TidyUpQuest property pQuest auto

int[] _toggles
bool[] _toggleValues
int[] _toggleTags
String[] _toggleIDs
int _toggleCount = 0
int _toggleMax = 0

int _resetButton = 0

String _generalPage = "General"

String[] _kinds

event OnConfigInit()
  Pages = new string[3]
  Pages[0] = _generalPage

  pQuest.Trace("ConfigInit")
endEvent

event OnConfigOpen()
  pQuest.Trace("ConfigOpen")

endEvent

event OnConfigClose()
  pQuest.Trace("ConfigClose")
  pQuest.SanityCheck()
endEvent

int function GetVersion()
  return pQuest.pBuildNumber
endFunction

event OnVersionUpdate(int newVersion)
  pQuest.Log("updated to version " + pQuest.GetFullVersionString())
  pQuest.SanityCheck()
  ; pQuest.Log("Resetting")
  ; pQuest.Reset()
  ; pQuest.Start()
  ; pQuest.SanityCheck()
endEvent

event OnPageReset(string page)
  {Called when a new page is selected, including the initial empty page}

  pQuest.Debug("PageReset " + page)

  _toggleMax = 100
  _toggles = new int[100]
  _toggleValues = new bool[100]
  _toggleTags = new int[100]
  _toggleIDs = new String[100]
  _toggleCount = 0

  if (page == _generalPage) || (page == "")
    SetupGeneralPage()
  endif
endEvent

event OnOptionSelect(int option)
  Debug.Notification("select " + option)
  int n = 0

  if n == _resetButton
    Debug.Notification("resetting")
  endif

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
    pQuest.SetEnabled(value)
  endif
endFunction

function SetupGeneralPage()
  SetCursorFillMode(TOP_TO_BOTTOM)

  AddHeaderOption(pQuest.pName + pQuest.GetFullVersionString())
  AddTextOption("By scorpiosixnine.", "")
  AddEmptyOption()
  AddHeaderOption("Labels")
  int n = 0
  int count = pQuest.pNewLabelNames.Length
  while n < count
    AddTextOption(pQuest.pNewLabelNames[n], "")
    n += 1
  endWhile

  SetCursorPosition(1)
  AddHeaderOption("Settings " + pQuest.GetFullVersionString())
  SetupToggle("Enabled", "Enabled", pQuest.pEnabled)
  _resetButton = AddMenuOption("", "Reset")

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
