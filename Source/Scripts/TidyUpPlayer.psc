Scriptname TidyUpPlayer extends ReferenceAlias
TidyUpQuest property pQuest auto

Event OnInit()
  pQuest = GetOwningQuest() as TidyUpQuest
  pQuest.Trace("player init")
EndEvent

event OnPlayerLoadGame()
	(GetOwningQuest() as SKI_QuestBase).OnGameReload()
  (GetOwningQuest() as TidyUpQuest).TraceFunction("OnPlayerLoadGame")
endEvent
