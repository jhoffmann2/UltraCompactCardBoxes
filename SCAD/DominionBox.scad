include <DominionBoxHelper.scad>

include <CONFIG_Basic.scad>

current_object = "ALL";
//current_object = "Box";
//current_object = "TextPlate";
//current_object = "action";
//current_object = "treasure";
//current_object = "victory";
//current_object = "curse";
//current_object = "duration";

defineObject("Box") color([0.2,0.2,0.2])
{
    expectedLength = allCardsThickness + 2 * boxThickness.x;
    difference()
    {
        translate([
            0.5 * (boxSize.x - expectedLength),
            0,
            0.5 * (slotHeight - boxThickness[2]) - sin(deckRotation)*(0.5*(cardLength-deckShift))
        ])
        cube(boxSize, true);
        
        for( i = [0:len(cards)-1])
        {
            if (cards[i][0] > 0)
            {
                cardSlot(i);
            }
        }
        
        translate(0.5*[boxSize.x - boxThickness.x, 0, cardWidth])
        cube([
        boxSize.x - expectedLength - 2 * boxThickness.x, 
        boxSize.y - 4 * boxThickness.y, 
        cardWidth
        ], true);
    }
    
    
    
}

