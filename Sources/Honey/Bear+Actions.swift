//
//  Actions.swift
//  Honey
//
//  Created by Valentin Walter on 4/15/20.
//
//  Backend implementation of all actions found on
//  https://bear.app/faq/X-callback-url%20Scheme%20documentation/
//

import Foundation
import Middleman

public extension Bear {

    //MARK:- Open Note

    struct OpenNote: Action {
        public struct Input: Codable {
            public var id: String?
            public var title: String?
            public var header: String? = nil
            public var excludeTrashed: Bool? = nil
            public var newWindow: Bool? = nil
            public var float: Bool? = nil
            public var showWindow: Bool? = nil
			public var openNote: Bool? = nil
			public var selected: Bool? = nil
            public var pin: Bool? = nil
            public var edit: Bool? = nil
			public var token: String? = nil
        }

        public struct Output: Codable {
            public let note: String
            public let id: String
            public let title: String
			public let tags: [Tag]
            public let isTrashed: Bool
            public let modificationDate: Date
            public let creationDate: Date
        }
    }


    //MARK:- Create

    struct Create: Action {
        public struct Input: Codable {
            public var title: String?
            public var text: String?
			public var clipboard: Bool? = nil
            public var tags: [Tag]? = nil
            public var file: Data? = nil
            public var filename: String? = nil
            public var openNote: Bool? = nil
            public var newWindow: Bool? = nil
			public var float: Bool? = nil
            public var showWindow: Bool? = nil
            public var pin: Bool? = nil
            public var edit: Bool? = nil
            public var timestamp: Bool? = nil
			public var type: String? = nil
			public var url: String? = nil
        }

        public struct Output: Codable {
            public let id: String
            public let title: String
        }
    }


    //MARK:- Add Text

    struct AddText: Action {
        public struct Input: Codable {
            public var id: String?
            public var title: String?
			public var selected: Bool? = nil
            public var text: String?
            public var header: String? = nil
            public var mode: AddMode? = nil
            public var newLine: Bool? = nil
            public var tags: [Tag]? = nil
            public var excludeTrashed: Bool? = nil
            public var openNote: Bool? = nil
            public var newWindow: Bool? = nil
            public var showWindow: Bool? = nil
            public var edit: Bool? = nil
            public var timestamp: Bool? = nil
			public var token: String? = nil
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
			public var selected: Bool? = nil
            public var file: Data
            public var header: String? = nil
            public var filename: String
            public var mode: AddMode? = nil
            public var openNote: Bool? = nil
            public var newWindow: Bool? = nil
            public var showWindow: Bool? = nil
            public var edit: Bool? = nil
			public var token: String? = nil
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

        public typealias Output = [Tag]
    }


    //MARK:- Open Tag

    struct OpenTag: Action {
        public struct Input: Codable {
            public var name: [Tag]
            public var token: String?
        }

        public typealias Output = [Note]
    }


    //MARK:- Rename Tag

    struct RenameTag: Action {
        public struct Input: Codable {
            public var name: Tag
            public var newName: String
            public var showWindow: Bool? = nil
        }

        public typealias Output = Never
    }


    //MARK:- Delete Tag

    struct DeleteTag: Action {
        public struct Input: Codable {
            public var name: Tag
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
            public var term: String?
            public var tag: Tag? = nil
            public var showWindow: Bool? = nil
            public var token: String?
        }

        public typealias Output = [Note]
    }


    //MARK:- Grab URL

    struct GrabURL: Action {
        public struct Input: Codable {
            public var url: URL
            public var tags: [Tag]? = nil
            public var pin: Bool? = nil
            public var wait: Bool?
        }

        public struct Output: Codable {
            public let id: String
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
