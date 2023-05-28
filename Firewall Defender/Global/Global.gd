extends Node2D

#Informações úteis:

# Sobre o jogo:
#  |-> Cada Tick do jogo = 1 segundo
#  |-> O movimento e spawn dos inimigos seguem o tick, podem nascer mais de um inimigo a cada tick, e também vários podem se mover a cada tick
#  |-> Ticks serão parte da métrica para passar de round, exemplo: sobreviver 20 ticks e matar todos os inimigos restantes
#  |-> Matar todos os inimigos restantes sempre será uma métrica obrigatória para passar de round
#  |-> Jogo endless, inicialmente tem um diálogo, tutorial e depois o player é livre, eventualmente tem algum novo diálogo (a cada 10 round por exemplo)
#  |-> O player pode decidir pausar o jogo a qualquer momento, todos os blocos e todas as informações atuais do player devem ser guardadas em um arquivo do diretório padrão de saves da Godot (já tenho uma implementação disso) guardando todo o Global.PLAYER_INFOS nesse arquivo
#  |-> Com o passar dos rounds, INEVITAVELMENTE aparecem novos inimigos mais fortes, mais inimigos aparecem, o round dura mais ticks e o jogo deve ter mais coisa na tela
#  |-> A cada 5 waves o jogo fica mais difícil

# Sobre o player:
#  |-> Tem dinheiro: Global.PLAYER_INFOS['firewall_points']
#  |-> Tem energia: Global.PLAYER_INFOS['energy']
#  |-> Tem vida máxima: Global.PLAYER_INFOS['max_health']
#  |-> Tem vida atual: Global.PLAYER_INFOS['actual_health']
#  |-> Tem uma visualização de todos os itens acima na parte esquerda da tela

# Sobre as habilidades:
#  |-> Tem upgrades: (ainda a definir)
#  |-> Custo de energia para usar o Shield: 1
#  |-> A métrica para custo de energia se baseará no shield ||| Pergunta para verificar se uma habilidade está no preço certo -> Quantos shields valem essa habilidade ?
#  |-> Energia se carrega com números DECIMAIS, mas só pode ser usada como um número NATURAL
#  |-> Habilidades perduram entre rounds
#  |-> Inicia apenas com a habilidade do shield
#  |-> Deve ser mostrada um efeito visual bem simples quando um inimigo morre ou uma habilidade acaba/some/é destruída

# Sobre a loja:
#  |-> Faz upgrades nas habilidades: (ainda a definir)
#  |-> Compra novas habilidades: (ainda a definir)

enum HABILITIES {
	SHIELD, # Bloco simples 1x1 que para um inimigo -> o shield aguenta 2 inimigos batendo nele / fica rachado quando o primeiro inimigo toca o shield e depois quando o segundo inimigo toca nele o shield some
	WALL, # Parede 1x3 (altura)x(largura) -> funcionamento igual a 3 shields um do lado do outro / a parede como um todo aguenta largura+1 inimigos / exemplo: se 4 inimigos baterem no mesmo bloco da parede ela quebra, se 4 inimigos baterem em lugares diferentes da parede ela quebra
	PREVENTION, # Torreta que atira para cima a cada x segundos -> é destruída se um inimigo encostar nela, mas mata o inimigo, o projétil que ela atira trepassa outros blocos colocados pelo player, então dá pra fazer uma defesa de um bloco antes dela
	WANDERING_FIREWALL, # Bloco aliado que quando posicionado SEMPRE vai até um inimigo, aguenta 6 inimigos
	ENCRYPTED_PIPE, # Mesma coisa que a parede, mas é vertical 3x1
}

# Sobre os inimigos
#  |-> Cada inimigo tem relação direta com um tipo de ataque hacker que existe e deve corresponder a lógica desse ataque
#  |-> O visual e o que cada inimigo faz ainda está a definir, exceto os que já estão definidos em [Explicação dos inimigos]

