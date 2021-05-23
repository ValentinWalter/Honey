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
		public init(_ tag: String) {
			self.description = tag
		}
		
		public init(stringLiteral: String) {
			self.description = stringLiteral
		}
		
		public var description: String
		public var queryValue: String? { description }
		
		subscript<T>(dynamicMember dynamicMember: KeyPath<String, T>) -> T {
			description[keyPath: dynamicMember]
		}
		
		public init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			self.description = try container.decode(String.self)
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.singleValueContainer()
			try container.encode(description)
		}
	}
}
