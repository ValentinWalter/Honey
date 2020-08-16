//
//  Bear+Note.swift
//  Honey
//
//  Created by Valentin Walter on 4/22/20.
//  
//
//  Abstract:
//
//

import Foundation

public extension Bear {

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
        public var markdown: String { body ?? title }

        /// Publishes the current state to Bear.
        /// - Parameter open: Whether or not to open the note in the Bear.
        func publish(open: Bool = false) {
            // Backup
            print(markdown)
            Bear.addText(
                note: .title(title),
                text: markdown,
                mode: .replaceAll,
                options: open ? .openNote : []
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

        public enum Lookup {
            case title(String)
            case id(String)

            var title: String? {
                if case let .title(title) = self {
                    return title
                } else {
                    return nil
                }
            }

            var id: String? {
                if case let .id(id) = self {
                    return id
                } else {
                    return nil
                }
            }
        }
    }
    
}