enum ENEMIES {
	BRUTUS, # Ataques de Força Bruta: Nesse tipo de ataque, o hacker tenta adivinhar senhas ou combinações até encontrar a correta. É um método de tentativa e erro usado para quebrar a segurança de sistemas.
	PHISHING, # Ataques de Phishing: O phishing é uma técnica em que o hacker se passa por uma entidade confiável, como uma empresa ou instituição financeira, e tenta enganar os usuários para obter informações pessoais, como senhas e números de cartão de crédito.
	SQL, # Ataques de Injeção SQL: Nesse tipo de ataque, o hacker insere instruções SQL maliciosas em um formulário de entrada de dados para manipular um banco de dados, permitindo acesso não autorizado ou obtenção de informações confidenciais.
	RANSOMWARE, # Ataques de Ransomware: O ransomware é um tipo de malware que criptografa os arquivos de um sistema, tornando-os inacessíveis ao usuário legítimo. O hacker exige um resgate para disponibilizar a chave de descriptografia.
	SPOOFING, # Ataques de Spoofing: Nesse tipo de ataque, o hacker mascara sua identidade ou finge ser outra pessoa, dispositivo ou entidade para enganar os usuários e obter acesso não autorizado.
}

# Explicação dos inimigos
#  |-> Algumas funcionalidades de inimigos já estão definidas mas ainda não atribuídas
#
#  |-> BRUTUS: (Ícone a definir) vermelho que a cada Tick anda 1 bloco para baixo
#  |-> SQL: Igual ao BRUTUS, mas tanka 2 defesas, (ícone a definir) rosa chamativo
#  |-> SPOOFING: Shield invertido vermelho que a cada Tick anda 1 bloco para baixo, ou um bloco em uma diagonal aleatória, ou um bloco para a esquerda ou para a direita
#  |-> PHISHING: Anzol branco/prata que a cada Tick anda um bloco em uma diagonal aleatória
#  |-> RANSOMWARE: Ícone de cadeado prata e dourado que a cada Tick anda um bloco para baixo ou um bloco para a esquerda ou para a direita

# Used power-ups
var bombed = false

var PLAYER_INFOS = {
	'actual_health': 5, # Vida atual
	'max_health': 5, # Vida máxima
	
	'energy_per_tick': 0.5, # Energia por tick
	'max_energy': 5, # Energia máxima
	'energy': 0, # Dinheiro para posicionar habilidades
	'firewall_points': 0, # Dinheiro da loja
	
	'habilities': ['shield'], # Lista das habilidades que o Player tem |-> Sempre tem o Shield
	'mega_habilities': [], # Lista das mega-habilidades |-> Composição de uma ou mais habilidades para fazer uma mega defesa contra os inimigos
	'positioned_habilities': [], # Lista dos nodes de habilidade que o player colocou
	
	'last_wave': 0, # Última wave que o player estava
	'unlocked_enemies': ['brutus'], # Lista dos inimigos liberados para aparecer nas waves |-> brutus sempre liberado
	
	'prevention_shoot_ticks_delay': 23,
	'wandering_health': 6,
}

var UPGRADES = { # ['innitial value', 'increment value', 'actual_level'], |-> Max level is 5 => means 5 upgrades
	HABILITIES.SHIELD:             [15,  5, 1],
	HABILITIES.WALL:               [20, 10, 0],
	HABILITIES.PREVENTION:         [30, 15, 0],
	HABILITIES.ENCRYPTED_PIPE:     [40, 20, 0],
	HABILITIES.WANDERING_FIREWALL: [50, 25, 0],
	
	'max_health':                  [20, 5, 0],
	'max_energy':                  [30, 10, 0],
	'energy_per_tick':             [40, 15, 0],
}

