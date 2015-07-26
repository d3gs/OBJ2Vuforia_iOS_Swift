//
//  Material.swift
//  Obj2OpenGLES-Swift
//
//  Created by Carlos on 8/12/14.
//  Copyright (c) 2014 d3gs. All rights reserved.
//

/*
Guardamos las propiedades básicas de cada material: Difuso, ambiente y especular respecto a la fuente de luz,
así como si le aplica una textura
*/

import Foundation


struct Diffuse {
    var d1:Float
    var d2:Float
    var d3:Float

}

struct Specular {
    var s1:Float
    var s2:Float
    var s3:Float
}

struct Ambient {
    var a1:Float
    var a2:Float
    var a3:Float
}

class Material: NSObject {
    var name = String() //Nombre de la textura en sí
    var texture = String() //Nombre del fichero con la textura (azul.png por ejemplo)
    var diffuse = Diffuse(d1: 0, d2: 0, d3: 0)
    var specular = Specular(s1: 0, s2: 0, s3: 0)
    var ambient = Ambient(a1: 0, a2: 0, a3: 0)

    var indices = [Int]()
}