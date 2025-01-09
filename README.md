# UltraCompactCardBoxes
This program utilizes OpenSCAD and FreeCAD to generate card box models (originally designed for dominion) that can compact multiple decks into a very small space. 

##To create box designs:
Inside the SCAD directory, copy or modify an existing CONFIG_ file. Here you can add decks, remove decks, and change the number of cards in the decks.

##Generate the box designs: 
1. Install OpenSCAD and FreeCAD
2. Find the path to your FreeCAD install directory. It's likely `<USER>\AppData\Local\Programs\FreeCAD 1.0`
3. Open a command line in the directory where you put this repository
4. run `<PATH_TO_FREECAD>\bin\python.exe main.py`
5. A directory should be generated for every box you created a template for. use the .step files for your final print - these should have rounded edges
