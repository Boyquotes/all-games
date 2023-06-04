extends Node2D

onready var HEALTH_BY_ENEMY = {
	Enums.ENEMIES.BRUTUS: 1,
	Enums.ENEMIES.PHISHING: 1,
	Enums.ENEMIES.RANSOMWARE: 1,
	Enums.ENEMIES.SPOOFING: 1, 
	Enums.ENEMIES.SQL: 2,
}

onready var HABILITIES_COST = { # each upgrade in each hability increase the cost by 1
	Enums.HABILITIES.SHIELD: 1,
	Enums.HABILITIES.WALL: 2,
	Enums.HABILITIES.PREVENTION: 3,
	Enums.HABILITIES.WANDERING_FIREWALL: 4,
	Enums.HABILITIES.ENCRYPTED_PIPE: 3,
}

const WAVE_TO_UNLOCK_ENEMY = {
	3: 'phishing',
	6: 'sql',
	9: 'ransomware',
	12: 'spoofing',
}

onready var HABILITY_BY_NAME = {
	'shield': Enums.HABILITIES.SHIELD,
	'wall': Enums.HABILITIES.WALL,
	'prevention': Enums.HABILITIES.PREVENTION,
	'encrypted_pipe': Enums.HABILITIES.ENCRYPTED_PIPE,
	'wandering_firewall': Enums.HABILITIES.WANDERING_FIREWALL
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

onready var FIREWALL_POINTS_BY_ENEMY = {
	Enums.ENEMIES.BRUTUS: 1,
	Enums.ENEMIES.PHISHING: 1,
	Enums.ENEMIES.RANSOMWARE: 3,
	Enums.ENEMIES.SPOOFING: 2,
	Enums.ENEMIES.SQL: 1
}

onready var MEGA_BY_HABILITY = {
	Enums.HABILITIES.SHIELD: 'mega_shield',
	Enums.HABILITIES.WALL: 'mega_wall',
	Enums.HABILITIES.PREVENTION: 'mega_prevention',
	Enums.HABILITIES.ENCRYPTED_PIPE: 'mega_encrypted_pipe',
	Enums.HABILITIES.WANDERING_FIREWALL: 'mega_wandering_firewall',
}

onready var TEXTURE_BY_MEGA_HABILITY = {
	MEGA_BY_HABILITY[Enums.HABILITIES.SHIELD]: "res://Images/MegaHabilities/Shield.png",
	MEGA_BY_HABILITY[Enums.HABILITIES.WALL]: "res://Images/MegaHabilities/Wall.png",
	MEGA_BY_HABILITY[Enums.HABILITIES.PREVENTION]: "res://Images/MegaHabilities/Prevention.png",
	MEGA_BY_HABILITY[Enums.HABILITIES.ENCRYPTED_PIPE]: "res://Images/MegaHabilities/Pipe.png",
	MEGA_BY_HABILITY[Enums.HABILITIES.WANDERING_FIREWALL]: "res://Images/MegaHabilities/Wandering.png",
}
