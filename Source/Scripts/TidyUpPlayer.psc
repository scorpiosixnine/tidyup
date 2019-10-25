Scriptname TidyUpPlayer extends ReferenceAlias
TidyUpQuest property pQuest auto

Event OnInit()
  Debug.Notification("player init")
EndEvent

event OnPlayerLoadGame()
  Debug.Notification("load game called" )
	(GetOwningQuest() as SKI_QuestBase).OnGameReload()
endEvent
