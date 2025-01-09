import os

import FreeCAD as App
import FreeCADGui as Gui
import Part
import math
import PartDesign
import re
from freecad import module_io
Gui.showMainWindow()

def get_top_faces(obj):
    flat_faces = []
    for face in obj.Shape.Faces:
        normal = face.Surface.Axis
        if normal.dot(App.Vector(0,0,1)) > 0.9999:
            flat_faces.append(face)

    return flat_faces


def change_extension(file_path, new_extension):
    base_name, _ = os.path.splitext(file_path)
    new_path = f"{base_name}.{new_extension}"
    return new_path


def copyFile(source, dest):
    # Open the file in read mode
    with open(source, "r") as file:
        # Read the file content
        file_content = file.read()

    with open(dest, "w") as file:
        # Write the modified content back to the file
        file.write(file_content)


def setupConfig(template_scad, config):
    if not os.path.exists(config):
        os.mkdir(config)

    configFile = f'CONFIG_{config}.scad'
    copyFile(f'SCAD/{configFile}', f'{config}/{configFile}')
    copyFile(f'SCAD/DominionBoxHelper.scad', f'{config}/DominionBoxHelper.scad')

    # Read the file content
    with open(f'SCAD/{template_scad}', "r") as file:
        file_content = file.read()

    # Replace the config file in the template with the correct config file
    file_content = re.sub(r'CONFIG_\w+\.scad', configFile, file_content)

    # Write the modified content to the output file
    filename = f"{config}/{template_scad}"
    with open(filename, "w") as file:
        file.write(file_content)
        return filename


def generate(input_file):

    module_io.OpenInsertObject("importCSG", input_file, "open")

    # get the 3D model document
    doc = App.ActiveDocument

    objects = doc.RootObjects

    output_file = change_extension(input_file, 'step')

    Part.export(objects, output_file)

    module_io.OpenInsertObject("Import", output_file, "open")

    objects = doc.RootObjects
    feature = objects[0]
    body = doc.addObject('PartDesign::Body','Body')
    feature.adjustRelativeLinks(body)
    body.ViewObject.dropObject(feature,None,'',[])
    feature = doc.getObject('BaseFeature')

    edge_to_faces = dict()
    for face in feature.Shape.Faces:
        if face.Surface.TypeId != 'Part::GeomPlane':
            continue
        for edge in face.Edges:
            id = f'{[edge.Vertexes[0].Point,edge.Vertexes[1].Point]}'
            if id not in edge_to_faces:
                edge_to_faces[id] = { "Edges": [edge], "Faces": [face] }
            else:
                edge_to_faces[id]["Edges"].append(edge)
                edge_to_faces[id]["Faces"].append(face)

    to_bevel = []
    for i, edge in enumerate(feature.Shape.Edges):
        id = f'{[edge.Vertexes[0].Point, edge.Vertexes[1].Point]}'
        faces = edge_to_faces[id]["Faces"]
        if len(faces) != 2:
            continue
        n = faces[0].normalAt(0,0)
        v = faces[0].CenterOfGravity - faces[1].CenterOfGravity

        if n.dot(v) > 0:
            to_bevel.append(f"Edge{i+1}")

    fillet = body.newObject('PartDesign::Fillet','Fillet')
    fillet.Base = (feature, to_bevel)
    fillet.Radius = 0.99

    doc.recompute()
    doc.saveAs("auto.FCStd")

    print(f"Successfully converted '{input_file}' to '{output_file}'.")
    Part.export([body], output_file)


# Defining main function
def main():
    for config in ['Basic', 'DominionV2', 'Prosperity', 'Seaside', 'GuildsCornucopia']:
        for template_scad in ["DominionBox.scad", "DominionLid.scad"]:
            input_file = setupConfig(template_scad, config)
            generate(input_file)


if __name__=="__main__":
    main()