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
(Location (city Madrid)(continent Europe)(country Spain))
(Location (city New_York)(continent America)(country USA))
(Location (city Tokyo)(continent Asia)(country Japan))
)

(defrule locations
	(Location (location_city ?city)(location_continent ?continent) (location_country ?country))
	=>
	(make-instance of Location (location_city ?city)(location_continent ?continent) (location_country ?country))
)

(reset)
(run)
(facts) 
