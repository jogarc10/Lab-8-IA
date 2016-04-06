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
 (slot designer_category))

/* Adventure, sports, puzzle, family, rol, strategy*/

(deftemplate Game
(slot game_category)
(slot game_difficulty)
(slot game_duration)
(slot game_manufacturer)
(slot game_name)
(slot game_price)
(slot game_style)) 

(deftemplate Location
(slot location_city)
(slot location_continent)
(slot location_country))

(deftemplate Manufacturer
(slot manufacturer_city)
(slot manufacturer_name))

(deftemplate Store
(slot store_games)
(slot store_location)
(slot store_name))
 	
(deffacts ini
	(Location (location_city "Madrid")(location_continent "Europe")(location_country "Spain"))
	(Location (location_city "NewYork")(location_continent "America")(location_country "USA"))
	(Location (location_city "Tokyo")(location_continent "Asia")(location_country "Japan"))
	(Manufacturer (manufacturer_city "NewYork") (manufacturer_name "CocktailGames"))
	(Designer (designer_location "Madrid") (designer_name "Cliff Blezinsnky") (designer_category "Rol"))
 
	(Game (game_category Adventure) (game_difficulty "hard") (game_duration 60) (game_manufacturer "CocktailGames") (game_name "Go Game") (game_price 20.0) (game_style single))
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
	(Game (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?manufacturer) (game_name ?name) (game_price ?price) (game_style ?style))
	(object (is-a Manufacturer) (OBJECT ?h1) (manufacturer_name ?manufacturer)) 
	=>
	(make-instance of Game (game_category ?category) (game_difficulty ?difficulty) (game_duration ?duration) (game_manufacturer ?h1) (game_name ?name) (game_price ?price) (game_style ?style))
)

(reset)
(run)
(facts) 

(deftemplate Designer
 (slot designer_location)
 (slot designer_name)
 (slot designer_category))