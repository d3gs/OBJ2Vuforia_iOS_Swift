//
//  main.swift
//  Obj2OpenGLES-Swift
//
//  Created by Carlos on 2/12/14.
//  Copyright (c) 2014 d3gs. All rights reserved.
//

/*

Extractor de datos de fichero Wavefront OBJ y MTL. Necesaria debido a las grandes discrepancias entre los ejemplos
sencillos de la documentación y la realidad de importar ficheros complejos con mucha geometría y materiales.
Crea una clase con datos optimizados para la implementación de Vuforia iOS.
No se hace en Swift directamente para permitir su importación en Objective-C++ (Vuforia)
Se generan el .h y el .m con arrays puros de C para evitar el problema de los arrays de C como ivar en Obj-C
Se guardan en la carpeta Documentos del usuario mac y hay que importarlos al proyecto.
Se debe crear una carpeta llamada source en este proyecto y dejar allí los ficheros obj y mtl de blender.
Se pasa el nombre del fichero como parámetro de ejecución, sin extensión. Ejemplo: cubo (para cubo.obj)
Se puede modificar el Scheme del Xcode y pasarle en el Run el nombre como Argument, para evitar ir a consola.
*/


import Foundation

println (Process.arguments[1])

let name = (Process.arguments[1]);
let geometryFilePath = "source/" + name + ".obj"
let materialsFilePath = "source/" + name + ".mtl"

println("Path: \(geometryFilePath)")

var mtllib = ""

var vertexIndex = 0;


//Procesar materiales, geometría y guardar a disco
var matProcessor = MaterialsProcessor(filename: materialsFilePath)
var geoProcessor = GeometryProcessor()
geoProcessor.process(geometryFilePath, materials: matProcessor.materials)

let writer = Writer(name: name, geometry: geoProcessor.geometry)


