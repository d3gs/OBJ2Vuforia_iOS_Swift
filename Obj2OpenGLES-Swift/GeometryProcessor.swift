 //
//  LineProcessor.swift
//  Obj2OpenGLES-Swift
//
//  Created by Carlos on 3/12/14.
//  Copyright (c) 2014 d3gs. All rights reserved.
//

/*
 Procesador de geometría, transforma las líneas del fichero OBJ exportado de Blender a un objeto Geometría.
 El quid es que el orden de exportación de Blender es particular y no sigue el patrón estandarizado con el fin de 
 reutilizar tantos elementos como sea posible.
 */
 
import Cocoa

class GeometryProcessor: NSObject {

    var geometry = Geometry()

    func process(filename:String, materials: [Material])->Void {
        self.geometry.materials = materials
        self.processFile(filename)
    }

    func processFile(filename: String)->Void {
        if let aStreamReader = StreamReader(path: filename) {
            while let line = aStreamReader.nextLine() {
                self.processLine(line)
            }
            aStreamReader.close()
        }
    }

    func processLine(line: String)->Void {
        self.checkForMaterialLibrary(line)
        self.checkForMaterial(line)
        self.checkForVerticesPositions(line)
        self.checkForVertexTextures(line)
        self.checkForVertexNormals(line)
        self.checkForIndices(line)
    }

    func checkForMaterialLibrary(line:String)->Void {
        if let range = line.rangeOfString("mtllib "){
            let end = line.rangeOfString("mtllib ")?.endIndex
            self.geometry.mtllib = line.substringFromIndex(end!)
        }
    }

    func checkForVerticesPositions(line:String)->Void {
        if let vRange = line.rangeOfString("v ") {
            let vline = line.substringFromIndex(vRange.endIndex)
            let vcomponents = vline.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let v1:Float = (vcomponents[0] as NSString).floatValue
            let v2:Float = (vcomponents[1] as NSString).floatValue
            let v3:Float = (vcomponents[2] as NSString).floatValue
            let newVertex = Vertex(v1: v1, v2: v2, v3: v3)
            self.geometry.vertices.append(newVertex)
        }
    }

    func checkForVertexTextures(line:String)->Void {
        if let vRange = line.rangeOfString("vt ") {
            let vline = line.substringFromIndex(vRange.endIndex)
            let vcomponents = vline.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let t1:Float = (vcomponents[0] as NSString).floatValue
            let t2:Float = (vcomponents[1] as NSString).floatValue
            let newTexel = Texel(t1: t1, t2: t2)
            self.geometry.texels.append(newTexel)
        }
    }

    func checkForVertexNormals(line:String)->Void {
        if let vRange = line.rangeOfString("vn ") {
            let vline = line.substringFromIndex(vRange.endIndex)
            let vcomponents = vline.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let n1:Float = (vcomponents[0] as NSString).floatValue
            let n2:Float = (vcomponents[1] as NSString).floatValue
            let n3:Float = (vcomponents[2] as NSString).floatValue
            let newNormal = Normal(n1: n1, n2: n2, n3: n3)
            self.geometry.normals.append(newNormal)
        }
    }

    //Vertex/texture-coordinate/normal -> V/Vt/Vn
    func checkForIndices(line:String)->Void {
        if let vRange = line.rangeOfString("f ") {
            let charset = NSCharacterSet(charactersInString: " /")
            let components:[String] = line.componentsSeparatedByCharactersInSet(charset)

            let pos1:Int = (components[1].toInt())! - 1 //OBJ se basa en indices que empiezan en 1 mientras opengles empiezan en 0
            let pos2:Int = (components[4].toInt())! - 1
            let pos3:Int = (components[7].toInt())! - 1
            self.geometry.currentMaterial.indices.append(pos1)
            self.geometry.currentMaterial.indices.append(pos2)
            self.geometry.currentMaterial.indices.append(pos3)
        }
    }

    func checkForMaterial(line:String)->Void {
        if let mat = line.rangeOfString("usemtl ") {
            let end = line.rangeOfString("usemtl ")?.endIndex
            var name = line.substringFromIndex(end!)
            for mat in self.geometry.materials {
                if mat.name == name {
                    self.geometry.currentMaterial = mat
                }
            }
        }
    }
}
