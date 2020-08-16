//
//  Bear+Theme.swift
//  Honey
//
//  Created by Valentin Walter on 4/22/20.
//  
//
//  Abstract:
//
//

import Foundation
import Middleman

public extension Bear {

    enum Theme: String, Codable, CustomQueryConvertible {
        case redGraphite = "Red Graphite"
        case charcoal = "Charcoal"
        case solarizedLight = "Solarized Light"
        case solarizedDark = "Solarized Dark"
        case panicMode = "Panic Mode"
        case dracula = "Dracula"
        case gotham = "Gotham"
        case toothpaste = "Toothpaste"
        case cobalt = "Cobalt"
        case duotoneLight = "Duotone Light"
        case duotoneSnow = "Duotone Snow"
        case dieci = "Dieci"
        case ayu = "Ayu"
        case ayuMirage = "Ayu Mirage"
        case darkGraphite = "Dark Graphite"
        case duotoneHeat = "Duotone Heat"
        case gandalf = "Gandalf"

        public var queryValue: String? { rawValue }
    }

}
