//
//  SVG.swift
//  ComputationalGeometryAufgabe2
//
//  Created by Julian Wittek on 01.05.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

class SVG {
    var version = ""
    var id = ""
    var xmlns = ""
    var xmlnsXlink = ""
    var xmlnsSodipodi = ""
    var width = ""
    var height = ""
    
    var viewBox = ""
    var overflow = ""
    var enablebackground = ""
    var xmlSpace = ""
    
    var g = G()
    var paths = [SVGPath]()
}
