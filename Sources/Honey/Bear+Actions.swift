//
//  Actions.swift
//  Honey
//
//  Created by Valentin Walter on 4/15/20.
//  
//
//  Abstract:
//  Implementation of all actions found on
//  https://bear.app/faq/X-callback-url%20Scheme%20documentation/
//

import Foundation
import Middleman

public extension Bear {

    //MARK:- Open Note

    /// Open a note identified by its title or id and return its content.
    struct OpenNote: Action {
        public struct Input: Codable {
            public var id: String?
            public var title: String?
            public var header: String? = nil
            public var excludeTrashed: Bool? = nil
            public var newWindow: Bool? = nil
            public var openNote: Bool? = nil
            public var float: Bool? = nil
            public var showWindow: Bool? = nil
            public var pin: Bool? = nil
            public var edit: Bool? = nil
        }

        public struct Output: Codable {
            public let note: String
            public let identifier: String
            public let title: String
            public let isTrashed: Bool
            public let modificationDate: Date
            public let creationDate: Date
        }
    }


    //MARK:- Create

    /// Create a new note and return its unique identifier. Empty notes are not allowed.
    struct Create: Action {
        public struct Input: Codable {
            public var title: String?
            public var text: String?
            public var tags: [String]? = nil
            public var file: Data? = nil
            public var filename: String? = nil
            public var openNote: Bool? = nil
            public var newWindow: Bool? = nil
            public var showWindow: Bool? = nil
            public var pin: Bool? = nil
            public var edit: Bool? = nil
            public var timestamp: Bool? = nil
        }

        public struct Output: Codable {
            public let identifier: String
            public let title: String
        }
    }


    //MARK:- Add Text

    struct AddText: Action {
        public struct Input: Codable {
            public var id: String?
            public var title: String?
            public var text: String
            public var header: String? = nil
            public var mode: AddMode? = nil
            public var newLine: Bool? = nil
            public var tags: [String]? = nil
            public var excludeTrashed: Bool? = nil
            public var openNote: Bool? = nil
            public var newWindow: Bool? = nil
            public var showWindow: Bool? = nil
            public var edit: Bool? = nil
            public var timestamp: Bool? = nil
        }

        public struct Output: Codable {
            public let note: String
            public let title: String
        }
    }


    //MARK:- Add File

    struct AddFile: Action {
        public struct Input: Codable {
            public var id: String?
            public var title: String?
            public var file: Data
            public var header: String? = nil
            public var filename: String
            public var mode: AddMode? = nil
            public var openNote: Bool? = nil
            public var newWindow: Bool? = nil
            public var showWindow: Bool? = nil
            public var edit: Bool? = nil
        }

        public struct Output: Codable {
            public let note: String
        }
    }


    //MARK:- Tags

    struct Tags: Action {
        public struct Input: Codable {
            public var token: String
        }

        public typealias Output = [String]
    }


    //MARK:- Open Tag

    struct OpenTag: Action {
        public struct Input: Codable {
            public var name: String
            public var token: String?
        }

        public typealias Output = [Note]
    }


    //MARK:- Rename Tag

    struct RenameTag: Action {
        public struct Input: Codable {
            public var name: String
            public var newName: String
            public var showWindow: Bool? = nil
        }

        public typealias Output = [Note]
    }


    //MARK:- Delete Tag

    struct DeleteTag: Action {
        public struct Input: Codable {
            public var name: String
            public var showWindow: Bool? = nil
        }

        public typealias Output = Never
    }


    //MARK:- Trash

    struct Trash: Action {
        public struct Input: Codable {
            public var id: String?
            public var search: String?
            public var showWindow: Bool? = nil
        }

        public typealias Output = Never
    }


    //MARK:- Archive

    struct Archive: Action {
        public struct Input: Codable {
            public var id: String?
            public var search: String?
            public var showWindow: Bool? = nil
        }

        public typealias Output = Never
    }


    //MARK:- Untagged

    struct Untagged: Action {
        public struct Input: Codable {
            public var search: String?
            public var showWindow: Bool? = nil
            public var token: String?
        }

        public typealias Output = [Note]
    }


    //MARK:- Todo

    struct Todo: Action {
        public struct Input: Codable {
            public var search: String?
            public var showWindow: Bool? = nil
            public var token: String?
        }

        public typealias Output = [Note]
    }


    //MARK:- Today

    struct Today: Action {
        public struct Input: Codable {
            public var search: String?
            public var showWindow: Bool? = nil
            public var token: String?
        }

        public typealias Output = [Note]
    }


    //MARK:- Locked

    struct Locked: Action {
        public struct Input: Codable {
            public var search: String?
            public var showWindow: Bool? = nil
        }

        public typealias Output = Never
    }


    //MARK:- Search

    struct Search: Action {
        public struct Input: Codable {
            public var search: String?
            public var tag: String? = nil
            public var showWindow: Bool? = nil
            public var token: String?
        }

        public typealias Output = [Note]
    }


    //MARK:- Grab URL

    struct GrabURL: Action {
        public struct Input: Codable {
            public var url: URL
            public var tags: [String]? = nil
            public var pin: Bool? = nil
            public var wait: Bool?
        }

        public struct Output: Codable {
            public let identifier: String
            public let title: String
        }
    }


    //MARK:- Change Theme

    struct ChangeTheme: Action {
        public struct Input: Codable {
            public var theme: Theme
            public var showWindow: Bool? = nil
        }

        public typealias Output = Never
    }


    //MARK:- Change Font

    struct ChangeFont: Action {
        public struct Input: Codable {
            public var font: Font
            public var showWindow: Bool? = nil
        }

        public typealias Output = Never
    }

}