var BUY_VALUES = {
	'actual_health': 5,
	
	'wall': 15,
	'prevention': 20,
	'encrypted_pipe': 30,
	'wandering_firewall': 40,
	
	'mega_shield': 40,
	'mega_wall': 65,
	'mega_prevention': 80,
	'mega_encrypted_pipe': 90,
	'mega_wandering_firewall': 100,
	
	'bomb_power_up': 75,
	'hourglass_power_up': 50,
}

var CONFIGURATIONS = {
	'music_volume': 5,
	'effects_volume': 5,
}

var HABILITIES_COST = { # each upgrade in each hability increase the cost by 1
	HABILITIES.SHIELD: 1,
	HABILITIES.WALL: 2,
	HABILITIES.PREVENTION: 3,
	HABILITIES.WANDERING_FIREWALL: 4,
	HABILITIES.ENCRYPTED_PIPE: 3,
}

const WAVE_TO_UNLOCK_ENEMY = {
	3: 'phishing',
	6: 'sql',
	9: 'ransomware',
	12: 'spoofing',
}

const X_MIN_LIMIT = 256
const X_MAX_LIMIT = 1024

func spawn(type, pos, to_node):
	var node
	match type:
		'shield':
			node = preload("res://Player/Habilities/Shield.tscn").instance()
		'wall':
			node = preload("res://Player/Habilities/Wall.tscn").instance()
		'prevention':
			node = load("res://Player/Habilities/Prevention.tscn").instance()
		'wandering_firewall':
			node = load("res://Player/Habilities/Wandering.tscn").instance()
		'encrypted_pipe':
			node = preload("res://Player/Habilities/Encrypted.tscn").instance()
		
		'enemy_dying_effect':
			node = load("res://VisualEffects/EnemyDying/EnemyDyingEffect.tscn").instance()
		'ray':
			node = load("res://VisualEffects/Ray.tscn").instance()
		'earn_firewall_points':
			node = load("res://VisualEffects/EarnFirewallPoints/EarnFirewallPoints.tscn").instance()
		'cloud':
			node = load("res://VisualEffects/Cloud/Cloud.tscn").instance()
		
		'brutus':
			node = load("res://Enemies/Brutus.tscn").instance()
		'sql':
			node = load("res://Enemies/Sql.tscn").instance()
		'phishing':
			node = load("res://Enemies/Phishing.tscn").instance()
		'ransomware':
			node = load("res://Enemies/Ransomware.tscn").instance()
		'spoofing':
			node = load("res://Enemies/Spoofing.tscn").instance()
		
		'tutorial':
			node = load("res://Tutorials/Tutorial.tscn").instance()
	node.global_position = pos
	to_node.call_deferred("add_child", node)
	
	return node

