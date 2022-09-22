extends Node2D

const POSSIBLES_BEHAVIORS = [
	'left_right_stay_short_time',
	'left_right_stay_long_time',
	'left_right_no_stay',
	
	'instant_change_stay_short_time',
	'instant_change_stay_long_time',
	'instant_change_no_stay',
	
	'long_distances_instant_changes_stay_short_time',
	'long_distances_instant_changes_stay_long_time',
	'long_distances_instant_changes_no_stay',
	'long_distances_random_changes_stay_short_time',
	'long_distances_random_changes_stay_long_time',
	'long_distances_random_changes_no_stay',
	
	'short_distances_instant_changes_stay_short_time',
	'short_distances_instant_changes_stay_long_time',
	'short_distances_instant_changes_no_stay',
	'short_distances_random_changes_stay_short_time',
	'short_distances_random_changes_stay_long_time',
	'short_distances_random_changes_no_stay',
	
	#'inverse',#when inverse, the arrow points to the direction who player needs to pull, not the direction who fish pulls
	#inverse activates when fish is level 4 or 5, 5 with more frequence
]

const FISHES = {
	#'fish_name': ['texture', 'where u can find him', 'level [1-5]', 'estação', 'min value', 'min wight'],
	#SPECIAL
	'ChadFish(peixe gigachad)': ['', '', 1, '', 1, 1],
	'Apogon(peixe de lava/pedra)': ['', '', 1, '', 1, 1],
	'Peixe-dragão(fogo)': ['', '', 1, '', 1, 1],
	'Enguia-dragão(elétrico)': ['', '', 1, '', 1, 1],
	#SPECIAL
	
	#NORMAL
	'Parrotfish': ['', 'Ocean', 1, 'Spring', 2, 'min weight'],
	'Mackerel': ['', 'Ocean', 1, 'Spring', 2.4, 1],
	'Clowfish': ['', 'Ocean', 1, 'Spring', 3.5, 1],
	'Plaice': ['', 'Ocean', 1, 'Spring', 1.5, 1],
	'Silver Eel': ['', 'Ocean', 1, 'Spring', 4, 1],
	'Sea Horse': ['', 'Ocean', 1, 'Spring', 2.3, 1],
	'Lionfish': ['', 'Ocean', 1, 'Spring', 5, 1],
	'Cowfish': ['', 'Ocean', 1, 'Spring', 1.8, 1],
	'Shrimp': ['', 'Ocean', 1, 'Spring', 1.1, 0.5],
	'Squid': ['', 'Ocean', 1, 'Spring', 2.1, 1],
	'Dumbo Octopus': ['', 'Ocean', 1, 'Spring', 4.3, 6.4],
	
	'Tuna': ['', 'Ocean', 1, 'Summer', 6.7, 7.6],
	'Banded Butterflyfish': ['', 'Ocean', 1, 'Summer', 3.9, 2.9],
	'Atlantic Bass': ['', 'Ocean', 1, 'Summer', 4.7, 3.4],
	'Blue Tang': ['', 'Ocean', 1, 'Summer', 3.2, 2.3],
	'Pollock': ['', 'Ocean', 1, 'Summer', 2.6, 1.9],
	'Ballan Wrasse': ['', 'Ocean', 1, 'Summer', 2.9, 2.1],
	'Weaver': ['', 'Ocean', 1, 'Summer', 2.2, 1.9],
	'Bream': ['', 'Ocean', 1, 'Summer', 3.1, 3.1],
	'Pufferfish': ['', 'Ocean', 1, 'Summer', 2.5, 2],
	'Crab': ['', 'Ocean', 1, 'Summer', 3, 1],
	'Lobster': ['', 'Ocean', 1, 'Summer', 8.2, 4.8],
	'Sea Angel': ['', 'Ocean', 1, 'Summer', 4.9, 2.3],
	'Turtle': ['', 'Ocean', 1, 'Summer', 6.2, 6.2],
	
	'Cod': ['', 'Ocean', 1, 'Fall', 3.4, 2.1],
	'Dab': ['', 'Ocean', 1, 'Fall', 2.6, 2],
	'Flounder': ['', 'Ocean', 1, 'Fall', 4.3, 2.3],
	'Whiting': ['', 'Ocean', 1, 'Fall', 2.6, 2.4],
	'Halibut': ['', 'Ocean', 1, 'Fall', 4.2, 3.1],
	'Herring': ['', 'Ocean', 1, 'Fall', 3.8, 2],
	'Stingray': ['', 'Ocean', 1, 'Fall', 7.2, 4],
	'Octopus': ['', 'Ocean', 1, 'Fall', 8, 3],
	'Pink Fantasia': ['', 'Ocean', 1, 'Fall', 4.9, 2.9],
	'Sea Spider': ['', 'Ocean', 1, 'Fall', 5, 3.1],
	
	'Wolfish': ['', 'Ocean', 1, 'Winter', 2.9, 2.1],
	'Bonefish': ['', 'Ocean', 1, 'Winter', 4.2, 2.3],
	'Cobia': ['', 'Ocean', 1, 'Winter', 1.9, 1.8],
	'Black Drum': ['', 'Ocean', 1, 'Winter', 1.6, 2.2],
	'Blobfish': ['', 'Ocean', 1, 'Winter', 2.4, 2.3],
	'Pompano': ['', 'Ocean', 1, 'Winter', 1.4, 2.1],
	'Jellyfish': ['', 'Ocean', 1, 'Winter', 4.9, 5.4],
	'Sea Cucumber': ['', 'Ocean', 1, 'Winter', 7.8, 9.1],
	'Christmas Tree Worm': ['', 'Ocean', 1, 'Winter', 9, 4.8],
	'Sea Pen': ['', 'Ocean', 1, 'Winter', 1.2, 0.8],
	
	'Sardine': ['', 'Ocean', 1, 'All', 1.1, 0.7],
	'Angelfish': ['', 'Ocean', 1, 'All', 1.6, 1.8],
	'Red Snapper': ['', 'Ocean', 1, 'All', 1.4, 2.4],
	'Salmon': ['', 'Ocean', 1, 'All', 10, 6.2],
	'Anglerfish': ['', 'Ocean', 1, 'All', 6.4, 2.6],
	'Sea Urchin': ['', 'Ocean', 1, 'All', 5.9, 2.4],
	'Blue Lobster': ['', 'Ocean', 1, 'All', 9.5, 4.3],
	'Saltwater Snail': ['', 'Ocean', 1, 'All', 2.2, 0.4],
	
	'Crucian Carp': ['', 'River', 1, 'Spring', 2, 1.9],
	'Bluegill': ['', 'River', 1, 'Spring', 3.4, 2],
	'Tilapia': ['', 'River', 1, 'Spring', 5.5, 3.1],
	'Smelt': ['', 'River', 1, 'Spring', 2.6, 0.9],
	'Trout': ['', 'River', 1, 'Spring', 4.2, 2.1],
	'Betta': ['', 'River', 1, 'Spring', 1.6, 0.6],
	'Rainbow Trout': ['', 'River', 1, 'Spring', 6.7, 2],
	
	'Yellow Perch': ['', 'River', 1, 'Summer', 2.4, 2],
	'Char': ['', 'River', 1, 'Summer', 2.3, 1.9],
	'Guppy': ['', 'River', 1, 'Summer', 4.2, 2.1],
	'King Salmon': ['', 'River', 1, 'Summer', 9.6, 8],
	'Neon Tetra': ['', 'River', 1, 'Summer', 7.6, 1.9],
	'Piranha': ['', 'River', 1, 'Summer', 7, 2],
	
	'Bitterling': ['', 'River', 1, 'Fall', 4.6, 2.9],
	'Black Bass': ['', 'River', 1, 'Fall', 5.6, 3.5],
	'Eel': ['', 'River', 1, 'Fall', 7.8, 2],
	
	'Chub': ['', 'River', 1, 'Winter', 2.4, 1.3],
	'Perch': ['', 'River', 1, 'Winter', 3.1, 2.1],
	'Crappie': ['', 'River', 1, 'Winter', 1.9, 1.9],
	'Catfish': ['', 'River', 1, 'Winter', 2.1, 1.8],
	'Walleye': ['', 'River', 1, 'Winter', 2.2, 1.6],
	
	'Dace': ['', 'River', 1, 'All', 2.3, 1.9],
	'Loach': ['', 'River', 1, 'All', 2.4, 2.1],
	'Largemouth Bass': ['', 'River', 1, 'All', 5.8, 5],
	
	'Goldfish': ['', 'Pond', 1, 'Spring', 3.5, 0.8],
	'Koi': ['', 'Pond', 1, 'Spring', 7.1, 3],
	'Grass Carp': ['', 'Pond', 1, 'Spring', 2.2, 2.2],
	
	'Fathead Minnow': ['', 'Pond', 1, 'Summer', 2.2, 1.9],
	'Green Sunfish': ['', 'Pond', 1, 'Summer', 2.3, 2.1],
	'Plecostomus': ['', 'Pond', 1, 'Summer', 1.6, 0.8],
	'Red Shiner': ['', 'Pond', 1, 'Summer', 3.4, 2],
	'Pumpkin Seedfish': ['', 'Pond', 1, 'Summer', 2.9, 1.9],
	
	'Goby': ['', 'Pond', 1, 'Fall', 1.7, 1.8],
	'Shubukin': ['', 'Pond', 1, 'Fall', 1.6, 1.9],
	'Fancy Goldfish': ['', 'Pond', 1, 'Fall', 3.2, 1.2],
	'High Fin Banded Shark': ['', 'Pond', 1, 'Fall', 6.8, 3.5],
	'Paradise Fish': ['', 'Pond', 1, 'Fall', 4.6, 2],
	
	'Gizzard Shad': ['', 'Pond', 1, 'Winter', 3.5, 1.8],
	
	'Rosette': ['', 'Pond', 1, 'All', 2.9, 1.3],
	'Golden Tench': ['', 'Pond', 1, 'A.ll', 3.3, 1.2],
	'Molly': ['', 'Pond', 1, 'All', 2.3, 1],
	
	'Frog': ['', 'Pond/River', 1, 'All', 1.2, 0.7],
	'Tadpole': ['', 'Pond/River', 1, 'All', 1.6, 0.6],
	'Axolotl': ['', 'Pond/River', 1, 'All', 3, 0.8],
	'Water Beetle': ['', 'Pond/River', 1, 'All', 1.2, 0.6],
	'Crayfish': ['', 'Pond/River', 1, 'All', 1.5, 1],
	'Snake': ['', 'Pond/River', 1, 'All', 2, 1.2],
	'Freshwater Snail': ['', 'Pond/River', 1, 'All', 1.3, 0.5],
}



func _ready():
	Global.set_process_bit(self, false)
	
