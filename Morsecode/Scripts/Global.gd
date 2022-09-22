extends Node2D

var game_save_class: Script = load("res://Scripts/Game_save_class.gd")

var REMAINING_ACHIEVEMENTS = ['10STARS', '100STARS', '200STARS', 'DIALOGMODECOMPLETED', 'WRITINGMODECOMPLETED', 'TRANSLATORMODECOMPLETED']

var MUSIC = true

var music_volume = 0
var volume = -5
var STARS = 0
var FEZ_TUTORIAL = false
var language = 'eng'


var desafio_atual = 'traducao'

var CONGRAT = ''

var estagio_desafio_de_traducao = 1
var estagio_desafio_de_escrita = 1

var max_estagio_desafio_de_traducao = 1
var max_estagio_desafio_de_escrita = 1


var estagio_tutorial = 1
var max_estagio_tutorial = 1

var tutorial_text = {
	'0': 'Morse code is not difficult to learn, it is just time consuming, to learn morse code you need to read a lot in morse code and write a lot in morse code, for that we created this application that will help you to memorize it easily through challenges.',
	'1': 'Morse code is written with dots, lines and spaces to separate letters and words, to write the word "potato", you must write in morse code, "p", space, "o", space, "t", space, "a", space, "t", space, "o"',
	'2': 'To separate words from each other you must put 2 spaces between them, for example: "this potato is good", "t", space, "h", space, "i", space, "s", space, space, "p", space, "o", space, "t", space, "a", space, "t", space, "o", space, space, "i", space, "s", space, space, "g", space, "o", space, "o", space, "d", space.',
	'3': 'We know this sounds complicated, but morse code is written this way to make it easier to identify letters and words, the same phrase "potato is good", written in morse is: ".--. --- - .- - --- -- ... --. --- --- -.."',
	'4': 'In Morse Pro you will have 3 types of challenges for you to practice your morse code, Writing Challenge, Translation Challenge and Story Challenge.',
	'5': 'In Writing Challenge mode, you will be given a word or phrase and you will have to write it in morse code.\nAs this:\nYou receive the phrase: "Nice one!"\nYou answer: "-. -- -.-. -  --- -. . -.-.--"',
	'6': 'In Translation Challenge mode, you will be given a word or phrase and you will have to write it in English.\nAs this:\nYou receive the phrase: ".-- .- - . .-. -- . .-.. --- -."\nYou answer: "Watermelon"',
	'7': 'In Story Challenge you will be given a text fully encrypted in morse code to you translate, the stories get bigger, more complex and with more difficult words throughout the levels.',
	'8': 'To unlock the Story Challenge you must accumulate stars that are earned in the Writing Challenge and Translation Challenge modes.',
	'9': "Feel free to look at the dictionary whenever you want, in time you won't even need it anymore.",
	'10': 'Finish the tutorial to unlock the challenges',
}

