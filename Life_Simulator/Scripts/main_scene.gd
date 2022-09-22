extends Node2D

#LEMBRAR DE FAZER MUITAS CONQUISTAS

#STATS - Health(para não morrer), resilience(para gerar energia), energia(para fazer ações), Intelligence(Conseguir empregos), Charisma(Conseguir empregos)

#faculdade

#trabalhos - lícitos/ilícitos/que necessitam de faculdade

const BANK_INTEREST_RATE = 0.15 #para cada 30s


var JOBS = {
	'Dishwasher': [['general work exp needed'], ['variação de salário, se n tiver coloque apenas 1 numero aqui']],
	'Cashier': [],
	'Garbage man': [],
	'Line Cook': [],
	'Waiter': [],
	'Custodian': [],
	'Assistant manager': [],
	'Cosmetologist': [],
	'Receptionist': [],
	'Chef': [],
	'Mechanic': [],
	'Truck driver': [],
	'Salesman': [],
	'Real state broker': [],
	'Manager': [],
}


var STATS = {
	'max_health': 10,
	'actual_health': 10,
	'max_stamina': 10,
	'actual_stamina': 10,
	'max_resilience': 50,
	'actual_resilience': 50,
	'Job': 0,
	'Chemistry': 0,
	'Computer science': 0,
	'Engeneering': 0,
	'Mathematics': 0,
	'Crime': 0,
}

var INVENTORY = {
	# [hunger, price, amount player have]
	'Ramen': [5, 5, 0],
	'Can of soup': [10, 12, 0],
	'Chiken': [20, 25, 0],
	'Steak': [30, 40, 0],
	'Pizza': [40, 55, 0],
	'Lobster': [50, 70, 0],
	'Science 1 Book': [1, 100, 0],
	'Science 2 Book': [2, 215, 0],
	'Science 3 Book': [3, 350, 0],
	'Self help 1 Book': [1, 100, 0],
	'Self help 2 Book': [2, 215, 0],
	'Self help 3 Book': [3, 350, 0],
	# [car price, if own == true, speed value(in percentage)]
	'Slow car': [100000, false, 0.9],
	'Below average car': [500000, false, 0.85],
	'Average car': [2500000, false, 0.75],
	'Above average car': [12500000, false, 0.65],
	'Fast car': [62500000, false, 0.55],
	'Very fast car': [312500000, false, 0.5],
}

