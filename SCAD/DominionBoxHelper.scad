cards = [];
forceBoxLength = 0;

$fn = 60;
cardThickness = 0.3231333;
deckTolorance = 0.5;
slotHeight = 40;
cardLength = 92;
cardWidth = 60;
deckShift = 14;
deckRotation = 7;
boxThickness = [2,1,2];
cardEdgeRadius = 4;
textPlateThickness = 0.4;
textThickness = 0.4;

rotatedWidth = cos(deckRotation) * (cardLength + deckShift);
rotatedHeight = cos(deckRotation) * (cardWidth) + sin(deckRotation) * (cardLength + deckShift);

allCardsThickness = cardThickness*sum_to_index(cards, len(cards)-1) + deckTolorance * len(cards);

boxSize = [
        max(forceBoxLength, allCardsThickness + 2 * boxThickness.x),
        rotatedWidth + 2 * boxThickness.y,
        slotHeight + boxThickness.z
        ];

module defineObject(object_name) {
    if (current_object != "ALL" && current_object != object_name) {
        *children();
    } else {
        children();
    }
}

function sum_to_index(arr, i) =
    i < 0 ? 0 : abs(arr[i][0]) + sum_to_index(arr, i - 1);
    
module deck(i)
{
    union()
    {
        depth = cardThickness*cards[i][0] + deckTolorance + 0.01;
        rotate([0,90,0])
        translate([(0.5*cardWidth - cardEdgeRadius), (0.5*cardLength - cardEdgeRadius), 0])
        cylinder(h=depth, r=cardEdgeRadius, center=true);
        rotate([0,90,0])
        translate([-(0.5*cardWidth - cardEdgeRadius), (0.5*cardLength - cardEdgeRadius), 0])
        cylinder(h=depth, r=cardEdgeRadius, center=true);
        rotate([0,90,0])
        translate([(0.5*cardWidth - cardEdgeRadius), -(0.5*cardLength - cardEdgeRadius), 0])
        cylinder(h=depth, r=cardEdgeRadius, center=true);
        rotate([0,90,0])
        translate([-(0.5*cardWidth - cardEdgeRadius), -(0.5*cardLength - cardEdgeRadius), 0])
        cylinder(h=depth, r=cardEdgeRadius, center=true);
        cube([depth, cardLength - 2 * cardEdgeRadius, cardWidth], true);
        cube([depth, cardLength, cardWidth - 2 * cardEdgeRadius], true);
    }
}
    
module cardSlot(i)
{
    slotThickness = cardThickness*cards[i][0] + deckTolorance + 0.01;
    rotate((i%2 ? -1 : 1) * deckRotation, [1,0,0])
    translate(0.5*[slotThickness, cardLength, cardWidth])
    translate(-0.5 * [allCardsThickness, cardLength, 0]) // center
    translate([cardThickness*sum_to_index(cards, i-1) + deckTolorance * i, (i%2 ? -0.5 : 0.5)*deckShift, 0])
    deck(i);
}

module tokenSlot()
{
    slotThickness = 20;
    
    translate(0.5*[slotThickness, cardLength, cardWidth])
    translate(-0.5 * [allCardsThickness, cardLength, 0]) // center
    translate([allCardsThickness, 0, 0])
    cube([slotThickness, cardLength, cardWidth], true);
}

module cardName(i)
{
    translate([cardThickness*sum_to_index(cards, i-1) + deckTolorance * i, 0, 0])
    translate(0.5*[cardThickness*cards[i][0], 0, -3])
    rotate([90,-90,0])
    {
        linear_extrude(height=textThickness)
        text(cards[i][1], 2.6, "overpass", halign = "right", valign = "center");
    }
}