var TUTORIAL = {
#   'nome_do_tutorial': ['texto que será exibido na label', 'imagem do tutorial', ja foi exibido? -> bool],
	'firewall': ['Esse é o meu Firewall, o Malware está tantando nos invadir e é esse Firewall que devo defender, os invasores virão de cima e devo proteger essa barra azul que é o meu Firewall, ele mostra quanto ele ainda resiste a invasões preenchendo as barras azuis', "res://Images/Tutorial/Firewall.png", false],
	
	'shield': ['Agora vamos nos defender desses invasores, para isso tenho meu Escudo, preciso ter energia o suficiente e arrastá-lo com meu mouse na frente dos invasores para impedir que eles cheguem no Firewall', "res://Images/Tutorial/Shield.png", false],
	'wall': ['Desbloqueei minha Parede de Segurança, para usar devo arrastar e posicionar com meu mouse na frente de um invasor para pará-lo, essa Parede de segurança cobre uma linha maior, mas ela só consegue parar 4 invasores', "res://Images/Tutorial/Wall.png", false],
	'prevention': ['Desbloqueei minha Torreta preventiva, para usar devo arrastar e posicionar com meu mouse na frente de um invasor, de preferência bem longe porque ela demora um pouco para atirar, ela consegue eliminar 1 invasor qualquer que esteja na mesma coluna que a torreta, e ela dá preferência para o mais próximo ao Firewall', "res://Images/Tutorial/Prevention.png", false],
	'wandering_firewall': ['Desbloqueei meu Firewall ajudante, para usar devo arrastar e posicionar com meu mouse perto de um invasor, esse carinha segue um invasor e o elimina, ele consegue impedir até 6 invasores quando posicionado', "res://Images/Tutorial/Wandering.png", false],
	'encrypted_pipe': ['Desbloqueei meu Caminho encriptado, para usar devo arrastar e posicionar com meu mouse na frente de um invasor, de preferência quando eles se acumulam na mesma coluna ou são invasores mais resistentes, esse Caminho encriptado também é bom para impedir invasores que se movimentam lateralmente', "res://Images/Tutorial/Encrypted.png", false],
	
	'up_shield': ['Legal! Agora meu Escudo consegue segurar mais de 2 invasores!', "res://Images/Tutorial/Shield.png", false],
	'up_wall': ['Boa! Agora minha Parede de Segurança cobre uma linha maior!', "res://Images/Tutorial/Wall.png", false],
	'up_prevention': ['Isso! Agora minha Torreta preventiva demora menos para atirar nos invasores!', "res://Images/Tutorial/Prevention.png", false],
	'up_wandering_firewall': ['Legal! Agora meu Firewall ajudante consegue perseguir mais de 6 invasores antes que sua duração acabe!', "res://Images/Tutorial/Wandering.png", false],
	'up_encrypted_pipe': ['Boa! Agora meu Caminho encriptado é maior e consegue parar mais inimigos em uma coluna!', "res://Images/Tutorial/Encrypted.png", false],
	
	'brutus': ['Ah! Nosso primeiro invasor, o Ataque Bruto, para impedir esse invasor é só posicionar qualquer defesa na sua frente que ele será parado\n\nAtaque Bruto: esse é um tipo de ataque Hacker que o hacker tenta adivinhar senhas ou combinações até encontrar a correta, esse é um método de tentativa e erro usado para quebrar a segurança de sistemas.', "res://Images/Tutorial/Brutus.png", false],
	'phishing': ['Não! Esse é o Phishing, ele se movimenta diagonalmente, sempre para onde o anzol está apontando, para impedir esse invasor é só fazê-lo encostar em qualquer defesa\n\nPhishing: ele é uma técnica em que o hacker se passa por uma entidade confiável, como uma empresa ou instituição financeira, e tenta enganar os usuários para obter informações pessoais, como senhas e números de cartão de crédito.', "res://Images/Tutorial/Phishing.png", false],
	'sql': ['Droga! Essa é a Injeção SQL, esse invasor consegue trepassar a minha defesa uma vez, para impedir esse invasor é só posicionar duas defesas qualquer na sua frente para que ele seja parado\n\nInjeção SQL: nesse tipo de ataque, o hacker insere instruções SQL maliciosas em um formulário de entrada de dados para manipular um banco de dados, permitindo acesso não autorizado ou obtenção de informações confidenciais.', "res://Images/Tutorial/SQL.png", false],
	'ransomware': ['Ah! Esse é o Ransomware, esse invasor pode se movimentar para baixo, para a direita e para a esquerda, seria bom um Caminho encriptado para impedí-lo, para impedir esse invasor é só fazê-lo encostar em qualquer defesa\n\nRansomware: ele é um tipo de malware que criptografa os arquivos de um sistema, tornando-os inacessíveis ao usuário legítimo. O hacker exige um resgate para disponibilizar a chave de descriptografia.', "res://Images/Tutorial/Ransomware.png", false],
	'spoofing': ['Não! Esse é o Spoofing, ele pode se movimentar para baixo, para a direita, para a esquerda, na diagonal direita e na diagonal esquerda, vou precisar de uma defesa bem elaborada para impedir esse invasor, para impedir esse invasor é só fazê-lo encostar em qualquer defesa\n\nSpoofing: nesse tipo de ataque, o hacker mascara sua identidade ou finge ser outra pessoa, dispositivo ou entidade para enganar os usuários e obter acesso não autorizado.', "res://Images/Tutorial/Spoofing.png", false],
	
	'mega_shield': ['Boa, agora cada Shield que coloco do lado de outro Shield se transforma num Shield Criptografado, que impede 1 invasor a mais', "res://Images/Tutorial/MegaShield.png", false],
	'mega_wall': ['Isso, agora posso colocar minhas Paredes de Segurança perto de outra Parede de Segurança para que elas se tornem Paredes de Segurança máxima e que impedem 3 invasores a mais', "res://Images/Tutorial/MegaWall.png", false],
	'mega_prevention': ['Legal, agora posso colocar uma Torreta Preventiva perto de outra para que elas se tornem uma Mega Torreta Preventiva, que atira em metade do tempo que a torreta anterior', "res://Images/Tutorial/MegaPrevention.png", false],
	'mega_encrypted_pipe': ['Boa, agora posso posicionar meu Caminho Encriptado perto de outro Caminho encriptado para que ele se torne um Caminho Hash e cada parte do caminho impeça 2 invasores, ao invés de 1', "res://Images/Tutorial/MegaEncrypted.png", false],
	'mega_wandering_firewall': ['Isso, agora meu Firewall Ajudante se tornou o Firewall Ágil, que é 2 vezes mais rápido que antes', "res://Images/Tutorial/MegaWandering.png", false],
	
	'como_jogar': ['Para me defender dos invasores preciso clicar com meu mouse em cima da defesa que vou usar, depois arrastá-la com meu mouse na frente de um inimigo para que ele seja interceptado pela minha defesa', "res://Images/Tutorial/Como_jogar.png", false],
}

