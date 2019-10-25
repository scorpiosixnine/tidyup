Scriptname TidyUpPlayer extends ReferenceAlias
TidyUpQuest property pQuest auto

Event OnInit()
  pQuest = GetOwningQuest() as TidyUpQuest

  pQuest.Trace("player init")
EndEvent

event OnPlayerLoadGame()
  pQuest.Trace("load game called" )
	(GetOwningQuest() as SKI_QuestBase).OnGameReload()
endEvent
