//
//  Bear+Font.swift
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

    enum Font: String, Codable, CustomQueryConvertible {
        case avenirNext = "Avenir Next"
        case system = "System"
        case helveticaNeue = "Helvetica Neue"
        case menlo = "Menlo"
        case georgia = "Georgia"
        case courier = "Courier"
        case openDyslexic = "Open Dyslexic"

        public var queryValue: String? { rawValue }
    }

}
