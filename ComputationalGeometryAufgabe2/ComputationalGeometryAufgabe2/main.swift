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
var regions = [String: [Point]]()

for var svgRegion in svgRegions {
//    let coordinateLines = svgRegion.d.components(separatedBy: CharacterSet(charactersIn: " MlLzH")).filter( { $0 != "" } )

    if let hIndex = svgRegion.d.firstIndex(of: "H") {
        svgRegion.d.insert(" ", at: hIndex)
    }
    
    let coordinateLines = svgRegion.d.components(separatedBy: " ").filter( { $0 != "" } )

    var points = [Point]()
    var lastAbsolutePoint = Point(id: "", x: 0.0, y: 0.0)
    var lastRelativPoint = Point(id: "", x: 0.0, y: 0.0)
    
    for coordinateLine in coordinateLines {

        let point: Point
        let id = String(coordinateLine.prefix(1))
        
        if id == "M" || id == "L" {
            let coordinateLineWithOutID = coordinateLine.dropFirst()
            let coordinates = coordinateLineWithOutID.components(separatedBy: ",")
            let x = Double(coordinates[0])!
            let y = Double(coordinates[1])!
            
            point = Point(id: id, x: x, y: y)
            lastAbsolutePoint = point
            lastRelativPoint = point
        } else if id == "l" {
            let coordinateLineWithOutID = coordinateLine.dropFirst()
            let coordinates = coordinateLineWithOutID.components(separatedBy: ",")
            let x = Double(coordinates[0])!
            let y = Double(coordinates[1])!
            
            point = Point(id: id, x: lastRelativPoint.x + x, y: lastRelativPoint.y + y)
            lastRelativPoint = point
        } else if id == "z" {
            point = lastAbsolutePoint
        } else if id == "H" {
            let coordinateLineWithOutID = coordinateLine.dropFirst()
            let x = Double(coordinateLineWithOutID)!
            
            point = Point(id: id, x: lastRelativPoint.x + x, y: lastRelativPoint.y)
            lastRelativPoint = point
        } else {
            fputs("Unknown ID!", stderr)
            exit(-1)
        }
        
        points.append(point)
    }
    
    regions.updateValue(points, forKey: svgRegion.id)
}

func getVolumeWithOrigin(firstPoint: Point, secondPoint: Point) -> Double {
    return firstPoint.x * secondPoint.y - secondPoint.x * firstPoint.y
}

var germany = 0.0

for region in regions {
    var volume = 0.0
    let points = region.value
    for index in 0..<points.count - 1 {
        volume += getVolumeWithOrigin(firstPoint: points[index], secondPoint: points[index + 1])
    }
    volume /= 2.0
    
    germany += volume
    
    print("\(region.key) \(volume)")
}

print("Deutschland \(germany)")

