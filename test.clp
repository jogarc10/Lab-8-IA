/* (batch "C:/hlocal/Lab-8-IA/gamesClassification.clp") */

(mapclass Location)
(mapclass Manufacturer)

(deftemplate Location
(slot location_city)
(slot location_continent)
(slot location_country))

(deftemplate Manufacturer
(slot manufacturer_city)
(slot manufacturer_name))
 	
(deffacts ini
(Location (location_city "Madrid")(location_continent "Europe")(location_country "Spain"))
(Location (location_city "NewYork")(location_continent "America")(location_country "USA"))
(Location (location_city "Tokyo")(location_continent "Asia")(location_country "Japan"))
(Manufacturer (manufacturer_city "NewYork") (manufacturer_name "Cocktail_Games"))
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

(reset)
(run)
(facts) 
