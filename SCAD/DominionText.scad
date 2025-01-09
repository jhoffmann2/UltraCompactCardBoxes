include <DominionBoxHelper.scad>

include <CONFIG_Prosperity.scad>

//current_object = "ALL";
current_object = "TextPlate";
//current_object = "Action";
//current_object = "Reaction";
//current_object = "Treasure";
//current_object = "Victory";
//current_object = "Curse";
//current_object = "Duration";

translate([
    -0.5 * allCardsThickness, 
    -0.5 * boxSize.y - textPlateThickness, 
    slotHeight - sin(deckRotation)*(0.5*(cardLength-deckShift))])
union()
{
    
    defineObject("TextPlate") color([0.2,0.2,0.2])
    {
        
        translate([ 0,0,-slotHeight])
        cube([allCardsThickness, textPlateThickness, slotHeight]);
    }
    for( i = [0:len(cards)-1])
    {
        if (cards[i][0] > 0)
        {
            defineObject(cards[i][2]) color("white")
            {
                cardName(i);
            }
        }
    }
}

