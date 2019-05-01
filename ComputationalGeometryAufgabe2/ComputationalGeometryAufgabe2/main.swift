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
