//
//  SVGParserDelegate.swift
//  ComputationalGeometryAufgabe2
//
//  Created by Julian Wittek on 01.05.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

class SVGParserDelegate: NSObject, XMLParserDelegate {
    
    var svg = SVG()
    var g = G()
    var gsvgPaths = [GSVGPath]()
    var svgPaths = [SVGPath]()
    var isGroup = false
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "svg" {
            if let version = attributeDict["version"] {
                svg.version = version
            }
            if let id = attributeDict["id"] {
                svg.id = id
            }
            if let xmlns = attributeDict["xmlns"] {
                svg.xmlns = xmlns
            }
            if let xmlnsXlink = attributeDict["xmlns:xlink"] {
                svg.xmlnsXlink = xmlnsXlink
            }
            if let xmlnsSodipodi = attributeDict["xmlns:sodipodi"] {
                svg.xmlnsSodipodi = xmlnsSodipodi
            }
            if let width = attributeDict["width"] {
                svg.width = width
            }
            if let height = attributeDict["height"] {
                svg.height = height
            }
            if let viewBox = attributeDict["viewBox"] {
                svg.viewBox = viewBox
            }
            if let overflow = attributeDict["overflow"] {
                svg.overflow = overflow
            }
            if let enablebackground = attributeDict["enable-background"] {
                svg.enablebackground = enablebackground
            }
            if let xmlSpace = attributeDict["xml:space"] {
                svg.xmlSpace = xmlSpace
            }
        } else if elementName == "g" {
            isGroup = true
        } else if elementName == "path" {
            if isGroup {
                var tmpGSVGPath = GSVGPath()
                if let id = attributeDict["id"] {
                    tmpGSVGPath.id = id
                }
                if let fill = attributeDict["fill"] {
                    tmpGSVGPath.fill = fill
                }
                if let stroke = attributeDict["stroke"] {
                    tmpGSVGPath.stroke = stroke
                }
                if let strokeWidth = attributeDict["stroke-width"] {
                    tmpGSVGPath.strokeWidth = strokeWidth
                }
                if let d = attributeDict["d"] {
                    tmpGSVGPath.d = d
                }
                gsvgPaths.append(tmpGSVGPath)
            } else {
                let tmpSVGPath = SVGPath()
                if let sodipodiType = attributeDict["sodipodi:type"] {
                    tmpSVGPath.sodipodiType = sodipodiType
                }
                if let style = attributeDict["style"] {
                    tmpSVGPath.style = style
                }
                if let id = attributeDict["id"] {
                    tmpSVGPath.id = id
                }
                if let sodipodiCx = attributeDict["sodipodi:cx"] {
                    tmpSVGPath.sodipodiCx = sodipodiCx
                }
                if let sodipodiCy = attributeDict["sodipodi:cy"] {
                    tmpSVGPath.sodipodiCy = sodipodiCy
                }
                if let sodipodiRx = attributeDict["sodipodi:rx"] {
                    tmpSVGPath.sodipodiRx = sodipodiRx
                }
                if let sodipodiRy = attributeDict["sodipodi:ry"] {
                    tmpSVGPath.sodipodiRy = sodipodiRy
                }
                svgPaths.append(tmpSVGPath)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "svg" {
            svg.paths = svgPaths
            svg.g = g
        } else if elementName == "g" {
            g.paths = gsvgPaths
            isGroup = false
        }
    }
}
