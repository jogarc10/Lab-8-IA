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
 
 (deftemplate Game
 (slot game_category)
 (slot game_difficulty)
 (slot game_duration)
 (slot game_manufacturer)
 (slot game_name)
 (slot game_price)
 (slot game_stores)
 (slot game_style)) 
 
 (deftemplate Location
 (slot location_city)
 (slot location_continent)
 (slot location_country))
 
 (deftemplate Manufacturer
 (slot manufacturer_location)
 (slot manufacturer_name))
 
 (deftemplate Store
 (slot store_games)
 (slot store_location)
 (slot store_name))

 
(deffacts ini
(Location (location_city Madrid)(location_continent Europe)(location_country Spain))
(Location (location_city New_York)(location_continent America)(location_country USA))
(Location (location_city Tokyo)(location_continent Asia)(location_country Japan))
)

(defrule locations
	(Location (location_city ?city)(location_continent ?continent) (location_country ?country))
	=>
	(make-instance of Location (location_city ?city)(location_continent ?continent) (location_country ?country))
)

(reset)
(run)
(facts) 
