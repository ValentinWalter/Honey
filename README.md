# 🍯 Honey
**A Swift API for interacting with Bear.** If it's on [Bear's documentation](https://bear.app/faq/X-callback-url%20Scheme%20documentation/), Honey can do it. Honey is based on [Middleman](https://github.com/ValentinWalter/Middleman/tree/pre-release).

| Action | Implemented as |
|:--|:--|
| /open-note | `open(note:)` |
| /create | `create(note:)` |
| /add-text | `addText()` |
| /add-file | `addFile()` |
| /tags | `allTags()` |
| /open-tag | `open(tag:)` |
| /rename-tag | `rename(tag:)` |
| /delete-tag | `delete(tag:)` |
| /trash | `trash()` |
| /archive | `archive()` |
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
* `open(tab:)` Opens one of Bear's tabs, eg. Untagged/Locked/Trash…

## Create notes
Let's create a shopping list.

```swift
let note = Note(
    title: "🛍 Shopping list",
    body: """
    - 🍎 Apples
    - 🥣 Cereal	
    """
}
	
Bear.create(
    note: note,
    options: [
        .showWindow, 
        .openNote,
        .pin
        ]
} { shoppingList in
    // We forgot cheese!
    Bear.addText(
        note: .id(shoppingList),
        text: "- 🧀 Cheese",
        mode: .append
    }
}
```

## Work with notes
```swift
Bear.open(note: .id("9ASG...JA2FJ", at: "Header")

Bear.read(note: .title("🛍 Shopping list") { note in
    print(note.body)
    print(note.id)
}
```

## Add files
```swift
let url = URL(string: "https://apod.nasa.gov/apod/ap210515.html")!
let data = Data(contentsOf: url)!
let image = Bear.File(name: "Saturn", data: data)

Bear.addFile(
    note: .title("🪐 Daily astronomy pictures"),
    file: image,
    header: "Sat May 15",
    mode: .prepend
)
```
