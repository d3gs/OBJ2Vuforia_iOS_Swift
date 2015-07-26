//
//  Writer.swift
//  Obj2OpenGLES-Swift
//
//  Created by Carlos on 16/12/14.
//  Copyright (c) 2014 d3gs. All rights reserved.
//

import Foundation

class Writer:NSObject {

    var hPath:NSString = NSString()
    var mPath:NSString = NSString()

    init(name:String, geometry:Geometry){
        super.init()
        self.pathsForFiles(name)
        self.writeH(geometry, name: name)
        self.writeM(geometry)
        self.writeTextures(geometry, filename: name)
    }

    func pathsForFiles(name:String) {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory

            var headerPath = dir.stringByAppendingPathComponent(name)
            headerPath = headerPath.stringByAppendingPathExtension("h")!
            self.hPath = headerPath
            var implementationPath = dir.stringByAppendingPathComponent(name)
            implementationPath = implementationPath.stringByAppendingPathExtension("m")!
            self.mPath = implementationPath
        }
    }

    func writeH(geo: Geometry, name:String){
        var headerText:String = ""
        headerText = "#import \"" + name + ".m\"" + "\n"
        headerText += "\n"

        //material library
        let nameLength = count(name)
        headerText += "extern const char* mtllib;" +  "\n" //Sin los 4 caracteres de la extensión

        let verticesCount = count(geo.vertices)
        headerText += "extern const GLfloat vertices[\(verticesCount * 3)];" + "\n"

        let texelsCount = count(geo.texels)
        headerText += "extern const GLfloat texels[\(texelsCount * 2)];" + "\n"

        let normalsCount = count(geo.normals)
        headerText += "extern const GLfloat normals[\(normalsCount * 3)];" + "\n"

        headerText += "extern const GLushort materialsCount = \(geo.materials.count);\n"
        //material
        //posIndices
        //normalIndices
        //textureIndices
        
        var error: NSError?
        headerText.writeToFile(self.hPath as String, atomically: false, encoding: NSUTF8StringEncoding, error: &error);
        if error != nil {
            println("Error escribiendo el .h")
        }
    }

    func writeM(geo: Geometry){

        var implementationText = "const char* mtllib = \"\(geo.mtllib)\";" +  "\n\n"
        implementationText += self.writeVertices(geo)
        implementationText += self.writeTexels(geo)
        implementationText += self.writeNormals(geo)
        //implementationText += self.writeIndices(geo)
        implementationText.writeToFile(self.mPath as String, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
    }

    //writing
    func writeVertices(geo:Geometry)->String{
        let verticesCount = count(geo.vertices)
        var text = "const GLfloat vertices[\(verticesCount * 3)] = { " + "\n"
        for vertex in geo.vertices {
            text += "\(vertex.v1)" + "," + "\(vertex.v2)" + "," + "\(vertex.v3)" + ", \n"
        }
        text += "}; " + "\n\n"
        return text
    }

    func writeTexels(geo: Geometry)->String {
        let texelsCount = count(geo.texels)
        var text = "const GLfloat texels[\(texelsCount * 2)] = { " + "\n"
        for texel in geo.texels {
            text += "\(texel.t1)" + "," + "\(texel.t2)" + ", \n"
        }
        text += "}; " + "\n\n"
        return text
    }

    func writeNormals(geo: Geometry) -> String {
        let normalsCount = count(geo.normals)
        var text = "const GLfloat normals[\(normalsCount * 3)] = { " + "\n"
        for normal in geo.normals {
            text += "\(normal.n1)" + "," + "\(normal.n2)" + "," + "\(normal.n3)" + ", \n"
        }
        text += "}; " + "\n\n"
        return text
    }

    //Graba a disco un diccionario con las propiedades de las texturas
    func writeTextures(geo:Geometry, filename:String)->Void {
        var materials = NSMutableArray()

        for mat in geo.materials {
            let name = NSString(string: mat.name)
            let texture = NSString(string: mat.texture)
            let dif1 = NSNumber(float: mat.diffuse.d1)
            let dif2 = NSNumber(float: mat.diffuse.d2)
            let dif3 = NSNumber(float: mat.diffuse.d3)
            let amb1 = NSNumber(float: mat.ambient.a1)
            let amb2 = NSNumber(float: mat.ambient.a2)
            let amb3 = NSNumber(float: mat.ambient.a3)
            let spec1 = NSNumber(float: mat.specular.s1)
            let spec2 = NSNumber(float: mat.specular.s2)
            let spec3 = NSNumber(float: mat.specular.s3)
            let diffuse = NSArray(objects: dif1, dif2, dif3)
            let specular = NSArray(objects: spec1, spec2, spec3)
            let ambient = NSArray(objects: amb1, amb2, amb3)
            let dictObjects = NSArray(objects: name, texture, diffuse, specular, ambient, mat.indices)
            let dictKeys = NSArray(objects: "name", "texture", "diffuse", "specular", "ambient", "vIndices")
            let dict = NSDictionary(objects: dictObjects as [AnyObject], forKeys: dictKeys as [AnyObject])
            materials.addObject(dict)
        }
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            var filePath = dir.stringByAppendingPathComponent(filename)
            filePath = filePath.stringByAppendingPathExtension("materials")!
            materials.writeToFile(filePath, atomically: false)
    }
}
}