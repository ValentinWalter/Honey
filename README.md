# Honey
A Swift API for interacting with Bear. If it's on [Bear's documentation](https://bear.app/faq/X-callback-url%20Scheme%20documentation/), Honey can do it.

> Based on [Middleman](https://github.com/ValentinWalter/Middleman/tree/pre-release).

| Action | App API | Middleman API |
|:--|:--|:--|
| /open-note | ✅ | ✅ |
| /create | ✅ | ✅ |
| /add-text | ✅ | ✅ |
| /add-file | ✅ | ✅ |
| /tags | ❌ | ✅ |
| /open-tag | ❌ | ✅ |
| /rename-tag | ❌ | ✅ |
| /delete-tag | ❌ | ✅ |
| /trash | ❌ | ✅ |
| /archive | ❌ | ✅ |
| /untagged | ❌ | ✅ |
| /todo | ❌ | ✅ |
| /today | ❌ | ✅ |
| /locked | ❌ | ✅ |
| /search | ❌ | ✅ |
| /grab-url | ❌ | ✅ |
| /change-theme | ❌ | ✅ |
| /change-font | ❌ |✅  |

***App API** refers to the convenience functions you can see below. **Middleman API** is the low-level implementation that is more verbose to use.*

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
