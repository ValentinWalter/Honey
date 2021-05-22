//
//  Bear+AddMode.swift
//  Honey
//
//  Created by Valentin Walter on 4/19/20.
//

import Foundation
import Middleman

public extension Bear {
    /// The `AddMode` determines how to add text to a note.
    enum AddMode: String, Codable, CustomQueryConvertible {
        case prepend
        case append
        case replaceAll = "replace_all"
        case replace

        public var queryValue: String? { rawValue }
    }
}