var Characteres_sounds = {
	' ': [" "],
	'a': [".", "-"],
	'b': ["-", ".", ".", "."],
	'c': ["-", ".", "-", "."],
	'd': ["-", ".", "."],
	'e': ["."],
	'f': [".", ".", "-", "."],
	'g': ["-", "-", "."],
	'h': [".", ".", ".", "."],
	'i': [".", "."],
	'j': [".", "-", "-", "-"],
	'k': ["-", ".", "-"],
	'l': [".", "-", ".", "."],
	'm': ["-", "-"],
	'n': ["-", "."],
	'o': ["-", "-", "-"],
	'p': [".", "-", "-", "."],
	'q': ["-", "-", ".", "-"],
	'r': [".", "-", "."],
	's': [".", ".", "."],
	't': ["-"],
	'u': [".", ".", "-"],
	'v': [".", ".", ".", "-"],
	'w': [".", "-", "-"],
	'x': ["-", ".", ".", "-"],
	'y': ["-", ".", "-", "-"],
	'z': ["-", ".", ".", "."],
	'A': [".", "-"],
	'B': ["-", ".", ".", "."],
	'C': ["-", ".", "-", "."],
	'D': ["-", ".", "."],
	'E': ["."],
	'F': [".", ".", "-", "."],
	'G': ["-", "-", "."],
	'H': [".", ".", ".", "."],
	'I': [".", "."],
	'J': [".", "-", "-", "-"],
	'K': ["-", ".", "-"],
	'L': [".", "-", ".", "."],
	'M': ["-", "-"],
	'N': ["-", "."],
	'O': ["-", "-", "-"],
	'P': [".", "-", "-", "."],
	'Q': ["-", "-", ".", "-"],
	'R': [".", "-", "."],
	'S': [".", ".", "."],
	'T': ["-"],
	'U': [".", ".", "-"],
	'V': [".", ".", ".", "-"],
	'W': [".", "-", "-"],
	'X': ["-", ".", ".", "-"],
	'Y': ["-", ".", "-", "-"],
	'Z': ["-", "-", ".", "."],
		
	'á': [".", "-"],
	'é': ["."],
	'í': [".", "."],
	'ó': ["-", "-", "-"],
	'ú': [".", ".", "-"],
	'ã': [".", "-"],
	'õ': ["-", "-", "-"],
	'ñ': ["-", "."],
	'ç': ["-", ".", "-", "."],
	'â': [".", "-"],
	'ê': ["."],
	'î': [".", "."],
	'ô': ["-", "-", "-"],
	'û': [".", ".", "-"],
	'à': [".", "-"],
	'è': ["."],
	'ì': [".", "."],
	'ò': ["-", "-", "-"],
	'ù': [".", ".", "-"],
		
	'Á': [".", "-"],
	'É': ["."],
	'Í': [".", "."],
	'Ó': ["-", "-", "-"],
	'Ú': [".", ".", "-"],
	'Ã': [".", "-"],
	'Õ': ["-", "-", "-"],
	'Ñ': ["-", "."],
	'Ç': ["-", ".", "-", "."],
	'Â': [".", "-"],
	'Ê': ["."],
	'Î': [".", "."],
	'Ô': ["-", "-", "-"],
	'Û': [".", ".", "-"],
	'À': [".", "-"],
	'È': ["."],
	'Ì': [".", "."],
	'Ò': ["-", "-", "-"],
	'Ù': [".", ".", "-"],
	
	'0': ["-", "-", "-", "-", "-"],
	'1': [".", "-", "-", "-", "-"],
	'2': [".", ".", "-", "-", "-"],
	'3': [".", ".", ".", "-", "-"],
	'4': [".", ".", ".", ".", "-"],
	'5': [".", ".", ".", ".", "."],
	'6': ["-", ".", ".", ".", "."],
	'7': ["-", "-", ".", ".", "."],
	'8': ["-", "-", "-", ".", "."],
	'9': ["-", "-", "-", "-", "."],
	'.': ['.', '-', '.', '-', '.', '-'],
	',': ['-', '-', '.', '.', '-', '-'],
	'?': ['.', '.', '-', '-', '.', '.'],
	"'": ['.', '-', '-', '-', '-', '-', '.'],
	'!': ['-', '.', '-', '.', '-', '-'],
	'/': ['-', '.', '.', '-', '.'],
	'(': ['-', '.', '-', '-', '.'],
	')': ['-', '.', '-', '-', '.', '-'],
	'&': ['.', '-', '.', '.', '.'],
	':': ['-', '-', '-', '.', '.', '.'],
	';': ['-', '.', '-', '.', '-', '.'],
	'=': ['-', '.', '.', '.', '-'],
	'-': ['-', '.', '.', '.', '.', '-'],
	'_': ['.', '.', '-', '-', '.', '-'],
	'"': ['.', '-', '.', '.', '-', '.'],
	'$': ['.', '.', '.', '-', '.', '.', '-'],
	'@': ['.', '-', '-', '.', '-', '.'],
}


#NOME DO APP: MORSE PRO

#antes de todo nível tem uma cutscene

var STORY_MODE_LEVEL = 1

