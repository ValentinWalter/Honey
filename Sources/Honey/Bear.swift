//
//  Bear.swift
//  
//  Created by Valentin Walter on 4/13/20.
//
///  # Abstract
///  Namespace for actions such as `Bear.create`.
///  Actions are declared in `Bear+Actions.swift`.
//

import Foundation
import Middleman

/// Namespace for all actions.
///
/// Create new notes like this:
///
///     Bear.create(
///         title: "Title",
///         body: "..."
///     )
///
///
public struct Bear: App {
    /// Bear's API token
    ///
    /// Learn more at about [API Token Generation](https://bear.app/faq/X-callback-url%20Scheme%20documentation/#token-generation).
    public static var token: String? = nil
}
