//
//  Bear+Theme.swift
//  Honey
//
//  Created by Valentin Walter on 4/22/20.
//  

import Foundation
import Middleman

public extension Bear {
	/// Bear provides a handful of themes to customize your experience.
	/// You can change fonts via the `Bear.changeTheme()` wrapper or
	/// `Bear.ChangeTheme` action.
    enum Theme: String, Codable, CustomQueryConvertible {
        case redGraphite    = "Red Graphite"
		case highContrast   = "High Contrast"
		case darkGraphite   = "Dark Graphite"
		case charcoal       = "Charcoal"
        case solarizedLight = "Solarized Light"
        case solarizedDark  = "Solarized Dark"
        case panicMode      = "Panic Mode"
		case gotham         = "Gotham"
        case dracula        = "Dracula"
        case toothpaste     = "Toothpaste"
        case cobalt         = "Cobalt"
        case duotoneLight   = "Duotone Light"
        case duotoneSnow    = "Duotone Snow"
		case duotoneHeat    = "Duotone Heat"
        case dieci          = "Dieci"
        case ayu            = "Ayu"
        case ayuMirage      = "Ayu Mirage"
        case gandalf        = "Gandalf"
		case oliveDunk      = "Olive Dunk"
		case dBoring        = "D.Boring"
		case nord           = "Nord"
		case lighthouse     = "Lighthouse"
		
		public var queryValue: String? { rawValue }
    }
}
