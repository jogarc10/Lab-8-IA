/* (batch "C:/hlocal/Lab-8-IA/gamesClassification.clp") */
(clear)

(mapclass Designer)
(mapclass Game)
(mapclass Location)
(mapclass Manufacturer)
(mapclass Store)

(deftemplate Designer
	(slot designer_location)
	(slot designer_name)
	(slot designer_category)
 )

(deftemplate Game
	(slot game_age)
	(slot game_category)
	(slot game_difficulty)
	(slot game_duration)
	(slot game_manufacturer)
	(slot game_name)
	(slot game_price)
	(slot game_style)
) 

(deftemplate Location
	(slot location_city)
	(slot location_continent)
	(slot location_country)
)

(deftemplate Manufacturer
	(slot manufacturer_city)
	(slot manufacturer_name)
)

(deftemplate Store
	(slot store_games)
	(slot store_location)
	(slot store_name)
)
 	
(deffacts ini

	; Locations facts
	
	(Location 
		(location_city "Madrid")
		(location_continent "Europe")
		(location_country "Spain")
	)
	(Location 
		(location_city "NewYork")
		(location_continent "America")
		(location_country "USA")
	)
	(Location 
		(location_city "Tokyo")
		(location_continent "Asia")
		(location_country "Japan")
	)
	
	; Manufacturers facts
	
	(Manufacturer
		(manufacturer_city "NewYork")
		(manufacturer_name "CocktailGames")
	)
	(Manufacturer 
		(manufacturer_city "NewYork")
		(manufacturer_name "RedBricksStudio")
	)
	
	; Designer facts
	
	(Designer 
		(designer_location "Madrid")
		(designer_name "Cliff Blezinsnky")
		(designer_category "Rol")
	)
	
	; Game facts
 
	(Game
		(game_age 9)
		(game_category "adventure")
		(game_difficulty "hard")
		(game_duration 60)
		(game_manufacturer "CocktailGames")
		(game_name "Go Game")
		(game_price 20.0)
		(game_style "single")
	)
	(Game
		(game_age 13)
		(game_category "family")
		(game_difficulty "easy")
		(game_duration 90)
		(game_manufacturer "RedBricksStudio")
		(game_name "Wolf")
		(game_price 40.0)
		(game_style "cooperative")
	)
)

(defrule locations
	(Location (location_city ?city)(location_continent ?continent) (location_country ?country))
	=>
	(make-instance of Location (location_city ?city)(location_continent ?continent) (location_country ?country))
)

(defrule manufacturer
	(Manufacturer (manufacturer_city ?city)(manufacturer_name ?name))
	(object (is-a Location) (OBJECT ?h1) (location_city ?city)) 
	=>
	(make-instance of Manufacturer (manufacturer_location ?h1)(manufacturer_name ?name))
)

(defrule designer
	(Designer (designer_location ?city) (designer_name ?name ) (designer_category ?category))
	(object (is-a Location) (OBJECT ?h1) (location_city ?city)) 
	=>
	(make-instance of Designer (designer_location ?h1) (designer_name ?name ) (designer_category ?category))
)

