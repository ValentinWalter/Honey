//
//  Bear+File.swift
//  Honey
//
//  Created by Valentin Walter on 5/23/20.
//  

import Foundation

public extension Bear {
	/// Files are used by the `Bear.Create` and `Bear.AddFile` actions.
	struct File {
		/// A textual description or title of the file.
		public let name: String
		/// The `Data` of the file.
        public let data: Data
		
		/// Files are used by the `Bear.Create` and `Bear.AddFile` actions.
		/// - Parameters:
		///   - name: A textual description or title of the file.
		///   - data: The `Data` of the file.
        public init(name: String, data: Data) {
            self.name = name
            self.data = data
        }
    }
}

#if canImport(UIKit)
import UIKit

extension Bear.File {
	/// Creates a `File` with the PNG data of the `UIImage`.
	public init?(name: String, image: UIImage) {
		guard let data = image.pngData() else { return nil }
		
		self.name = name
		self.data = data
	}
}
#endif
