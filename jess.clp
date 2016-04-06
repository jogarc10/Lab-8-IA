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
 (slot city)
 (slot continent)
 (slot country))
 
 (deftemplate Manufacturer
 (slot location)
 (slot name))
 
 (deftemplate Store
 (slot games)
 (slot location)
 (slot name))

 