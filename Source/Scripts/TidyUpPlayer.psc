Scriptname TidyUpPlayer extends ReferenceAlias
TidyUpQuest property pQuest auto

Event OnInit()
  pQuest = GetOwningQuest() as TidyUpQuest
  pQuest.Trace("player init")
EndEvent

event OnPlayerLoadGame()
	(GetOwningQuest() as SKI_QuestBase).OnGameReload()
  pQuest.Trace("load game called" )
  pQuest.SanityCheck()
endEvent
