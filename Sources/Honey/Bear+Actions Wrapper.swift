//
//  Bear+Actions.swift
//  Honey
//
//  Created by Valentin Walter on 4/15/20.
//  
//
//  Abstract:
//
//

import Foundation
import Middleman

extension Bear {
    public typealias Handler<T> = (T) -> Void
    public typealias SuccessHandler<A> = Handler<A.Output> where A: Action
    public typealias ErrorHandler = () -> Void

    public struct Options: OptionSet {
        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let openNote       = Options(rawValue: 1 << 0)
        public static let newWindow      = Options(rawValue: 1 << 1)
        public static let float          = Options(rawValue: 1 << 2)
        public static let showWindow     = Options(rawValue: 1 << 3)
        public static let excludeTrashed = Options(rawValue: 1 << 4)
        public static let pin            = Options(rawValue: 1 << 5)
        public static let edit           = Options(rawValue: 1 << 6)
        public static let timestamp      = Options(rawValue: 1 << 7)
    }
}

extension Bear {

    //MARK:- Create

    public static func create(
        note: Note,
        tags: [String] = [],
        file: File? = nil,
        options: Options = [.showWindow, .openNote],
        onError handleError: @escaping ErrorHandler = { },
        onSuccess handleSuccess: @escaping SuccessHandler<Create> = { _ in }
    ) {
        Bear().run(
            action: Create(),
            with: .init(
                title: note.title,
                text: note.body,
                tags: tags,
                file: file?.data.base64EncodedString(),
                filename: file?.name,
                openNote: options.contains(.openNote),
                newWindow: options.contains(.newWindow),
                showWindow: options.contains(.showWindow),
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


    //MARK:- Open

    public static func open(
        note: Note.Lookup,
        at header: String? = nil,
        options: Options = [.showWindow],
        onError handleError: @escaping ErrorHandler = { },
        onSuccess handleSuccess: @escaping SuccessHandler<OpenNote> = { _ in }
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
                showWindow: options.contains(.showWindow),
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


    //MARK:- Read

    public static func read(
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

    public static func addText(
        note lookup: Note.Lookup,
        text: String,
        header: String? = nil,
        mode: AddMode,
        tags: [String] = [],
        options: Options = [],
        onError handleError: @escaping ErrorHandler = { },
        onSuccess handleSuccess: @escaping SuccessHandler<AddText> = { _ in }
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
                openNote: options.contains(.openNote),
                newWindow: options.contains(.newWindow),
                showWindow: options.contains(.showWindow),
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


    //MARK:- Modify

//    public static func modify<T: NoteConvertible>(
//        note lookup: Note.Lookup,
//        with modify: @escaping (T) -> T,
//        options: Options = []
//    ) {
//        Bear.read(
//            note: lookup,
//            then: { note in
//                // Backup
//                print(note.markdown)
//
//                let note = modify(T(markdown: note.markdown))
//                Bear.addText(
//                    note: lookup,
//                    text: note.markdown,
//                    mode: .replaceAll,
//                    options: options
//                )
//            }
//        )
//    }
}

public protocol NoteConvertible {
    var markdown: String { get }
    init(markdown: String)
}
