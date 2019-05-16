//
//  main.swift
//  ComputationalGeometryAufgabe2
//
//  Created by Julian Wittek on 25.04.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

let argumentCount = CommandLine.argc
let arguments = CommandLine.arguments

if argumentCount < 2 {
    fputs("Please provide the file path to DeutschlandMitStaedten.svg", stderr)
    exit(-1)
}

let xmlData = FileManager.default.contents(atPath: URL(string: arguments[1])!.path)!
let xmlString = String.init(bytes: xmlData, encoding: .utf8)!

let parser = XMLParser(data: xmlData)
let parserDelegate = SVGParserDelegate()
parser.delegate = parserDelegate
parser.parse()

let svg = parserDelegate.svg

let svgRegions = svg.g.paths
var regions = [String: [Polygon]]()

for var svgRegion in svgRegions {
    if let hIndex = svgRegion.d.firstIndex(of: "H") {
        svgRegion.d.insert(" ", at: hIndex)
    }
    
    let coordinateLines = svgRegion.d.components(separatedBy: " ").filter( { $0 != "" } )

    var polygonPoints = [Point]()
    var startPoint = Point(id: "", x: 0.0, y: 0.0)
    var lastPoint = Point(id: "", x: 0.0, y: 0.0)
    var polygons = [Polygon]()
    
    for coordinateLine in coordinateLines {

        let point: Point
        let id = String(coordinateLine.prefix(1))
        
        if id == "M" {
            
            let coordinateLineWithOutID = coordinateLine.dropFirst()
            let coordinates = coordinateLineWithOutID.components(separatedBy: ",")
            let x = Double(coordinates[0])!
            let y = Double(coordinates[1])!
            
            point = Point(id: id, x: x, y: y)
            startPoint = point
            lastPoint = point
            polygonPoints.append(point)
        } else if id == "L" {
            let coordinateLineWithOutID = coordinateLine.dropFirst()
            let coordinates = coordinateLineWithOutID.components(separatedBy: ",")
            let x = Double(coordinates[0])!
            let y = Double(coordinates[1])!
            
            point = Point(id: id, x: x, y: y)
            lastPoint = point
            polygonPoints.append(point)
        } else if id == "l" {
            let coordinateLineWithOutID = coordinateLine.dropFirst()
            let coordinates = coordinateLineWithOutID.components(separatedBy: ",")
            let x = Double(coordinates[0])!
            let y = Double(coordinates[1])!
            
            point = Point(id: id, x: lastPoint.x + x, y: lastPoint.y + y)
            lastPoint = point
            polygonPoints.append(point)
        } else if id == "H" {
            let coordinateLineWithOutID = coordinateLine.dropFirst()
            let x = Double(coordinateLineWithOutID)!
            
            point = Point(id: id, x: lastPoint.x + x, y: lastPoint.y)
            lastPoint = point
            polygonPoints.append(point)
            
        } else if id == "z" {
            if startPoint.x != lastPoint.x && startPoint.y != lastPoint.y {
                fputs("Missing Line, can not close path!", stderr)
                exit(-1)
            }
            
            polygons.append(Polygon(points: polygonPoints, boundingBox: getBoundingBox(points: polygonPoints), polygonType: nil))
            polygonPoints = []
        } else {
            fputs("Unknown ID!", stderr)
            exit(-1)
        }
    }
    
    var signedPolygons = [Polygon]()
    
    for firstIndex in 0..<polygons.count {
        var hasPoint = false
        for secondIndex in (firstIndex + 1)..<polygons.count {
            if pointInPolygon(point: polygons[firstIndex].points.first!, polygon: polygons[secondIndex]) {
                hasPoint = true
            }
        }
        var newPolygon = polygons[firstIndex]
        
        if hasPoint {
            newPolygon.polygonType = PolygonType.Subtractive
        } else {
            newPolygon.polygonType = PolygonType.Additive
        }

        signedPolygons.append(newPolygon)
    }
    
    regions.updateValue(signedPolygons, forKey: svgRegion.id)
}



// https://de.wikipedia.org/wiki/Liste_der_deutschen_Bundesländer_nach_Fläche
let wikiSizes = [
    "Mecklenburg-Vorpommern" : 23292.73,
    "Berlin": 891.12,
    "Sachsen": 18449.99,
    "Sachsen-Anhalt": 20452.14,
    "Nordrhein-Westfalen": 34112.74,
    "Bayern": 70542.03,
    "Niedersachsen": 47709.83,
    "Saarland": 2571.10,
    "Rheinland-Pfalz": 19858.00,
    "Brandenburg": 29654.38,
    "Baden__x26__Württemberg": 35673.71,
    "Bremen": 419.84,
    "Thüringen": 16202.37,
    "Schleswig-Holstein": 15802.27,
    "Hamburg": 755.09,
    "Hessen": 21115.67,
    "Deutschland": 357578.17
]

var volumeGermany = 0.0

for region in regions {
    var volumeRegion = 0.0
    let polygons = region.value
    
    for polygon in polygons {
        let volumeOfPolygon = getVolumeOfPolygon(polygon: polygon)
        
        if polygon.polygonType == PolygonType.Additive {
            volumeRegion += volumeOfPolygon
        } else {
            volumeRegion -= volumeOfPolygon
        }
        
    }
    
    volumeRegion *= 0.5
    
    volumeGermany += volumeRegion
    
    let regionFactor = wikiSizes[region.key]! / volumeRegion
    
    print(String(format: "%.2f", regionFactor) + " \(region.key): " + String(format: "%.2f", volumeRegion))
}

let germanyFactor = wikiSizes["Deutschland"]! / volumeGermany

print(String(format: "%.2f", germanyFactor) + " Deutschland: " + String(format: "%.2f", volumeGermany))

