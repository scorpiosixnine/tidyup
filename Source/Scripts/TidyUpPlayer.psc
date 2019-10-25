Scriptname TidyUpPlayer extends ReferenceAlias

Event OnInit()
  Debug.Trace("player init")
EndEvent

event OnPlayerLoadGame()
  Debug.Trace("load game called" )
	(GetOwningQuest() as SKI_QuestBase).OnGameReload()
endEvent
