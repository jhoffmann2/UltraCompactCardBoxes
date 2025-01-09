include <DominionBoxHelper.scad>

include <CONFIG_Basic.scad>

current_object = "ALL";
//current_object = "Lid";
//current_object = "Box";
//current_object = "TextPlate";
//current_object = "action";
//current_object = "treasure";
//current_object = "victory";
//current_object = "curse";
//current_object = "duration";

lidSize = [
    boxSize.x + 2.5 * boxThickness.x,
    boxSize.y + 2 * boxThickness.y,
    rotatedHeight + 2.5 * boxThickness.z,
];

module lidNegative()
{
    
    union()
    {
        translate([0,0,0.5 * (slotHeight - boxThickness.z) - sin(deckRotation)*(0.5*(cardLength-deckShift))])
        cube(boxSize + 0.4 * [1,1,1], true);
        
        rotate(deckRotation, [1,0,0])
        translate(0.5*[0, cardLength, cardWidth])
        translate(-0.5 * [0, cardLength, 0]) // center
        translate([0, (0.5)*deckShift, 0])
        {
            length = boxSize.x - 2 * boxThickness.x;
            
            rotate([0,90,0])
            translate([-(0.5*cardWidth - cardEdgeRadius), (0.5*cardLength - cardEdgeRadius), 0])
            cylinder(h=length, r=cardEdgeRadius, center=true);
            
            
            #cube([length, cardLength, cardWidth - 2 * cardEdgeRadius], true);
            
            translate([0, (0.5*cardLength - cardEdgeRadius), (0.5*cardWidth - cardEdgeRadius) + cardEdgeRadius])
            rotate(deckRotation, [-1,0,0])
            translate(-0.5 * [0,boxSize.y,cardWidth])
            cube([length,boxSize.y,cardWidth], center=true);
        }
        
        translate(0.5*[0, -lidSize.y, cardWidth - lidSize.z])
        translate(0.25*[0, cardLength, 0])
        {
            tabHeight = 4 * boxThickness.z;
            
            translate(0.5 * [0.5 * allCardsThickness, 0.5 * cardLength, 0])
            translate([-cardEdgeRadius, 0, 0])
            cylinder(h=(tabHeight), r=cardEdgeRadius, center=true);
            
            
            translate(0.5 * [-0.5 * allCardsThickness, 0.5 * cardLength, 0])
            translate([cardEdgeRadius, 0, 0])
            cylinder(h=(tabHeight), r=cardEdgeRadius, center=true);
            
            cube([0.5 * allCardsThickness, 0.5 * cardLength, tabHeight], center=true);
            
            cube([0.5 * allCardsThickness - 2 * cardEdgeRadius, 0.5 * cardLength + 2 * cardEdgeRadius, tabHeight], center=true);
        }
        
        
    }
}


defineObject("Lid") color("#fff3d6")
{
    difference()
    {
        translate([0, boxThickness.y, 0.5* (cardWidth - boxThickness.z)])
        cube(lidSize, true);
        lidNegative();
    }
}

