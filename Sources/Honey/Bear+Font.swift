//
//  Bear+Font.swift
//  Honey
//
//  Created by Valentin Walter on 4/22/20.
//

import Foundation
import Middleman

public extension Bear {
	/// Bear provides a handful of fonts to customize your experience.
	/// You can change fonts via the `Bear.changeFont()` wrapper or
	/// `Bear.ChangeFont` action.
    enum Font: String, Codable, CustomQueryConvertible {
        case avenirNext    = "Avenir Next"
        case system        = "System"
        case helveticaNeue = "Helvetica Neue"
        case menlo         = "Menlo"
        case georgia       = "Georgia"
        case courier       = "Courier"
        case openDyslexic  = "Open Dyslexic"
		
		public var queryValue: String? { rawValue }
    }
}
