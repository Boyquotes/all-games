extends Node2D

enum ENEMIES {
	BRUTUS, # Ataques de Força Bruta: Nesse tipo de ataque, o hacker tenta adivinhar senhas ou combinações até encontrar a correta. É um método de tentativa e erro usado para quebrar a segurança de sistemas.
	PHISHING, # Ataques de Phishing: O phishing é uma técnica em que o hacker se passa por uma entidade confiável, como uma empresa ou instituição financeira, e tenta enganar os usuários para obter informações pessoais, como senhas e números de cartão de crédito.
	SQL, # Ataques de Injeção SQL: Nesse tipo de ataque, o hacker insere instruções SQL maliciosas em um formulário de entrada de dados para manipular um banco de dados, permitindo acesso não autorizado ou obtenção de informações confidenciais.
	RANSOMWARE, # Ataques de Ransomware: O ransomware é um tipo de malware que criptografa os arquivos de um sistema, tornando-os inacessíveis ao usuário legítimo. O hacker exige um resgate para disponibilizar a chave de descriptografia.
	SPOOFING, # Ataques de Spoofing: Nesse tipo de ataque, o hacker mascara sua identidade ou finge ser outra pessoa, dispositivo ou entidade para enganar os usuários e obter acesso não autorizado.
}

enum HABILITIES {
	SHIELD, # Bloco simples 1x1 que para um inimigo -> o shield aguenta 2 inimigos batendo nele / fica rachado quando o primeiro inimigo toca o shield e depois quando o segundo inimigo toca nele o shield some
	WALL, # Parede 1x3 (altura)x(largura) -> funcionamento igual a 3 shields um do lado do outro / a parede como um todo aguenta largura+1 inimigos / exemplo: se 4 inimigos baterem no mesmo bloco da parede ela quebra, se 4 inimigos baterem em lugares diferentes da parede ela quebra
	PREVENTION, # Torreta que atira para cima a cada x segundos -> é destruída se um inimigo encostar nela, mas mata o inimigo, o projétil que ela atira trepassa outros blocos colocados pelo player, então dá pra fazer uma defesa de um bloco antes dela
	WANDERING_FIREWALL, # Bloco aliado que quando posicionado SEMPRE vai até um inimigo, aguenta 6 inimigos
	ENCRYPTED_PIPE, # Mesma coisa que a parede, mas é vertical 3x1
}

enum SHOP_TYPES {
	UPGRADE_HEALTH,
	BUY_HEALTH,
	
	BUY_WALL,
	BUY_PREVENTION,
	BUY_ENCRYPTED,
	BUY_WANDERING,
	
	UPGRADE_SHIELD,
	UPGRADE_WALL,
	UPGRADE_PREVENTION,
	UPGRADE_ENCRYPTED,
	UPGRADE_WANDERING,
	
	BUY_MEGA_SHIELD,
	BUY_MEGA_WALL,
	BUY_MEGA_PREVENTION,
	BUY_MEGA_ENCRYPTED,
	BUY_MEGA_WANDERING,
	
	UPGRADE_ENERGY_PER_TICK,
	UPGRADE_MAX_ENERGY,
	
	BUY_HOURGLASS_POWER_UP,
	BUY_BOMB_POWER_UP
}
