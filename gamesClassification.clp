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
		(game_category "Adventure")
		(game_difficulty "hard")
		(game_duration 60)
		(game_manufacturer "CocktailGames")
		(game_name "Go Game")
		(game_price 20.0)
		(game_style "single")
	)
	(Game
		(game_age 13)
		(game_category "Family")
		(game_difficulty "easy")
		(game_duration 90)
		(game_manufacturer "RedBricksStudio")
		(game_name "Wolf")
		(game_price 10.0)
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

/*****************************************************/
/******** Classification by age of the games ********/
/****************************************************/

/*(defrule games
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	=>
	(make-instance of Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)*/

(defrule games_less_10
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test (< ?age 10))
	=>
	(make-instance of Game_less_10_age (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_less_10_14
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test(and(> ?age 10) (< ?age 14)))
	=>
	(make-instance of Game_10_to_14_age (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(defrule games_less_14_18
	(Game (game_age ?age) (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	(test(and(> ?age 14) (< ?age 18)))
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
