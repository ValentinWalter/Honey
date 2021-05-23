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
	
	/// Used to assert `Bear.token` is not `nil`.
	/// - Parameter action: The name of the action for logging purposes.
	/// - Returns: The API token.
	@discardableResult
	fileprivate static func assertToken(in action: String) -> String {
		guard let token = token else {
			fatalError("""
			⛔️ `\(action)` requires a token to be present.
			ℹ️ Provide your Bear API token via `Bear.token = "..."`
			""")
		}
		
		return token
	}
}

public extension Bear {

    //MARK:- Create
	
	/// Creates a note and returns its content and ID. Set `title`, `body` and
	/// `tags` via the `note`-parameter.
	/// - Parameters:
	///   - note: The note's contents.
	///   - file: A `File` to be included in your note.
	///   - options: Various options to further customize Bear's specific
	///              behavior during creation.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func create(
        _ note: Note,
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
				tags: note.tags,
                file: file?.data,
                filename: file?.name,
                openNote: !options.contains(.hideNote),
                newWindow: options.contains(.newWindow),
                showWindow: !options.contains(.hideWindow),
				pin: note.isPinned ?? false || options.contains(.pin),
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
	
	/// Creates a note and returns its content and ID. Set `title`, `body` and
	/// `tags` via the `note`-parameter.
	/// - Parameters:
	///   - note: The note's contents.
	///   - tags: Any tags you want your note to have.
	///   - file: A `File` to be included in your note.
	///   - options: Various options to further customize Bear's specific
	///              behavior during creation.
	///   - handleSuccess: A closure called on success with the output of this action.
	static func create(
		note: Note,
		tags: [Tag] = [],
		file: File? = nil,
		options: Options = [],
		onSuccess handleSuccess: @escaping SuccessHandler<Create>
	) {
		Bear.create(
			note,
			file: file,
			options: options,
			onSuccess: handleSuccess,
			onError: { }
		)
	}


    //MARK:- Open
	
