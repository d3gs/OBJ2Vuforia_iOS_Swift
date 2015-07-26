//
//  Geometry.swift
//  Obj2OpenGLES-Swift
//
//  Created by Carlos on 16/12/14.
//  Copyright (c) 2014 d3gs. All rights reserved.
//

/*


*/

import Foundation

/* Nuestra unidad fundamental para openGL ES es la face, la cual está compuesta por tres vértices,
la coordenada de textura y la normal a la cara. Le aplica un material
*/

struct Vertex {
    var v1:Float
    var v2:Float
    var v3:Float
}

struct Texel {
    var t1:Float
    var t2:Float
}

struct Normal {
    var n1:Float
    var n2:Float
    var n3:Float
}


class Geometry:NSObject {

    var mtllib = ""
    var vertices = [Vertex]()
    var texels = [Texel]()
    var normals = [Normal]()
    
    var currentMaterial = Material()
    var materials = [Material]()

    var colorMatIndices = [Int]()
    var texturedMatIndices = [Int]()
    var texturesCount = 0;


}