const STORY_MODE = {
	'1': 'Sos we request american navy rescue coordinates -6 and 65 we are not surrounded but the enemies are approaching fast and we have a damaged engine',
	'2': 'Sos our submarine was attacked we requested help from the american navy we had to stay on the surface our missiles ran out and the enemies are approaching coordinates -35 and 39',
	'3': 'Sos we have 4 wounded men our engines are broken and we are surrounded I do not think we have much time american navy rescue us at the coordinates -1 and 77',
	'4': 'Sos we asked for reinforcements to coordinates 19 and 64 our ship was carrying supplies for american troops when it was hit by a missile our engine was destroyed we need towing',
	'5': 'Here is the nuclear submarine CW 85 requesting permission and verification to move to coordinates -17 and 91 as a way to counter the enemy formation',
	'6': 'This is the DW 11 mortar ship requesting reloading of ammunition and supplies our coordinates are -20 and 96',
	'7': 'Mayday KR 78 aircraft asking for rescue at the coordinates where we will fall they are -34 and 103 we have a spare boat but we do not have supplies for more than 1 day',
	'8': 'Sos icebreaker iris 202 has been cornered by enemies, we requested the US navy to create a safe passage to return to the mainland, our supplies are running low, we are at coordinates -67 and 75',
	'9': 'Sos we request american navy rescue to mortar ship DW 11 we needed to run away from the old position because the enemies found us we are at -28 and 70',
	'10': 'Sos our ship is sinking, we need immediate help from the american navy, our coordinates are -44 and 37',
	'11': 'AVM aircraft carrier sending coordinates for attack -13 and 49 6 and 80 17 and 74 code 2683',
	'12': 'AVM aircraft carrier sending enemies coordinates for attack -14 and 113 -3 and 93 7 and 90 code 0728',
	'13': 'Sos requesting rescue to the coordinates -11 and 82 american navy help us we are surrounded',
	'14': 'special request for verification to move to coordinates -29 and 104 we are the hyperssonic missile ship of United States of America',
	'15': 'here is hypersonic missile ship and the war is over thanks to all of our allies and those who collaborate to rescue our troops and who collaborate into the communication between ours allies',
}

const TUTORIAL = {
	'1': 'a',
	'2': 'b',
	'3': 'c',
	'4': 'd',
	'5': 'e',
	'6': 'f',
	'7': 'g',
	'8': 'h',
	'9': 'i',
	'10': 'j',
	'11': 'k',
	'12': 'l',
	'13': 'm',
	'14': 'n',
	'15': 'o',
	'16': 'p',
	'17': 'q',
	'18': 'r',
	'19': 's',
	'20': 't',
	'21': 'u',
	'22': 'v',
	'23': 'w',
	'24': 'x',
	'25': 'y',
	'26': 'z',
	'27': '0',
	'28': '1',
	'29': '2',
	'30': '3',
	'31': '4',
	'32': '5',
	'33': '6',
	'34': '7',
	'35': '8',
	'36': '9',
	'37': '?',
	'38': '!',
}

