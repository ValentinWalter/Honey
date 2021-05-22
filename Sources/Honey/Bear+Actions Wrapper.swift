//
//  Bear+Actions.swift
//  Honey
//
//  Created by Valentin Walter on 4/15/20.
//  
//  Frontend declarations of all `Bear.Actions`.
//

import Foundation
import Middleman

extension Bear {
    public typealias Handler<T> = (T) -> Void
    public typealias SuccessHandler<A> = Handler<A.Output> where A: Action
    public typealias Closure = () -> Void
	
    public struct Options: OptionSet {
        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let hideNote       = Options(rawValue: 1 << 0)
        public static let newWindow      = Options(rawValue: 1 << 1)
        public static let float          = Options(rawValue: 1 << 2)
        public static let hideWindow     = Options(rawValue: 1 << 3)
        public static let excludeTrashed = Options(rawValue: 1 << 4)
        public static let pin            = Options(rawValue: 1 << 5)
        public static let edit           = Options(rawValue: 1 << 6)
		public static let timestamp      = Options(rawValue: 1 << 7)
    }
}

public extension Bear {

    //MARK:- Create

	static func create(
        note: Note,
        tags: [String] = [],
        file: File? = nil,
        options: Options = [],
		onSuccess handleSuccess: @escaping SuccessHandler<Create> = { _ in },
		onError handleError: @escaping Closure = { }
    ) {
        Bear().run(
            action: Create(),
            with: .init(
                title: note.title,
                text: note.body,
                tags: tags,
                file: file?.data,
                filename: file?.name,
                openNote: !options.contains(.hideNote),
                newWindow: options.contains(.newWindow),
                showWindow: !options.contains(.hideWindow),
                pin: options.contains(.pin),
                edit: options.contains(.edit),
                timestamp: options.contains(.timestamp)
            ),
            then: { response in
                switch response {
                case .success(let output):
                    guard let output = output else {
                        handleError()
                        return
                    }
                    handleSuccess(output)
                case .error(_, _): handleError()
                case .cancel: handleError()
                }
            }
        )
    }
	
	static func create(
		note: Note,
		tags: [String] = [],
		file: File? = nil,
		options: Options = [],
		onSuccess handleSuccess: @escaping SuccessHandler<Create>
	) {
		Bear.create(
			note: note,
			tags: tags,
			file: file,
			options: options,
			onSuccess: handleSuccess,
			onError: { }
		)
	}


    //MARK:- Open

	static func open(
        note: Note.Lookup,
        at header: String? = nil,
        options: Options = [],
		onSuccess handleSuccess: @escaping SuccessHandler<OpenNote> = { _ in },
        onError handleError: @escaping Closure = { }
    ) {
        Bear().run(
            action: OpenNote(),
            with: .init(
                id: note.id,
                title: note.title,
                header: header,
                excludeTrashed: options.contains(.excludeTrashed),
                newWindow: options.contains(.newWindow),
                openNote: true,
                float: options.contains(.float),
                showWindow: !options.contains(.hideWindow),
                pin: options.contains(.pin),
                edit: options.contains(.edit)
            ),
            then: { response in
                switch response {
                case .success(let output):
                    guard let output = output else {
                        handleError()
                        return
                    }
                    handleSuccess(output)
                case .error(_, _): handleError()
                case .cancel: handleError()
                }
            }
        )
    }