(defrule games
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	=>
	(make-instance of Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

/*Classification by age of the games */

(defrule games_less_10
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (< ?age 10))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_10_age")(:DIRECT-INSTANCES $?x))
	=>

	(slot-set "Game_less_10_age" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_less_10_14
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test(and(> ?age 10) (<= ?age 14)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_10_to_14_age")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_10_to_14_age" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_less_14_18
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test(and(> ?age 14) (<= ?age 18)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_14_to_18_age")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_14_to_18_age" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_greater_18
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (> ?age 18))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_greater_18_age")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_greater_18_age" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

/*** Classification by style ***/

(defrule games_single_player
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
	(test (eq ?style "single"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_single_player_style")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_single_player_style" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_cooperative
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?style "cooperative"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_cooperative_style")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_cooperative_style" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

/*** Classification by difficulty ***/

(defrule games_easy
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?difficulty "easy"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_easy_diff")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_easy_diff" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_normal
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?difficulty "normal"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_normal_diff")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_normal_diff" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_hard
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?difficulty "hard"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_hard_diff")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_hard_diff" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

/*** Classification by duration ***/

(defrule games_short
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))  
	(test (<= ?duration 60))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_short_duration")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_short_duration" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_medium
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (and(> ?duration 60)(<= ?duration 120)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_medium_duration")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_medium_duration" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_long
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (> ?duration 120))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_long_duration")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_long_duration" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

/*** Classification by price ***/

(defrule games_less_10
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))  
	(test (< ?price 10.0))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_10_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_less_10_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_less_20
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (and(>= ?price 10.0)(< ?price 20.0)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_20_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_less_20_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_less_30
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))  
	(test (and(>= ?price 20.0)(< ?price 30.0)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_30_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_less_30_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_less_40
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
	(test (and(>= ?price 30.0)(< ?price 40.0)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_40_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_less_40_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_less_50
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (and(>= ?price 40.0)(< ?price 50.0)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_50_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_less_50_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_more_50
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (>= ?price 60.0))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_more_50_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_more_50_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

/*** Classification by category ***/

(defrule games_adventure
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?category "adventure"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_adventure_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_adventure_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_sports
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?category "sports"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_sports_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_sports_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_puzzle
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?category "puzzle"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_puzzle_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_puzzle_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_family
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))  
	(test (eq ?category "family"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_family_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_family_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_rol
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?category "rol"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_rol_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_rol_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)

(defrule games_strategy
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?category "strategy"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_strategy_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_strategy_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h))
)




































/*(defrule games_less_10
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(test (< ?age 10))
	=>
	(make-instance of Game_less_10_age (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_less_10_14
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test(and(> ?age 10) (<= ?age 14)))
	=>
	(make-instance of Game_10_to_14_age (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_less_14_18
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test(and(> ?age 14) (<= ?age 18)))
	=>
	(make-instance of Game_14_to_18_age (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_greater_18
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (> ?age 18))
	=>
	(make-instance of Game_greater_18_age (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)


/*** Classification by style ***/

(defrule games_single_player
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (eq ?style "single"))
	=>
	(make-instance of Game_single_player_style (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_cooperative
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (eq ?style "cooperative"))
	=>
	(make-instance of Game_cooperative_style (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

/*** Classification by difficulty ***/

(defrule games_easy
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (eq ?difficulty "easy"))
	=>
	(make-instance of Game_easy_diff (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_normal
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (eq ?difficulty "normal"))
	=>
	(make-instance of Game_normal_diff (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_hard
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (eq ?difficulty "hard"))
	=>
	(make-instance of Game_hard_diff (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

/*** Classification by duration ***/

(defrule games_short
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (<= ?duration 60))
	=>
	(make-instance of Game_short_duration (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_medium
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (and(> ?duration 60)(<= ?duration 120)))
	=>
	(make-instance of Game_medium_duration (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_long
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (> ?duration 120))
	=>
	(make-instance of Game_long_duration (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

/*** Classification by price ***/

(defrule games_less_10
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (< ?price 10.0))
	=>
	(make-instance of Game_less_10_price (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_less_20
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (and(>= ?price 10.0)(< ?price 20.0)))
	=>
	(make-instance of Game_less_20_price (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_less_30
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (and(>= ?price 20.0)(< ?price 30.0)))
	=>
	(make-instance of Game_less_30_price (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_less_40
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (and(>= ?price 30.0)(< ?price 40.0)))
	=>
	(make-instance of Game_less_40_price (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_less_50
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (and(>= ?price 40.0)(< ?price 50.0)))
	=>
	(make-instance of Game_medium_duration (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_more_50
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (>= ?price 60.0))
	=>
	(make-instance of Game_more_50_price (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

/*** Classification by category ***/

(defrule games_adventure
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (eq ?category "adventure"))
	=>
	(make-instance of Game_adventure_cat (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_sports
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (eq ?category "sports"))
	=>
	(make-instance of Game_sports_cat (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_puzzle
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (eq ?category "puzzle"))
	=>
	(make-instance of Game_puzzle_cat (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_family
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (eq ?category "family"))
	=>
	(make-instance of Game_family_cat (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_rol
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (eq ?category "rol"))
	=>
	(make-instance of Game_rol_cat (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_strategy
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (eq ?category "strategy"))
	=>
	(make-instance of Game_strategy_cat (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)*/


/*********************************************/
/******** Remove duplicates instances ********/
/*********************************************/

(defrule remove_if_duplicate_name_and_age
	(object (is-a Location)
		(OBJECT ?p)
		(location_city ?city)
		(location_continent ?continent)
		(location_country ?country)
	)
	(object (is-a Location)
		(OBJECT ~?p)
		(location_city ?city)
		(location_continent ?continent)
		(location_country ?country)
	)
	=>
	(unmake-instance ?p)
)

(defrule remove_if_duplicate_manufacturer
	(object (is-a Manufacturer)
		(OBJECT ?p)
		(manufacturer_name ?name)
	)
	(object (is-a Manufacturer)
		(OBJECT ~?p)
		(manufacturer_name ?name)
	)
	=>
	(unmake-instance ?p)
)

(defrule remove_if_duplicate_designer
	(object (is-a Designer)
		(OBJECT ?p)
		(designer_name ?name)
	)
	(object (is-a Designer)
		(OBJECT ~?p)
		(designer_name ?name)
	)
	=>
	(unmake-instance ?p)
)

(reset)
(run)
(facts)
