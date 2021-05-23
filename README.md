# 🍯 Honey
**A Swift API for interacting with Bear.** If it's on [Bear's documentation](https://bear.app/faq/X-callback-url%20Scheme%20documentation/), Honey can do it.

Honey is based on [Middleman](https://github.com/ValentinWalter/Middleman/tree/pre-release), a completely type-safe way of handling the [x-callback-url](http://x-callback-url.com) scheme. `x-callback-url` can be a fickle thing to work with and Bear's API is not the most consistent: type-safety can go a long way in helping you work with this. Auto-complete will enable you to discover the API as you work with it. Honey also handles repetitive tasks, like passing Bear's API token where it's required.

- [Overview](#overview)
- [Installation](#installation)
- [Configuration](#configuration)
- [Actions](#actions)
- [Types](#types)

### Overview
| Action | Implemented as |
|:--|:--|
| /open-note | `open(note:)` |
| /create | `create(note:)` |
| /add-text | `add(text:)` |
| /add-file | `add(file:)` |
| /tags | `allTags()` |
| /open-tag | `open(tag:)` |
| /rename-tag | `rename(tag:)` |
| /delete-tag | `delete(tag:)` |
| /trash | `trash(id:)` |
| /archive | `archive(id:)` |
| /untagged | `allUntagged()` `searchUntagged()` |
| /todo | `allTodos()` `searchTodos()` |
| /today | `allToday()` `searchToday()` |
| /locked | `searchLocked()` |
| /search | `search(for:)` |
| /grab-url | `create(from:)` |
| /change-theme | `change(theme:)` |
| /change-font | `change(font:)` |

#### Extra goodies
* `read(note:)` Returns the content of a note without opening it.
* `open(tab:)` Opens one of Bear's tabs (Untagged/Locked/Trash, etc.) or any of your tags.
* `pin(note:)` Pins a note.

#### Next steps
* Implement a command-line interface using `apple/swift-argument-parser`
* Refactor. Right now the API is relatively close to Bear's documentation. For example, functions like the various `searchX` actions could be consolidated into one.
* Migrate from callbacks to `async` in Swift 6.
* Add tests

#### Example
Let's create a shopping list.

```swift
let note = Note(
    title: "🛍 Shopping list",
    body: """
    - 🍎 Apples
    - 🥣 Cereal	
    """
}
	
Bear.create(note, options: .pin) { shoppingList in
    // We forgot cheese!
    Bear.add(
        text: "- 🧀 Cheese",
        to: .id(shoppingList.id),
        mode: .append
    )
}
```

## Setup
### Installation
Honey is a Swift Package. Install it by pasting this in your `Package.swift`:
```Swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/ValentinWalter/honey.git", .branch("pre-release"))
    ],
    ...
)
```

### Configuration
Provide your API token if you plan on using any actions that require an API token. You do this directly by setting `Bear.token`. Or preferably with an environment variable called `BEAR_API_TOKEN`. In Xcode:
```
Edit scheme… > Run > Arguments > Environment Variables
```

# API
All actions and types Honey implements are namespaced under `Bear`. The general workflow is to type `Bear.` and choose your desired action from the auto-complete menu. All actions follow the same kind of structure:

```swift
// The full signature of most actions
Bear.action(parameter: value, ...) { output in
    ...
} onError: {
    ...
}

// Trailing closure syntax of most actions
// Unlabeled trailing closures always mean success
Bear.action(parameter: value, ...) { output in
    ...
}

// No closures syntax of most actions
// Most action's paramaters are optional, same with callbacks
Bear.action(parameter: value, ...)
```

## Actions
Here are some cool examples. You can find a full list of actions in the [overview](#overview).

#### Open
```swift
Bear.open(note: .id("9ASG...JA2FJ", at: "Header")

Bear.read(note: .title("🛍 Shopping list") { note in
    print(note.body)
    print(note.id)
}
```

#### Create
```swift
let note = Bear.Note(
    title: "Title",
    body: "body",
    tags: ["Tag"],
    isPinned: false
)

Bear.create(note) { note in
    print(note.id)
}
```

#### Add Text
```swift
Bear.add(
    text: "\(Date())",
    to: .selected,
    mode: .append
)
```

#### Add File
```swift
let url = URL(string: "https://apod.nasa.gov/apod/image/2105/M8_rim2geminicrop600.jpg")!
let data = Data(contentsOf: url)!
let image = Bear.File(name: "Saturn", data: data)

Bear.add(
    file: image,
    to: .title("🪐 Daily astronomy pictures"),
    at: "Sat May 15",
    mode: .prepend
)
```

#### Search
```swift
Bear.search(
    for: "important notes",
    in: "some tag"
) { notes in
    print(notes.map(\.title))
}
```

#### Change Theme & Font
```swift
Bear.change(theme: .oliveDunk)
Bear.change(font: .avenirNext)
```

## Types
Honey implements various concepts of Bear's API as types in Swift.

#### Note
A `Note` is used to create and read notes.
```swift
// Create notes for the create(_:) action
let note = Bear.Note(
    title: "A Title",
    body: "A paragraph...",
    tags: ["A", "few", "tags"],
    isPinned: false
)

// Or when you received a note via the output of an action
note.modificationDate
note.creationDate
note.id
```

#### Note.Lookup
You use this enum to find already existing notes.
```swift
case title(String)
case id(String)
case selected // requires an API token

// Use like this
Bear.open(note: .title("🛍 Shopping list"))
Bear.read(note: .id("9ASG...JA2FJ"))
Bear.add(text: "...", note: .selected)
```

You can get extra fancy by using `Note.Lookup` as namespace for notes you access often.
```swift
extension Bear.Note.Lookup {
    static let home: Self = .title("🏡 Home")
    
    // Or better yet, use an ID namespaced in Bear
    static let journal: Self = .id(Bear.journalID)
}

extension Bear {
    static let journalID = "E3F...2A8"
}

// You can now do this 🥳
Bear.open(note: .home)
Bear.read(note: .journal)
```

#### Tag
`Tag` behaves the same way a usual `String` does. Similar to `Note.Lookup` you can use this type to namespace your frequently used tags.

```swift
extension Tag {
    static let work: Self = "👾 Work"
}
```
#### File
When dealing with files in either `create(_:)` or `add(file:)`, the `File` type comes in handy.
```swift
let url = URL(string: "https://apod.nasa.gov/apod/image/2105/M8_rim2geminicrop600.jpg")!
let data = Data(contentsOf: url)!

let file = Bear.File(
    name: "The Southern Cliff in the Lagoon", 
    data: data
)
```

#### Tab, Theme, Font
```swift
// Tab lets you open tabs or tags from Bear's sidebar via open(tab:)
case all
case untagged
case ...
case trash
case tag(String)

// Theme lets you change themes via change(theme:)
case redGraphite
case ...
case lighthouse

// Font lets you change fonts via change(font:)
case avenirNext
case ...    
case openDyslexic
```