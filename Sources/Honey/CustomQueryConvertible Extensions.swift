//
//  CustomQueryConvertible Extensions.swift
//  Honey
//
//  Created by Valentin Walter on 4/21/20.
//  
//
//  Abstract:
//
//

import Foundation
import Middleman

extension Bool: CustomQueryConvertible {
    public var queryValue: String? {
        self ? "yes" : "no"
    }
}

extension Array: CustomQueryConvertible where Element: CustomStringConvertible {
    public var queryValue: String? {
        if isEmpty {
            return nil
        } else {
            return self
                .map(\.description)
                .joined(separator: ",")
        }
    }
}

extension Data: CustomQueryConvertible {
    public var queryValue: String? {
        base64EncodedString()
    }
}
