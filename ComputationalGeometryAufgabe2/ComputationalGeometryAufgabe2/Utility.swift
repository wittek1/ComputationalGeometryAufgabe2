//
//  Utility.swift
//  ComputationalGeometryAufgabe2
//
//  Created by Julian Wittek on 16.05.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

// > 0 left
// = 0 on
// < 0 right
func ccw(lineStart: Point, lineEnd: Point, point: Point) -> Double {
    return lineStart.y * point.x - lineEnd.y * point.x + lineEnd.x * point.y - lineStart.x * point.y - lineStart.y * lineEnd.x + lineStart.x * lineEnd.y
}

func sign(number: Double) -> Int {
    let result: Int
    
    if number.isZero {
        result = 0
    } else if number.sign == FloatingPointSign.minus {
        result = -1
    } else if number.sign == FloatingPointSign.plus {
        result = 1
    } else {
        fputs("Number is not 0, -1 or 1!", stderr)
        exit(-1)
    }
    
    return result
}

func isPointInPolygon(point: Point, polygon: Polygon) -> Bool {
    let pointOutside = Point(id: "outside", x: Double.random(in: polygon.boundingBox.maxX ... polygon.boundingBox.maxX + 1.0), y: Double.random(in: polygon.boundingBox.maxY ... polygon.boundingBox.maxY + 1.0))
    
    var startIndex = 0
    
    while ccw(lineStart: pointOutside, lineEnd: point, point: polygon.points[startIndex]) == 0{
        startIndex += 1
    }
    
    var intersects = 0
    var lr = sign(number: ccw(lineStart: pointOutside, lineEnd: point, point: polygon.points[startIndex]))
    
    for index in startIndex + 1 ... polygon.points.count - 1 {
        let lrnew = sign(number: ccw(lineStart: pointOutside, lineEnd: point, point: polygon.points[index]))
        
        if abs(lrnew - lr) == 2 {
            lr = lrnew
            
            if ccw(lineStart: polygon.points[index - 1], lineEnd: polygon.points[index], point: pointOutside) * ccw(lineStart: polygon.points[index - 1], lineEnd: polygon.points[index], point: point) <= 0 {
                intersects += 1
            }
        }
    }
    
    return intersects % 2 != 0
}

func getBoundingBox(points: [Point]) -> BoundingBox {
    var minX = Double.infinity
    var minY = Double.infinity
    var maxX = Double.infinity * -1
    var maxY = Double.infinity * -1
    
    
    for point in points {
        minX = min(point.x, minX)
        maxX = max(point.x, maxX)
        minY = min(point.y, minY)
        maxY = max(point.y, maxY)
    }
    
    return BoundingBox(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
}

func getVolumeWithOrigin(firstPoint: Point, secondPoint: Point) -> Double {
    return firstPoint.x * secondPoint.y - secondPoint.x * firstPoint.y
}

func getVolumeOfPolygon(polygon: Polygon) -> Double {
    var volumePolygon = 0.0
    
    for index in 0..<polygon.points.count - 1 {
        let firstPoint = polygon.points[index]
        let secondPoint = polygon.points[index + 1]
        
        let volumePartPolygon = getVolumeWithOrigin(firstPoint: firstPoint, secondPoint: secondPoint)
        volumePolygon += volumePartPolygon
    }
    
    return abs(volumePolygon)
}