	/// Opens a note and returns its contents. You need to have set `Bear.token`
	/// when using `Note.Lookup.selected`.
	/// - Parameters:
	///   - note: The note you want to open.
	///   - header: Any header within the note to be scrolled to.
	///   - options: Various options to further customize Bear's specific
	///              behavior during the opening of the note.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func open(
        note: Note.Lookup,
        at header: String? = nil,
        options: Options = [],
		onSuccess handleSuccess: @escaping SuccessHandler<OpenNote> = { _ in },
        onError handleError: @escaping Closure = { }
    ) {
		if case .selected = note {
			assertToken(in: "open(note:)")
		}
		
        Bear().run(
            action: OpenNote(),
            with: .init(
                id: note.id,
                title: note.title,
                header: header,
                excludeTrashed: options.contains(.excludeTrashed),
                newWindow: options.contains(.newWindow),
				float: options.contains(.float),
				showWindow: !options.contains(.hideWindow),
                openNote: true,
				selected: note.selected,
                pin: options.contains(.pin),
                edit: options.contains(.edit),
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

	/// Opens a note and returns its contents.
	/// - Parameters:
	///   - note: The note you want to open.
	///   - header: Any header within the note to be scrolled to.
	///   - options: Various options to further customize Bear's specific
	///              behavior during the opening of the note.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Returns the contents of a note without opening it. You need to have set
	/// `Bear.token` when using `Note.Lookup.selected`.
	/// - Parameters:
	///   - note: The note you want to read.
	///   - excludeTrashed: Whether to exlude trashed notes.
	///   - handler: A closure with the contents of the note.
	static func read(
        note: Note.Lookup,
        excludeTrashed: Bool = false,
        then handler: @escaping Handler<Note>
    ) {
		if case .selected = note {
			assertToken(in: "read(note:)")
		}
		
        Bear().run(
            action: OpenNote(),
            with: .init(
                id: note.id,
                title: note.title,
                header: nil,
                excludeTrashed: excludeTrashed,
                newWindow: false,
				float: false,
				showWindow: false,
                openNote: false,
				selected: note.selected,
                pin: false,
                edit: false,
				token: token
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
	
	
	//MARK:- Pin
	
	/// Pins a note. You need to have set `Bear.token` when using `Note.Lookup.selected`.
	/// - Parameters:
	///   - note: The note to pin.
	///   - options: Various options to further customize Bear's specific
	///              behavior during the opening of the note.
	static func pin(
		note: Note.Lookup,
		options: Options = []
	) {
		if case .selected = note {
			assertToken(in: "pin(note:)")
		}
		
		Bear().run(
			action: OpenNote(),
			with: .init(
				id: note.id,
				title: note.title,
				header: nil,
				excludeTrashed: options.contains(.excludeTrashed),
				newWindow: options.contains(.newWindow),
				float: options.contains(.float),
				showWindow: !options.contains(.hideWindow),
				openNote: !options.contains(.hideNote),
				selected: note.selected,
				pin: true,
				edit: options.contains(.edit),
				token: token
			),
			then: nil
		)
	}
	
	
	//MARK:- Open Tab
	
	/// Opens a tab or tag in Bear's sidebar.
	/// - Parameter tab: The tab or tag to open.
	static func open(tab: Tab) {
		switch tab {
		case .all:
			Bear().run(action: Search(),   with: .init(showWindow: true), then: nil)
		case .untagged:
			Bear().run(action: Untagged(), with: .init(showWindow: true), then: nil)
		case .todo:
			Bear().run(action: Todo(),     with: .init(showWindow: true), then: nil)
		case .today:
			Bear().run(action: Today(),    with: .init(showWindow: true), then: nil)
		case .locked:
			Bear().run(action: Locked(),   with: .init(showWindow: true), then: nil)
		case .archive:
			Bear().run(action: Archive(),  with: .init(showWindow: true), then: nil)
		case .trash:
			Bear().run(action: Trash(),    with: .init(showWindow: true), then: nil)
		case .tag(let tag):
			Bear().run(action: OpenTag(),  with: .init(name: [Tag(tag)]), then: nil)
		}
	}


    //MARK:- Add Text
	
	/// Prepend, append or replace text within a note. You need to have set
	/// `Bear.token` when using `Note.Lookup.selected`.
	/// - Parameters:
	///   - text: The text you mean to add.
	///   - note: The note you want to modify.
	///   - header: Any header within the note.
	///   - mode: Prepend, append, replace all or replace (and keep title).
	///   - tags: Any tags you want to add to the note.
	///   - options: Various options to further customize Bear's specific
	///              behavior.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func add(
		text: String,
        to note: Note.Lookup,
		at header: String? = nil,
        mode: AddMode,
        tags: [Tag] = [],
		options: Options = [.hideNote, .hideWindow],
		onSuccess handleSuccess: @escaping SuccessHandler<AddText> = { _ in },
        onError handleError: @escaping Closure = { }
    ) {
		if case .selected = note {
			assertToken(in: "add(text:)")
		}
		
        Bear().run(
            action: AddText(),
            with: .init(
                id: note.id,
                title: note.title,
				selected: note.selected,
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
                timestamp: options.contains(.timestamp),
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
	
	/// Prepend, append or replace text within a note.
	/// - Parameters:
	///   - lookup: The note you want to modify.
	///   - text: The text you mean to add.
	///   - header: Any header within the note.
	///   - mode: Prepend, append, replace all or replace (and keep title).
	///   - tags: Any tags you want to add to the note.
	///   - options: Various options to further customize Bear's specific
	///              behavior.
	///   - handleSuccess: A closure called on success with the output of this action.
	static func add(
		text: String,
		to note: Note.Lookup,
		at header: String? = nil,
		mode: AddMode,
		tags: [Tag] = [],
		options: Options = [.hideNote, .hideWindow],
		onSuccess handleSuccess: @escaping SuccessHandler<AddText>
	) {
		Bear.add(
			text: text,
			to: note,
			at: header,
			mode: mode,
			tags: tags,
			options: options,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
    
    
    //MARK:- Add File
	
	/// Add files and images to notes. You need to have set `Bear.token` when
	/// using `Note.Lookup.selected`.
	/// - Parameters:
	///   - lookup: The note you want to add a file to.
	///   - file: The file you want to add.
	///   - header: The header under which to add the file.
	///   - mode: Prepend, append, replace all or replace (and keep title).
	///   - options: Various options to further customize Bear's specific
	///              behavior.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func add(
		file: File,
        to note: Note.Lookup,
        at header: String? = nil,
        mode: AddMode,
		options: Options = [.hideNote, .hideWindow],
		onSuccess handleSuccess: @escaping SuccessHandler<AddFile> = { _ in },
        onError handleError: @escaping Closure = { }
    ) {
		if case .selected = note {
			assertToken(in: "add(file:)")
		}
		
        Bear().run(
            action: AddFile(),
            with: AddFile.Input(
                id: note.id,
                title: note.title,
				selected: note.selected,
                file: file.data,
                header: header,
                filename: file.name,
                mode: mode,
                openNote: !options.contains(.hideNote),
                newWindow: options.contains(.newWindow),
                showWindow: !options.contains(.hideWindow),
                edit: options.contains(.edit),
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
	
	/// Add files and images to notes.
	/// - Parameters:
	///   - lookup: The note you want to add a file to.
	///   - file: The file you want to add.
	///   - header: The header under which to add the file.
	///   - mode: Prepend, append, replace all or replace (and keep title).
	///   - options: Various options to further customize Bear's specific
	///              behavior.
	///   - handleSuccess: A closure called on success with the output of this action.
	static func add(
		file: File,
		to note: Note.Lookup,
		at header: String? = nil,
		mode: AddMode,
		options: Options = [.hideNote, .hideWindow],
		onSuccess handleSuccess: @escaping SuccessHandler<AddFile>
	) {
		Bear.add(
			file: file,
			to: note,
			at: header,
			mode: mode,
			options: options,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- All Tags
	
	/// Get all tags in use. This action requires `Bear.token` to be present.
	/// - Parameter handleSuccess: A closure called on success with the output of this action.
	static func allTags(
		onSuccess handleSuccess: @escaping SuccessHandler<Tags>
	) {
		let token = assertToken(in: "allTags()")
		
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
	
	/// Open a specific tag. This action requires `Bear.token` to be present.
	/// If all you want to do is open a tag in Bear's sidebar, use `open(tab:)`.
	/// - Parameters:
	///   - tag: The tag you want to open.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func open(
		tags: [Tag],
		onSuccess handleSuccess: @escaping SuccessHandler<OpenTag> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		assertToken(in: "open(tags:)")
		
		Bear().run(
			action: OpenTag(),
			with: .init(
				name: tags,
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
	
	/// Open a specific tag. This action requires `Bear.token` to be present.
	/// If all you want to do is open a tag in Bear's sidebar, use `open(tab:)`.
	/// - Parameters:
	///   - tag: The tag you want to open.
	///   - handleSuccess: A closure called on success with the output of this action.
	static func open(
		tags: [Tag],
		onSuccess handleSuccess: @escaping SuccessHandler<OpenTag>
	) {
		Bear.open(
			tags: tags,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	
	//MARK:- Rename Tag
	
	/// Rename a tag.
	/// - Parameters:
	///   - tag: The tag to rename.
	///   - newName: The new name.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func rename(
		tag: Tag,
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
	
	/// Rename a tag.
	/// - Parameters:
	///   - tag: The tag to rename.
	///   - newName: The new name.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	static func rename(
		tag: Tag,
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
	
	/// Delete a tag.
	/// - Parameters:
	///   - tag: The tag to delete.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func delete(
		tag: Tag,
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
	
	/// Delete a tag.
	/// - Parameters:
	///   - tag: The tag to delete.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	static func delete(
		tag: Tag,
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
	
	/// Move a note to the trash.
	/// - Parameters:
	///   - id: The id of the note.
	///   - showWindow: Whether to show the window. Defaults to true.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
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
	
	/// Move a note to the trash.
	/// - Parameters:
	///   - id: The id of the note.
	///   - showWindow: Whether to show the window. Defaults to true.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Search the trash for notes.
	/// - Parameters:
	///   - query: The query to search for.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
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
	
	/// Search the trash for notes.
	/// - Parameters:
	///   - query: The query to search for.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Archive a note.
	/// - Parameters:
	///   - id: The id of the note.
	///   - showWindow: Whether to show the window. Defaults to true.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
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
	
	/// Archive a note.
	/// - Parameters:
	///   - id: The id of the note.
	///   - showWindow: Whether to show the window. Defaults to true.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Search the archive for notes.
	/// - Parameters:
	///   - query: The query to search for.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
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
	
	/// Search the archive for notes.
	/// - Parameters:
	///   - query: The query to search for.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Get all untagged notes. This action requires `Bear.token` to be present.
	/// If all you want to do is open the *Untagged* tab in Bear's sidebar,
	/// use `open(tab:)`.
	/// - Parameters:
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func allUntagged(
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Untagged> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		assertToken(in: "allUntagged()")
		
		Bear().run(
			action: Untagged(),
			with: .init(
				search: nil,
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
	
	/// Get all untagged notes. This action requires `Bear.token` to be present.
	/// If all you want to do is open the *Untagged* tab in Bear's sidebar,
	/// use `open(tab:)`.
	/// - Parameters:
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	static func allUntagged(
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Today>
	) {
		Bear.allUntagged(
			showWindow: showWindow,
			onSuccess: handleSuccess,
			onError: { }
		)
	}
	
	/// Search all untagged notes. You need to have set `Bear.token` if you want
	/// to receive search results.
	/// - Parameters:
	///   - query: The query to search for.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
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
	
	/// Search all untagged notes. You need to have set `Bear.token` if you want
	/// to receive search results.
	/// - Parameters:
	///   - query: The query to search for.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Get all notes with todo items. This action requires `Bear.token` to be
	/// present. If all you want to do is open the *Todo* tab in Bear's sidebar,
	/// use `open(tab:)`.
	/// - Parameters:
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func allTodos(
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Todo> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		assertToken(in: "allTodos()")
		
		Bear().run(
			action: Todo(),
			with: .init(
				search: nil,
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
	
	/// Get all notes with todo items. This action requires `Bear.token` to be
	/// present. If all you want to do is open the *Todo* tab in Bear's sidebar,
	/// use `open(tab:)`.
	/// - Parameters:
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Search all untagged notes. You need to have set `Bear.token` if you want
	/// to receive search results.
	/// - Parameters:
	///   - query: The query to search for.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
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
	
	/// Search all untagged notes. You need to have set `Bear.token` if you want
	/// to receive search results.
	/// - Parameters:
	///   - query: The query to search for.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Get all notes edited today. This action requires `Bear.token` to be
	/// present. If all you want to do is open the *Today* tab in Bear's
	/// sidebar, use `open(tab:)`.
	/// - Parameters:
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func allToday(
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Today> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		assertToken(in: "allToday()")
		
		Bear().run(
			action: Today(),
			with: .init(
				search: nil,
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
	
	/// Get all notes edited today. This action requires `Bear.token` to be
	/// present. If all you want to do is open the *Today* tab in Bear's
	/// sidebar, use `open(tab:)`.
	/// - Parameters:
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Search all untagged notes. You need to have set `Bear.token` if you want
	/// to receive search results.
	/// - Parameters:
	///   - query: The query to search for.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
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
	
	/// Search all untagged notes. You need to have set `Bear.token` if you want
	/// to receive search results.
	/// - Parameters:
	///   - query: The query to search for.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Search locked notes.
	/// - Parameters:
	///   - query: The query to search for.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
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
	
	/// Search locked notes.
	/// - Parameters:
	///   - query: The query to search for.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Search all notes. You need to have set `Bear.token` if you want to
	/// receive search results.
	/// - Parameters:
	///   - query: The query to search for.
	///   - tag: Any tag to filter search results.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func search(
		for query: String,
		in tag: Tag,
		showWindow: Bool = false,
		onSuccess handleSuccess: @escaping SuccessHandler<Search> = { _ in },
		onError handleError: @escaping Closure = { }
	) {
		Bear().run(
			action: Search(),
			with: .init(
				term: query,
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
	
	/// Search all notes. You need to have set `Bear.token` if you want to
	/// receive search results.
	/// - Parameters:
	///   - query: The query to search for.
	///   - tag: Any tag to filter search results.
	///   - showWindow: Whether to show the window.
	///   - handleSuccess: A closure called on success with the output of this action.
	static func search(
		for query: String,
		in tag: Tag,
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
	
	/// Create a note from a website. This action will return immediately.
	/// - Parameters:
	///   - url: The url of the website to fetch.
	///   - tags: Any tags to include in the note
	///   - pin: Whether to pin this note.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func create(
		from url: URL,
		tags: [Tag],
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
	
	/// Create a note from a website. This action will return immediately.
	/// - Parameters:
	///   - url: The url of the website to fetch.
	///   - tags: Any tags to include in the note
	///   - pin: Whether to pin this note.
	///   - handleSuccess: A closure called on success with the output of this action.
	static func create(
		from url: URL,
		tags: [Tag],
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
	
	/// Create a note from a website. This action will wait for the note to be
	/// created and returns the new note's content and id.
	/// - Parameters:
	///   - url: The url of the website to fetch.
	///   - tags: Any tags to include in the note
	///   - pin: Whether to pin this note.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
	static func create(
		from url: URL,
		tags: [Tag],
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
	
	/// Create a note from a website. This action will wait for the note to be
	/// created and returns the new note's content and id.
	/// - Parameters:
	///   - url: The url of the website to fetch.
	///   - tags: Any tags to include in the note
	///   - pin: Whether to pin this note.
	///   - handleSuccess: A closure called on success with the output of this action.
	static func create(
		from url: URL,
		tags: [Tag],
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
	
	/// Change Bear's theme.
	/// - Parameters:
	///   - theme: Which theme to change to.
	///   - showWindow: Whether to show the window. Defaults to true.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
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
	
	/// Change Bear's theme.
	/// - Parameters:
	///   - theme: Which theme to change to.
	///   - showWindow: Whether to show the window. Defaults to true.
	///   - handleSuccess: A closure called on success with the output of this action.
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
	
	/// Change Bear's font.
	/// - Parameters:
	///   - theme: Which font to change to.
	///   - showWindow: Whether to show the window. Defaults to true.
	///   - handleSuccess: A closure called on success with the output of this action.
	///   - handleError: A closure called on any error or cancelation.
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
	
	/// Change Bear's font.
	/// - Parameters:
	///   - theme: Which font to change to.
	///   - showWindow: Whether to show the window. Defaults to true.
	///   - handleSuccess: A closure called on success with the output of this action.
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