	static func open(
		note: Note.Lookup,
		at header: String? = nil,
		options: Options = [],
		onSuccess handleSuccess: @escaping SuccessHandler<OpenNote>
	) {
		Bear.open(
			note: note,
			at: header,
			options: options,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	

    //MARK:- Read

	static func read(
        note lookup: Note.Lookup,
        excludeTrashed: Bool = false,
        then handler: @escaping Handler<Note>
    ) {
        Bear().run(
            action: OpenNote(),
            with: .init(
                id: lookup.id,
                title: lookup.title,
                header: nil,
                excludeTrashed: excludeTrashed,
                newWindow: false,
                openNote: false,
                float: false,
                showWindow: false,
                pin: false,
                edit: false
            ),
            then: { response in
                switch response {
                case .success(let output):
                    guard let output = output else { return }
                    handler(.init(from: output))
                case .error(_, _): break
                case .cancel: break
                }
            }
        )
    }


    //MARK:- Add Text

	static func addText(
        note lookup: Note.Lookup,
        text: String,
		at header: String? = nil,
        mode: AddMode,
        tags: [String] = [],
		options: Options = [.hideNote, .hideWindow],
		onSuccess handleSuccess: @escaping SuccessHandler<AddText> = { _ in },
        onError handleError: @escaping Closure = { }
    ) {
        Bear().run(
            action: AddText(),
            with: .init(
                id: lookup.id,
                title: lookup.title,
                text: text,
                header: header,
                mode: mode,
                newLine: false,
                tags: tags,
                excludeTrashed: options.contains(.excludeTrashed),
                openNote: !options.contains(.hideNote),
                newWindow: options.contains(.newWindow),
                showWindow: !options.contains(.hideWindow),
                edit: options.contains(.edit),
                timestamp: options.contains(.timestamp)
            ),
            then: { response in
                switch response {
                case .success(let output):
                    guard let output = output else {
                        handleError()
                        return
                    }
                    handleSuccess(output)
                case .error(_, _): handleError()
                case .cancel: handleError()
                }
            }
        )
    }
	
	static func addText(
		note lookup: Note.Lookup,
		text: String,
		at header: String? = nil,
		mode: AddMode,
		tags: [String] = [],
		options: Options = [.hideNote, .hideWindow],
		onSuccess handleSuccess: @escaping SuccessHandler<AddText>
	) {
		Bear.addText(
			note: lookup,
			text: text,
			at: header,
			mode: mode,
			tags: tags,
			options: options,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
    
    
    //MARK:- Add File

	static func addFile(
        note lookup: Note.Lookup,
        file: File,
        at header: String? = nil,
        mode: AddMode,
		options: Options = [.hideNote, .hideWindow],
		onSuccess handleSuccess: @escaping SuccessHandler<AddFile> = { _ in },
        onError handleError: @escaping Closure = { }
    ) {
        Bear().run(
            action: AddFile(),
            with: AddFile.Input(
                id: lookup.id,
                title: lookup.title,
                file: file.data,
                header: header,
                filename: file.name,
                mode: mode,
                openNote: !options.contains(.hideNote),
                newWindow: options.contains(.newWindow),
                showWindow: !options.contains(.hideWindow),
                edit: options.contains(.edit)
            ),
            then: { response in
                switch response {
                case .success(let output):
                    guard let output = output else {
                        handleError()
                        return
                    }
                    handleSuccess(output)
                case .error(_, _): handleError()
                case .cancel: handleError()
                }
            }
        )
    }
	
	static func addFile(
		note lookup: Note.Lookup,
		file: File,
		at header: String? = nil,
		mode: AddMode,
		options: Options = [.hideNote, .hideWindow],
		onSuccess handleSuccess: @escaping SuccessHandler<AddFile>
	) {
		Bear.addFile(
			note: lookup,
			file: file,
			at: header,
			mode: mode,
			options: options,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Get Tags
	
	static func getTags(
		onSuccess handleSuccess: @escaping SuccessHandler<Tags>
	) {
		guard let token = token else {
			fatalError("""
			⛔️ `getTags` requires a token to be present.
			ℹ️ Provide your Bear API token via `Bear.token = "..."`
			""")
		}
		
		Bear().run(
			action: Tags(),
			with: .init(token: token),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						return
					}
					handleSuccess(output)
				case .error(_, _): break
				case .cancel: break
				}
			}
		)
	}
	
	
	//MARK:- Open Tag
	
	static func open(
		tag: String,
		onSuccess handleSuccess: @escaping SuccessHandler<OpenTag> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		guard let token = token else {
			fatalError("""
			⛔️ `openTag` requires a token to be present.
			ℹ️ Provide your Bear API token via `Bear.token = "..."`
			""")
		}
		
		Bear().run(
			action: OpenTag(),
			with: .init(
				name: tag,
				token: token
			),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						handleError()
						return
					}
					handleSuccess(output)
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func open(
		tag: String,
		onSuccess handleSuccess: @escaping SuccessHandler<OpenTag>
	) {
		Bear.open(
			tag: tag,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Rename Tag
	
	static func rename(
		tag: String,
		to newName: String,
		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping SuccessHandler<RenameTag> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: RenameTag(),
			with: .init(
				name: tag,
				newName: newName,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						handleError()
						return
					}
					handleSuccess(output)
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func rename(
		tag: String,
		to newName: String,
		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping SuccessHandler<RenameTag>
	) {
		Bear.rename(
			tag: tag,
			to: newName,
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Delete Tag
	
	static func delete(
		tag: String,
 		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping SuccessHandler<DeleteTag> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: DeleteTag(),
			with: .init(
				name: tag,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						handleError()
						return
					}
					handleSuccess(output)
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func delete(
		tag: String,
		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping SuccessHandler<DeleteTag>
	) {
		Bear.delete(
			tag: tag,
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Trash
	
	static func trash(
		id: String,
		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping Closure = { },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Trash(),
			with: .init(
				id: id,
				search: nil,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success: handleSuccess()
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func trash(
		id: String,
		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping Closure
	) {
		Bear.trash(
			id: id,
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	static func searchTrash(
		for query: String,
		onSuccess handleSuccess: @escaping Closure = { },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Trash(),
			with: .init(
				id: nil,
				search: query,
				showWindow: false
			),
			then: { response in
				switch response {
				case .success: handleSuccess()
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func searchTrash(
		for query: String,
		onSuccess handleSuccess: @escaping Closure = { }
	) {
		Bear.searchTrash(
			for: query,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Archive
	
	static func archive(
		id: String,
		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping Closure = { },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Archive(),
			with: .init(
				id: id,
				search: nil,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success: handleSuccess()
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func archive(
		id: String,
		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping Closure
	) {
		Bear.archive(
			id: id,
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	static func searchArchive(
		for query: String,
		onSuccess handleSuccess: @escaping Closure = { },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Archive(),
			with: .init(
				id: nil,
				search: query,
				showWindow: false
			),
			then: { response in
				switch response {
				case .success: handleSuccess()
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func searchArchive(
		for query: String,
		onSuccess handleSuccess: @escaping Closure = { }
	) {
		Bear.searchArchive(
			for: query,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Untagged
	
	static func allUntagged(
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Untagged> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Untagged(),
			with: .init(
				search: nil,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						handleError()
						return
					}
					handleSuccess(output)
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func allUntagged(
		for query: String,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Today>
	) {
		Bear.allUntagged(
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	static func searchUntagged(
		for query: String,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Untagged> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Untagged(),
			with: .init(
				search: query,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						handleError()
						return
					}
					handleSuccess(output)
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func searchUntagged(
		for query: String,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Today>
	) {
		Bear.searchUntagged(
			for: query,
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Todo
	
	static func allTodos(
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Todo> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Todo(),
			with: .init(
				search: nil,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						handleError()
						return
					}
					handleSuccess(output)
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func allTodos(
		for query: String,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Today>
	) {
		Bear.allTodos(
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	static func searchTodos(
		for query: String,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Todo> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Todo(),
			with: .init(
				search: query,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						handleError()
						return
					}
					handleSuccess(output)
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func searchTodos(
		for query: String,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Today>
	) {
		Bear.searchTodos(
			for: query,
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Today
	
	static func allToday(
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Today> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Today(),
			with: .init(
				search: nil,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						handleError()
						return
					}
					handleSuccess(output)
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func allToday(
		for query: String,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Today>
	) {
		Bear.allToday(
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	static func searchToday(
		for query: String,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Today> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Today(),
			with: .init(
				search: query,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						handleError()
						return
					}
					handleSuccess(output)
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func searchToday(
		for query: String,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Today>
	) {
		Bear.searchToday(
			for: query,
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Locked

	static func searchLocked(
		for query: String,
		onSuccess handleSuccess: @escaping Closure = { },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Locked(),
			with: .init(
				search: query,
				showWindow: false
			),
			then: { response in
				switch response {
				case .success: handleSuccess()
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	func searchLocked(
		for query: String,
		onSuccess handleSuccess: @escaping Closure
	) {
		Bear.searchLocked(
			for: query,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Search

	static func search(
		for query: String,
		in tag: String,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Search> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		guard let token = token else {
			fatalError("""
			⛔️ `search` requires a token to be present.
			ℹ️ Provide your Bear API token via `Bear.token = "..."`
			""")
		}
		
		Bear().run(
			action: Search(),
			with: .init(
				search: query,
				tag: tag,
				showWindow: showWindow,
				token: token
			),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						handleError()
						return
					}
					handleSuccess(output)
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func search(
		for query: String,
		in tag: String,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Search>
	) {
		Bear.search(
			for: query,
			in: tag,
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Grab URL
	
	// wait: false
	static func create(
		from url: URL,
		tags: [String],
		pin: Bool = false,
		onSuccess handleSuccess: @escaping Closure = { },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: GrabURL(),
			with: .init(
				url: url,
				tags: tags,
				pin: pin,
				wait: false
			),
			then: { response in
				switch response {
				case .success: handleSuccess()
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func create(
		from url: URL,
		tags: [String],
		pin: Bool = false,
		onSuccess handleSuccess: @escaping Closure
	) {
		Bear.create(
			from: url,
			tags: tags,
			pin: pin,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	// wait: true
	static func create(
		from url: URL,
		tags: [String],
		pin: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<GrabURL> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: GrabURL(),
			with: .init(
				url: url,
				tags: tags,
				pin: pin,
				wait: true
			),
			then: { response in
				switch response {
				case .success(let output):
					guard let output = output else {
						handleError()
						return
					}
					handleSuccess(output)
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func create(
		from url: URL,
		tags: [String],
		pin: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<GrabURL>
	) {
		Bear.create(
			from: url,
			tags: tags,
			pin: pin,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Change Theme
	
	static func change(
		theme: Theme,
		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping Closure = { },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: ChangeTheme(),
			with: .init(
				theme: theme,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success: handleSuccess()
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func change(
		theme: Theme,
		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping Closure
	) {
		Bear.change(
			theme: theme,
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Change Font
	
	static func change(
		font: Font,
		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping Closure = { },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: ChangeFont(),
			with: .init(
				font: font,
				showWindow: showWindow
			),
			then: { response in
				switch response {
				case .success: handleSuccess()
				case .error(_, _): handleError()
				case .cancel: handleError()
				}
			}
		)
	}
	
	static func change(
		font: Font,
		showWindow: Bool = true,
		onSuccess handleSuccess: @escaping Closure
	) {
		Bear.change(
			font: font,
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
}
