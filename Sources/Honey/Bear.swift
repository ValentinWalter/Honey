//
//  Bear.swift
//  Honey
//  
//  Created by Valentin Walter on 4/13/20.
//
//  Namespace for actions such as `Bear.create`.
//  Actions are declared in `Bear+Actions.swift`.
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
    /// Your Bear API token. You can either set this directly or provide an
	/// environment variable called `BEAR_API_TOKEN` via
	/// `Edit scheme… > Run > Arguments > Environment Variables`.
    ///
    /// Learn more at about [API Token Generation](https://bear.app/faq/X-callback-url%20Scheme%20documentation/#token-generation).
	public static var token: String? = {
		if let token = ProcessInfo.processInfo.environment["BEAR_API_TOKEN"] {
			return token
		} else {
			return nil
		}
	}()
}
