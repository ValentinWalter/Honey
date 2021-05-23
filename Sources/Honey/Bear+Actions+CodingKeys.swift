//
//  Bear+Actions+CodingKeys.swift
//  Honey
//
//  Created by Valentin Walter on 5/23/21.
//

import Foundation

//MARK:- Open Note

extension Bear.OpenNote.Output {
	enum CodingKeys: String, CodingKey {
		case note
		case id = "identifier"
		case title
		case tags
		case isTrashed
		case modificationDate
		case creationDate
	}
}


//MARK:- Create

extension Bear.Create.Output {
	enum CodingKeys: String, CodingKey {
		case id = "identifier"
		case title
	}
}


//MARK:- Grab URL

extension Bear.GrabURL.Output {
	enum CodingKeys: String, CodingKey {
		case id = "identifier"
		case title
	}
}