const DESAFIO_DE_TRADUCAO = {
	'1': 'common military phrases',###
	'2': 'alpha',
	'3': 'bravo',
	'4': 'charlie',
	'5': 'delta',
	'6': 'roger',
	'7': 'roger death',
	'8': 'beware',
	'9': 'group up',
	'10': 'launching the missile',
	'11': 'we are in charge of this',
	'12': 'enemies in the area',
	'13': 'requesting permission',
	'14': 'requesting supplies',
	'15': 'you are in charge of this',
	'16': 'preparing for the mission',
	'17': 'preparing for the transport',
	'18': 'loading the ship',
	'19': 'loading the tank',
	'20': 'specific military phrases',###
	'21': 'balls to the wall',
	'22': 'bite the bullet',
	'23': 'boots on the ground',
	'24': 'bought the farm',
	'25': 'caught a lot of flak',
	'26': 'geronimo',
	'27': 'got your six',
	'28': 'in the trenches',
	'29': "no man's land",
	'30': 'nuclear option',
	'31': 'on the double',
	'32': 'on the front lines',
	'33': 'commom dialogues phrases',###
	'34': 'be careful',
	'35': 'are you serious?',
	'36': "do not worry",
	'37': 'everyone knows it',
	'38': 'this is easy',
	'39': 'are you ready?',
	'40': 'excellent',
	'41': 'why not?',
	'42': 'good idea',
	'43': 'he is comming',
	'44': 'how are you?',
	'45': 'could you explain me?',
	'46': 'where are you from?',
	'47': 'excuse me',
	'48': 'nice',
	'49': 'i like it',
	'50': 'that sounds great',
	'51': 'where can i find it?',
	'52': 'bro that sucks',
	'53': 'see you this weekend',
	'54': 'bro im starving',
	'55': 'it cost a fortune how do you lost it?',
	'56': 'this work is so stressful i need a vacation',
	'57': 'bro come to my house next weekend my mom will cook brownies',
	'58': 'have you got those documents?',
	'59': 'do you studied for this test?',
	'60': 'i do not know what that can means',
	'61': 'I feel like we are halfway there',
	'62': 'do you play any instument?',
	'63': 'nice now you have arguments against him',
	'64': 'phrases with numbers',###
	'65': 'it was worth spending 3 hours to find this pokemon',
	'66': 'can you change 20 dollars for me?',
	'67': 'in grades of 5 please',
	'68': 'how did she run 50 miles and not get tired?',
	'69': 'just 50 pushups a day and you will get fit',
	'70': 'i read 15 books this year',
	'71': 'what? a 30 page dissertation?',
	'72': 'for this generator works we need 4 fuel gallons',
	'73': '16 nails and 8 boards is missing anything?',
	'74': 'look at his 12 miles per hour run speed',
	'75': '3 hours of queue to go on this ride?',
	'76': '2 cake pieces please',
	'77': '4 eggs 2 flour pounds and what else?',
	'78': 'omg bitcoin is at 42 thousands',
	'79': 'i beat my 220 pounds record in bench press',
	'80': 'eat every 3 hours to lose weight',
	'81': 'he died 8 days ago',
	'82': 'brush your teeth at least 3 times a day',
	'83': '30 percent off',
	'84': 'i need to extract 5 teeth bro',
	'85': 'warnings with exclamation points',
	'86': 'watch out!',
	'87': 'beware!',
	'88': 'danger!',
	'89': 'biological risk!',
	'90': 'explosion risk!',
	'91': 'radiation risk!',
	'92': 'fragile!',
	'93': 'hot surface!',
	'94': 'flammable!',
	'95': 'high voltage!',
	'96': 'use the seat belt!',
	'97': 'careful when handling!',
	'98': 'wear gloves!',
	'99': 'wear safety clothing from this point on!',
	'100': 'Wild animals!',
}

const DESAFIO_DE_ESCRITA = {
	'1': 'Fruits',#tem q responder em .-.
	'2': 'Avocado',
	'3': 'Pinneple',
	'4': 'Banana',
	'5': 'Cacao',
	'6': 'Cherry',
	'7': 'Coconut',
	'8': 'Kiwi',
	'9': 'Orange',
	'10': 'Lemon',
	'11': 'Apple',
	'12': 'Papaya',
	'13': 'Mango',
	'14': 'Watermelon',
	'15': 'Strawberry',
	'16': 'Peach',
	'17': 'Grape',
	'18': 'Musical instruments',
	'19': 'Drums',
	'20': 'Gong',
	'21': 'Maraca',
	'22': 'Bell',
	'23': 'Clarinet',
	'24': 'Flute',
	'25': 'Saxophone',
	'26': 'Trumpet',
	'27': 'Bass',
	'28': 'Banjo',
	'29': 'Guitar',
	'30': 'Piano',
	'31': 'Random nouns',
	'32': 'People',
	'33': 'History',
	'34': 'Way',
	'35': 'Art',
	'36': 'World',
	'37': 'Information',
	'38': 'Map',
	'39': 'Family',
	'40': 'Government',
	'41': 'Health',
	'42': 'System',
	'43': 'Computer',
	'44': 'Meat',
	'45': 'Year',
	'46': 'Thanks',
	'47': 'Music',
	'48': 'Pearson',
	'49': 'Reading',
	'50': 'Method',
	'51': 'Data',
	'52': 'Difficult words',
	'53': 'Literally',
	'54': 'Ironic',
	'55': 'Irregardless',
	'56': 'Whom',
	'57': 'Colonel',
	'58': 'Nonplussed',
	'59': 'Disinterested',
	'60': 'Enormity',
	'61': 'Lieuenant',
	'62': 'Unabashed',
	'63': 'Gemstone names',
	'64': 'Amethyst',
	'65': 'Citrine',
	'66': 'Amber',
	'67': 'Aquamarine',
	'68': 'Garnet',
	'69': 'Diamond',
	'70': 'Jade',
	'71': 'Emerald',
	'72': 'Lapis lazuli',
	'73': 'Opal',
	'74': 'Pearl',
	'75': 'Sapphire',
	'76': 'Ruby',
	'77': 'Quartz',
	'78': 'Zircon',
	'79': 'Topaz',
	'80': 'Names',
	'81': 'James',
	'82': 'Joseph',
	'83': 'Sara',
	'84': 'John',
	'85': 'Mary',
	'86': 'David',
	'87': 'Richard',
	'88': 'Barbara',
	'89': 'Daniel',
	'90': 'Sandra',
	'91': 'Paul',
	'92': 'Nancy',
	'93': 'Extremely difficult words',
	'94': 'Consanguineous',
	'95': 'Psychotomimetic',
	'96': 'Xenotransplantation',
	'97': 'Embourgeoisement',
	'98': 'Polyphiloprogenitive',
	'99': 'Tergiversation',
	'100': 'Myrmecophilous',
}

