//
//  Bear+Tab.swift
//  Honey
//
//  Created by Valentin Walter on 5/23/21.
//

import Foundation

extension Bear {
	public enum Tab {
		case all
		case untagged
		case todo
		case today
		case locked
		case archive
		case trash
		case tag(String)
	}
}
