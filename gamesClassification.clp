/* (batch "C:/hlocal/Lab-8-IA/gamesClassification.clp") */
(clear)

(mapclass Designer)
(mapclass Game)
(mapclass Location)
(mapclass Manufacturer)
(mapclass Store)
(mapclass User)

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
	(multislot store_games)
	(multislot store_location)
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

	; Store facts
	(Store
		(store_games "Wolf" "Go Game")
		(store_location "Madrid" "NewYork")
		(store_name "Game")
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
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer))

	=>
	(make-instance of Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule crear_store1
	(Store (store_name ?name))
	=>
	(make-instance of Store (store_name ?name))
)

(defrule crear_store2
     (Store (store_name ?name) (store_games $? ?n $?) (store_location $? ?l $?))
     (object (is-a Game) (game_name ?n) (OBJECT ?c))
     (object (is-a Location) (location_city ?l) (OBJECT ?c2))
     (object (is-a Store) (store_name ?name) (store_games $?cs) (store_location $?cs2) (OBJECT ?p))

     (test (not (member$ ?c2 ?cs2)))
     (test (not (member$ ?c ?cs)))
     =>
     (slot-insert$ ?p store_location 1 ?c2)
     (slot-insert$ ?p store_games 1 ?c)
)

(defrule recommend_games
	(object (is-a User) (user_name ?name) (user_age ?age) (user_budget ?price) (user_category_wanted ?category) (user_difficulty_wanted ?difficulty)
	(user_time_to_play ?duration) (user_style_wanted ?style) (user_recommendations $?rec) (OBJECT ?p))
	(object (is-a Game) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_price ?price) 
	(game_style ?style) (OBJECT ?c))

	(test (not (member$ ?c ?rec)))
	=>
	(slot-insert$ ?p user_recommendations 1 ?c)
)



(mapclass :THING)


/*Classification by age of the games */

(defrule games_less_10
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))
	(test(<= ?age 10))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_10_age")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_less_10_age" :DIRECT-INSTANCES
 		(insert$ ?x (+ 1 (length$ ?x)) ?h1)) 
)

(defrule games_less_10_14
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))
	(test(and(> ?age 10) (<= ?age 14)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_10_to_14_age")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_10_to_14_age" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_less_14_18
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))
	(test(and(> ?age 14) (<= ?age 18)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_14_to_18_age")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_14_to_18_age" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_greater_18
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (> ?age 18))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_greater_18_age")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_greater_18_age" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

/*** Classification by style ***/

(defrule games_single_player
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))
	(test (eq ?style "single"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_single_player_style")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_single_player_style" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_cooperative
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?style "cooperative"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_cooperative_style")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_cooperative_style" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

/*** Classification by difficulty ***/

(defrule games_easy
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))
	(test (eq ?difficulty "easy"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_easy_diff")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_easy_diff" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_normal
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?difficulty "normal"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_normal_diff")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_normal_diff" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_hard
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?difficulty "hard"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_hard_diff")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_hard_diff" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

/*** Classification by duration ***/

(defrule games_short
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))
	(test (<= ?duration 60))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_short_duration")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_short_duration" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_medium
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (and(> ?duration 60)(<= ?duration 120)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_medium_duration")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_medium_duration" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_long
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))
	(test (> ?duration 120))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_long_duration")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_long_duration" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

/*** Classification by price ***/

(defrule games_less_10
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (< ?price 10.0))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_10_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_less_10_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_less_20
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (and(>= ?price 10.0)(< ?price 20.0)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_20_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_less_20_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_less_30
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))  
	(test (and(>= ?price 20.0)(< ?price 30.0)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_30_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_less_30_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_less_40
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))
	(test (and(>= ?price 30.0)(< ?price 40.0)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_40_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_less_40_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_less_50
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (and(>= ?price 40.0)(< ?price 50.0)))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_less_50_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_less_50_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_more_50
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))
	(test (>= ?price 60.0))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_more_50_price")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_more_50_price" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

/*** Classification by category ***/

(defrule games_adventure
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))
	(test (eq ?category "adventure"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_adventure_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_adventure_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_sports
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?category "sports"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_sports_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_sports_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_puzzle
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?category "puzzle"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_puzzle_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_puzzle_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_family
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))  
	(test (eq ?category "family"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_family_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_family_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_rol
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style)) 
	(test (eq ?category "rol"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_rol_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_rol_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)

(defrule games_strategy
	(object (is-a Game) (OBJECT ?h1) (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manuf) (game_name ?name) (game_price ?price) (game_style ?style))
	(test (eq ?category "strategy"))

	(object(is-a :STANDARD-CLASS)(:NAME "Game_strategy_cat")(:DIRECT-INSTANCES $?x))
	=>
	(slot-set "Game_strategy_cat" :DIRECT-INSTANCES
		(insert$ ?x (+ 1 (length$ ?x)) ?h1))
)


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

(defrule remove_if_duplicate_game
	(object (is-a Game)
		(OBJECT ?p)
		(game_name ?name)
	)
	(object (is-a Game)
		(OBJECT ~?p)
		(game_name ?name)
	)
	=>
	(unmake-instance ?p)
)

(defrule remove_if_duplicate_store
	(object (is-a Location)
		(OBJECT ?p)
		(location_city ?loc)
	)
	(object (is-a Game)
		(OBJECT ~?p)
		(location_city ?loc)
	)
	=>
	(unmake-instance ?p)
)

(reset)
(run)
; (facts)
