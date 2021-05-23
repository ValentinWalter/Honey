//
//  Bear+Note.swift
//  Honey
//
//  Created by Valentin Walter on 4/22/20.
//  

import Foundation

public extension Bear {
	/// A note as found in *Bear*. Used to create and read notes.
    struct Note: Codable {
        public var title: String
        public var body: String?
        public let id: String
        public let modificationDate: Date
        public let creationDate: Date
        public let isPinned: Bool?
        public let isTrashed: Bool?

        internal init(from output: OpenNote.Output) {
            self.title = output.title
            self.body = output.note
            self.id = output.identifier
            self.modificationDate = output.modificationDate
            self.creationDate = output.creationDate
            self.isPinned = nil
            self.isTrashed = output.isTrashed
        }

        public init(title: String, body: String?) {
            let now = Date()

            self.title = title
            self.body = body
            self.id = UUID().uuidString
            self.modificationDate = now
            self.creationDate = now
            self.isPinned = false
            self.isTrashed = false
        }

        /// `title` and `body` combined.
        public var markdown: String { body ?? "# " + title }

        /// Publishes the current state of the note to Bear.
        /// - Parameter open: Whether or not to open the note in Bear.
        public func publish(open: Bool = false) {
            Bear.add(
				text: markdown,
                to: .title(title),
                mode: .replaceAll,
                options: open ? [] : .hideNote
            )
        }

        enum CodingKeys: String, CodingKey {
            case title
            case body
            case id = "identifier"
            case modificationDate
            case creationDate
            case isPinned = "pin"
            case isTrashed
        }
    }
}

extension Bear.Note {
	/// Look up notes by either a `title` or an `id`.
	///
	/// Additionally, this type can be useful to use as namespace for notes you
	/// use often. Just declare
	///
	///     static let myNote: Lookup = .title("📝 My Note")
	///
	/// in an extension of `Note.Lookup`. You can now use this actions like `Bear.open`.
	///
	///     Bear.open(note: .myNote)
	///
	public enum Lookup {
		case title(String)
		case id(String)
		
		public var title: String? {
			if case let .title(title) = self {
				return title
			} else {
				return nil
			}
		}
		
		public var id: String? {
			if case let .id(id) = self {
				return id
			} else {
				return nil
			}
		}
	}
}
