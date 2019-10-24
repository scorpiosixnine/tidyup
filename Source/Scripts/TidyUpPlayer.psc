Scriptname TidyUpPlayer extends ReferenceAlias
TidyUpQuest property pQuest auto

event OnPlayerLoadGame()
  Debug.Notification("load game called" )
	(GetOwningQuest() as SKI_QuestBase).OnGameReload()
endEvent
