//
//  Bear+Options.swift
//  Honey
//
//  Created by Valentin Walter on 5/23/21.
//

import Foundation

public struct Options: OptionSet {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	/// Don't show the note.
	public static let hideNote       = Options(rawValue: 1 << 0)
	/// Open a new window.
	public static let newWindow      = Options(rawValue: 1 << 1)
	/// Make the new window float (contingent on `newWindow`).
	public static let float          = Options(rawValue: 1 << 2)
	/// Don't show Bear's window.
	public static let hideWindow     = Options(rawValue: 1 << 3)
	/// Exclude notes in the trash from the action.
	public static let excludeTrashed = Options(rawValue: 1 << 4)
	/// Pin the note.
	public static let pin            = Options(rawValue: 1 << 5)
	/// Place a cursor inside the note.
	public static let edit           = Options(rawValue: 1 << 6)
	/// Append the current date and time at the end of the note.
	public static let timestamp      = Options(rawValue: 1 << 7)
}
