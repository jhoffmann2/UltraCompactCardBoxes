# UltraCompactCardBoxes
This program utilizes OpenSCAD and FreeCAD to generate card box models (originally designed for dominion) that can compact multiple decks into a very small space. 

##To create box designs:
Inside the SCAD directory, copy or modify an existing CONFIG_ file. Here you can add decks, remove decks, and change the number of cards in the decks.

## Generate the box designs: 
1. Install OpenSCAD and FreeCAD
2. Find the path to your FreeCAD install directory. It's likely `<USER>\AppData\Local\Programs\FreeCAD 1.0`
3. Open a command line in the directory where you put this repository
4. run `<PATH_TO_FREECAD>\bin\python.exe main.py`
5. A directory should be generated for every box you created a template for. use the .step files for your final print - these should have rounded edges

## Generate text plates:
1. Install OpenSCAD and FreeCAD
2. Install the [overpass font](https://fonts.google.com/specimen/Overpass)
3. Open SCAD/DominionText.scad in OpenSCAD
4. change the line saying `include <CONFIG_Prosperity.scad>` to include the correct config for the box you're generating
5. comment/uncomment one of the several `current_object =` lines to toggle on and off different features of the text plate. This way you can make one model for each color and print the plate with AMS. If you want the entire plate to be one color, set current object to "ALL"
