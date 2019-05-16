//
//  Polygon.swift
//  ComputationalGeometryAufgabe2
//
//  Created by Julian Wittek on 16.05.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

struct Polygon {
    let points: [Point]
    let boundingBox: BoundingBox
    var polygonType: PolygonType?
}

enum PolygonType {
    case Additive
    case Subtractive
}
