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
String _debugPage = "Debug"

String[] _kinds

event OnConfigInit()
  pQuest.TraceFunction("ConfigInit")
  ResetProperties()
endEvent

event OnConfigOpen()
  pQuest.TraceFunction("ConfigOpen")
endEvent

event OnConfigClose()
  pQuest.TraceFunction("ConfigClose")
endEvent

function ResetProperties()
  Pages = new string[2]
  Pages[0] = _generalPage
  Pages[1] = _debugPage
endFunction

int function GetVersion()
  return pQuest.pBuildNumber
endFunction

event OnVersionUpdate(int newVersion)
  pQuest.UpdatedTo(newVersion)
  ResetProperties()
endEvent

event OnPageReset(string page)
  pQuest.TraceFunction("PageReset " + page)

  _toggleMax = 100
  _toggles = new int[100]
  _toggleValues = new bool[100]
  _toggleTags = new int[100]
  _toggleIDs = new String[100]
  _toggleCount = 0

  if (page == _generalPage) || (page == "")
    SetupGeneralPage()
  elseif (page == _debugPage)
    SetupDebugPage()
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
  AddTextOption("Warning: This is an early release. Here be bugs!", "")

  AddHeaderOption("Settings")
  SetupToggle("Enabled", "Enabled", pQuest.pEnabled)

  SetCursorPosition(1)

  AddHeaderOption("Label Types")
  int n = 0
  int count = pQuest.pKeywords.Length
  while n < count
    Keyword k = pQuest.pKeywords[n]
    if k
      ObjectReference loc = pQuest.pLocations[n]
      AddTextOption(k.GetString(), loc.GetDisplayName())
      n += 1
    else
      n = count
    endif
  endWhile


endFunction

function SetupDebugPage()
  SetCursorFillMode(TOP_TO_BOTTOM)

  AddHeaderOption("Debug Options")
  SetupToggle("Debugging", "Enable Logging", pQuest.pDebugMode)

endFunction

function SetupToggle(String identifier, String name, bool initialState, int tag = 0)
  if _toggleCount < _toggleMax
    _toggles[_toggleCount] = AddToggleOption(name, initialState)
    _toggleValues[_toggleCount] = initialState
    _toggleIDs[_toggleCount] = identifier
    _toggleTags[_toggleCount] = tag
    pQuest.Trace("Set up toggle " + _toggleCount + ": " + identifier + " (" + name + ") " + initialState)
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