var MONEY_BUFFER = 0

func show_tutorial(which):
	if TUTORIAL[which][2] == false:
		var tutorial = spawn('tutorial', Vector2(0, 0), get_tree().get_nodes_in_group("GAME")[0])
		
		tutorial.tutorial_name = which
		
		TUTORIAL[which][2] = true
		
		return tutorial

func show_forced_tutorial(which):
	TUTORIAL[which][2] = false
	var tutorial = show_tutorial(which)
	
	tutorial.forced = true

onready var RANDOM = RandomNumberGenerator.new()

var sounds = AudioStreamPlayer.new()
var musics = AudioStreamPlayer.new()

func play_sound(sound):
	match sound:
		'game_1':
			musics.stop()
			musics.set_stream(load("res://MP3/MainGameMusicLoop1.mp3"))
			musics.play()
		'game_2':
			musics.stop()
			musics.set_stream(load("res://MP3/MainGameMusicLoop2.mp3"))
			musics.play()
		'main_menu_music':
			musics.stop()
			musics.set_stream(load("res://MP3/MainMenuMusicLoop.mp3"))
			musics.play()
		'button_pressed':
			sounds.stop()
			sounds.set_stream(load("res://SoundEffects/ButtonEffect.wav"))
			sounds.play()
		'laugh':
			sounds.stop()
			sounds.set_stream(load("res://SoundEffects/EvilLaugh.wav"))
			sounds.play()
			yield(sounds, "finished")
			sounds.stop()

func _ready():
	RANDOM.randomize()
	sounds.set_bus('Effects')
	musics.set_bus('Musics')
	
	sounds.set_pause_mode(2)
	musics.set_pause_mode(2)
	
	get_tree().get_root().call_deferred('add_child', sounds)
	get_tree().get_root().call_deferred('add_child', musics)

func _on_tick():
	PLAYER_INFOS['energy'] += PLAYER_INFOS['energy_per_tick']
	
	if PLAYER_INFOS['energy'] > PLAYER_INFOS['max_energy']:
		PLAYER_INFOS['energy'] = PLAYER_INFOS['max_energy']

