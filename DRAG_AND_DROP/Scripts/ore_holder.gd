extends GridContainer

func _on_make_button_up():
	var info = []
	for z in [$SLOT,$SLOT2,$SLOT3,$SLOT4,$SLOT5]:
		if len(z.DATA) != 0:
			info.append(z.DATA[1])
	if len(Global.ORE_LIST) >= Global.ORE_LIST.find(info[0])+1:
		if info.count(info[0]) == 5:
			for z in [$SLOT,$SLOT2,$SLOT3,$SLOT4,$SLOT5]:
				z.DATA = []
				z.find_node("IMG").texture = null
			#send the bar to the bar area
			$SLOT.DATA = Global.BAR_INFOS[Global.ORE_LIST[Global.ORE_LIST.find(info[0])+1]]
			$SLOT.find_node("IMG").texture = load($SLOT.DATA[0])