func SET_BANNER():
	if MobileAds.get_is_initialized():
		var item_text : String = 'FULL_BANNER'
		MobileAds.config.banner.size = item_text
		if MobileAds.get_is_banner_loaded():
			MobileAds.load_banner()

func _ready():
	LOAD()
	AudioServer.set_bus_volume_db(1, volume)
	AudioServer.set_bus_volume_db(2, music_volume)
	SET_BANNER()

func _process(_delta):
	if STARS == 10 and '10STARS' in REMAINING_ACHIEVEMENTS:
		pass
	if STARS == 100 and '10STARS' in REMAINING_ACHIEVEMENTS:
		pass
	if STARS == 200 and '10STARS' in REMAINING_ACHIEVEMENTS:
		pass
	if max_estagio_desafio_de_traducao and '' in REMAINING_ACHIEVEMENTS:
		pass
	if max_estagio_desafio_de_escrita and '' in REMAINING_ACHIEVEMENTS:
		pass
	pass

func SAVE():
	var new_save = game_save_class.new()
	new_save.STORY_MODE_LEVEL = STORY_MODE_LEVEL
	new_save.music_volume = music_volume
	new_save.MUSIC = MUSIC
	new_save.REMAINING_ACHIEVEMENTS = REMAINING_ACHIEVEMENTS
	new_save.volume = volume
	new_save.STARS = STARS
	new_save.estagio_tutorial = estagio_tutorial
	new_save.max_estagio_tutorial = max_estagio_tutorial
	new_save.FEZ_TUTORIAL = FEZ_TUTORIAL
	new_save.language = language
	new_save.estagio_desafio_de_traducao = estagio_desafio_de_traducao
	new_save.estagio_desafio_de_escrita = estagio_desafio_de_escrita
	new_save.max_estagio_desafio_de_traducao = max_estagio_desafio_de_traducao
	new_save.max_estagio_desafio_de_escrita = max_estagio_desafio_de_escrita
	
	ResourceSaver.save("user://game_save.tres", new_save)
	

func LOAD():
	var dir = Directory.new()
	if not dir.file_exists("user://game_save.tres"):
		return false
	
	var saved_game = load("user://game_save.tres")
	
	STORY_MODE_LEVEL = saved_game.STORY_MODE_LEVEL
	music_volume = saved_game.music_volume
	MUSIC = saved_game.MUSIC
	REMAINING_ACHIEVEMENTS = saved_game.REMAINING_ACHIEVEMENTS
	volume = saved_game.volume
	STARS = saved_game.STARS
	FEZ_TUTORIAL = saved_game.FEZ_TUTORIAL
	language = saved_game.language
	estagio_desafio_de_traducao = saved_game.estagio_desafio_de_traducao
	estagio_desafio_de_escrita = saved_game.estagio_desafio_de_escrita
	max_estagio_desafio_de_traducao = saved_game.max_estagio_desafio_de_traducao
	max_estagio_desafio_de_escrita = saved_game.max_estagio_desafio_de_escrita
	max_estagio_tutorial = saved_game.max_estagio_tutorial
	estagio_tutorial = saved_game.estagio_tutorial
	
	return true
	
	
	
