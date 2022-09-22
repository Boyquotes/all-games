extends Node2D

#Você está no tutorial de Sprint Dungeon.
#Para ouvir o tutorial quando quiser, tecle T.
#Diminua o volume com a tecla Dê.
#Aumente o volume com a tecla á.
#O jogo funciona assim: Você ouvirá um som e deverá fazer uma ação correspondente para aquele som.
#Existe um temporizador que regride a cada segundo.
#Se o temporizador acabar, você será redirecionado ao menu para recomeçar o jogo.
#A cada ação correta, o temporizador ganha um segundo.
#A cada decisão errada, o temporizador perde dois segundos.
#Durante o jogo, ao ouvir esse som (som de defesa) tecle Q para defender o ataque inimigo.
#Durante o jogo, ao ouvir esse som (som de ataque) tecle Ê para atacar o inimigo.
#Durante o jogo, ao ouvir esse som (som de magia) tecle W para usa magia no inimigo.
#Durante o jogo, ao ouvir esse som (som de esquerda) tecle Seta para esquerda para virar à esquerda.
#Durante o jogo, ao ouvir esse som (som de direita) tecle Seta para direita para virar à direita.
#Durante o jogo, ao ouvir esse som (som de frente) tecle Seta para cima para andar para frente.
#Durante o jogo, tecle R para repetir o último som e não receber uma punição no tempo restante.
#Para ouvir o tutorial quando quiser, tecle T.

func SetAudio():
	if $AudioStreamPlayer.is_playing() == false:
		get_tree().paused = true
		get_parent().find_node("Audio").stop()
		
		$AudioStreamPlayer.play()
		yield($AudioStreamPlayer, "finished")
		
		get_parent().find_node("Audio").play()
		get_tree().paused = false

func _ready():
	Global.set_process_bit(self, false)
	set_process(true)

func _process(_delta):
	if Input.is_action_just_pressed("T") or Input.is_action_just_pressed("ESC"):
		SetAudio()
	
