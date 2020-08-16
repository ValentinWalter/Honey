//
//  Bear+AddMode.swift
//  HoneyTests
//
//  Created by Valentin Walter on 4/19/20.
//  
//
//  Abstract:
//
//

import Foundation
import Middleman

public extension Bear {

    /// The mode Bear sometimes uses to determine
    /// where to place something in a note.
    enum AddMode: String, Codable, CustomQueryConvertible {
        case prepend
        case append
        case replaceAll = "replace_all"
        case replace

        public var queryValue: String? { rawValue }
    }
    
}
