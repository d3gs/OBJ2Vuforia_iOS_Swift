//
//  MaterialsProcessor.swift
//  Obj2OpenGLES-Swift
//
//  Created by Carlos on 8/12/14.
//  Copyright (c) 2014 d3gs. All rights reserved.
//


/*
    Procesa el fichero de materiales y devuelve sus propiedades más básicas
*/

import Foundation

class MaterialsProcessor:NSObject {

    var material = Material()
    var materials = [Material]()

    init(filename: String) {
        super.init()
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
        self.checkForName(line)
        self.checkForTextureFile(line)
        self.checkForAmbient(line)
        self.checkForDiffuse(line)
        self.checkForSpecular(line)
    }

    func checkForName(line:String)->Void {
        if let range = line.rangeOfString("newmtl "){
            let end = line.rangeOfString("newmtl ")?.endIndex
            self.material = Material()
            self.material.name = line.substringFromIndex(end!)
            self.materials.append(self.material)
        }
    }

    func checkForAmbient(line:String)->Void {
        if let range = line.rangeOfString("Ka "){
            let end = line.rangeOfString("Ka ")?.endIndex
            let newString = line.substringFromIndex(end!)
            let aComponents = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let a1:Float = (aComponents[0] as NSString).floatValue
            let a2:Float = (aComponents[1] as NSString).floatValue
            let a3:Float = (aComponents[2] as NSString).floatValue
            let ambient = Ambient(a1: a1, a2: a2, a3: a3)
            self.material.ambient = ambient
        }
    }

    func checkForDiffuse(line:String)->Void {
        if let range = line.rangeOfString("map_Kd ") { //SEPARAR DEL map_Kd blabla.png
            return
        }
        if let range = line.rangeOfString("Kd "){
            let end = line.rangeOfString("Kd ")?.endIndex
            let newString = line.substringFromIndex(end!)
            let dComponents = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let d1:Float = (dComponents[0] as NSString).floatValue
            let d2:Float = (dComponents[1] as NSString).floatValue
            let d3:Float = (dComponents[2] as NSString).floatValue
            let diffuse = Diffuse(d1: d1, d2: d2, d3: d3)
            self.material.diffuse = diffuse
        }
    }

    func checkForSpecular(line:String)->Void {
        if let range = line.rangeOfString("Ks "){
            let end = line.rangeOfString("Ks ")?.endIndex
            let newString = line.substringFromIndex(end!)
            let sComponents = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let s1:Float = (sComponents[0] as NSString).floatValue
            let s2:Float = (sComponents[1] as NSString).floatValue
            let s3:Float = (sComponents[2] as NSString).floatValue
            let specular = Specular(s1: s1, s2: s2, s3: s3)
            self.material.specular = specular
        }
    }

    func checkForTextureFile(line: String)->Void {
        if let range = line.rangeOfString("map_Kd "){
            let end = line.rangeOfString("map_Kd ")?.endIndex
            var texturePath:NSString = (line.substringFromIndex(end!)as NSString)
            if let slashRange = line.rangeOfString("\\") {
                let components = texturePath.componentsSeparatedByString("\\")
                texturePath = components.last as! NSString
            }
            let filename:NSString = texturePath.lastPathComponent
            self.material.texture = filename as String
        }
    }
}
