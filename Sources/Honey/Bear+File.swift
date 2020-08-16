//
//  Bear+File.swift
//  Honey
//
//  Created by Valentin Walter on 5/23/20.
//  
//
//  Abstract:
//
//

import Foundation

public extension Bear {

    struct File {
        public let name: String
        public let data: Data

        public init(name: String, data: Data) {
            self.name = name
            self.data = data
        }
    }

}
