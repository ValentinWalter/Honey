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
		/// Prepend at the start of the note.
        case prepend
		/// Append at the end of the note.
        case append
		/// Replace everything including the title.
        case replaceAll = "replace_all"
		/// Replace the note's body and keep the title.
        case replace

        public var queryValue: String? { rawValue }
    }
}
