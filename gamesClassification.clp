(clear)

(mapclass Designer)
(mapclass Game)
(mapclass Location)
(mapclass Manufacturer)
(mapclass Store)

(deftemplate Designer
 (slot location)
 (slot name)
 (slot category))
 
 (deftemplate Game
 (slot category)
 (slot difficulty)
 (slot duration)
 (slot manufacturer)
 (slot name)
 (slot price)
 (slot seller_store)
 (slot style)) 
 
 (deftemplate Location
 (slot location_city)
 (slot location_continent)
 (slot location_country))
 
 (deftemplate Manufacturer
 (slot location)
 (slot name))
 
 (deftemplate Store
 (slot games)
 (slot location)
 (slot name))

 
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