func hit_firewall(damage):
	var FIREWALL_HEALTH = get_tree().get_nodes_in_group("FIREWALL_HEALTH")[0]
	
	PLAYER_INFOS['actual_health'] -= abs(damage)
	
	FIREWALL_HEALTH.max_value = PLAYER_INFOS['max_health']
	FIREWALL_HEALTH.value = PLAYER_INFOS['actual_health']
	
	if PLAYER_INFOS['actual_health'] == 0:
		pass # die

func can_buy(cost):
	return PLAYER_INFOS['energy'] - abs(cost) >= 0

func buy(what, cost):
	if can_buy(cost):
		PLAYER_INFOS['energy'] -= abs(cost)
		
		var node = spawn(what, get_global_mouse_position(), get_tree().get_nodes_in_group('GAME')[0])
		
		node.get_child(0).on_button_down()

func earn(what, type):
	var amount = return_earned_firewall_points_by_enemy(type)
	match what:
		'firewall_points':
			PLAYER_INFOS['firewall_points'] += amount

func return_earned_firewall_points_by_enemy(type):
	return FIREWALL_POINTS_BY_ENEMY[type] + MONEY_BUFFER

# Mega mecânica para implementar: Compor as habilidades de uma forma específica para gerar uma nova estrutura, exemplo, envolver uma parede com shields cria o megaShield que quando um inimigo toca nele dá o dobro de firewall_points
#  |-> Debloquear as blueprints das mega Habilidades comprando no SHOP
#  |-> Um megabloco de 9x9 de paredes cria a megaParede que aguenta 15 inimigos

var HABILITY_BY_NAME = {
	'shield': HABILITIES.SHIELD,
	'wall': HABILITIES.WALL,
	'prevention': HABILITIES.PREVENTION,
	'encrypted_pipe': HABILITIES.ENCRYPTED_PIPE,
	'wandering_firewall': HABILITIES.WANDERING_FIREWALL
}

var NAME_BY_HABILITY = {
	0: 'shield',
	1: 'wall',
	2: 'prevention',
	3: 'wandering_firewall',
	4: 'encrypted_pipe'
}

var NAME_BY_ENEMY = {
	0: 'brutus',
	1: 'phishing',
	2: 'sql',
	3: 'ransomware',
	4: 'spoofing',
}

var FIREWALL_POINTS_BY_ENEMY = {
	ENEMIES.BRUTUS: 1,
	ENEMIES.PHISHING: 1,
	ENEMIES.RANSOMWARE: 3,
	ENEMIES.SPOOFING: 2,
	ENEMIES.SQL: 1
}

var MEGA_BY_HABILITY = {
	HABILITIES.SHIELD: 'mega_shield',
	HABILITIES.WALL: 'mega_wall',
	HABILITIES.PREVENTION: 'mega_prevention',
	HABILITIES.ENCRYPTED_PIPE: 'mega_encrypted_pipe',
	HABILITIES.WANDERING_FIREWALL: 'mega_wandering_firewall',
}

var TEXTURE_BY_MEGA_HABILITY = {
	MEGA_BY_HABILITY[HABILITIES.SHIELD]: "res://Images/MegaHabilities/Shield.png",
	MEGA_BY_HABILITY[HABILITIES.WALL]: "res://Images/MegaHabilities/Wall.png",
	MEGA_BY_HABILITY[HABILITIES.PREVENTION]: "res://Images/MegaHabilities/Prevention.png",
	MEGA_BY_HABILITY[HABILITIES.ENCRYPTED_PIPE]: "res://Images/MegaHabilities/Pipe.png",
	MEGA_BY_HABILITY[HABILITIES.WANDERING_FIREWALL]: "res://Images/MegaHabilities/Wandering.png",
}
