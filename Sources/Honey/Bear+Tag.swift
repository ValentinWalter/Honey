//
//  Bear+Tag.swift
//  Honey
//
//  Created by Valentin Walter on 5/22/21.
//

import Foundation
import Middleman

public extension Bear {
	/// This type behaves in the exact same way as a `String`, but can be useful
	/// for you to namespace your tag names, similar to `Note.Lookup`.
	@dynamicMemberLookup
	struct Tag:
		ExpressibleByStringLiteral,
		LosslessStringConvertible,
		CustomQueryConvertible,
		Codable
	{
		public init?(_ description: String) {
			self.description = description
		}
		
		public init(stringLiteral: String) {
			self.description = stringLiteral
		}
		
		public var description: String
		public var queryValue: String? { description }
		
		subscript<T>(dynamicMember dynamicMember: KeyPath<String, T>) -> T {
			description[keyPath: dynamicMember]
		}
	}
}
