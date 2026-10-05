import SwiftUI
import Combine

// This class is the "source of truth" for all scavenger hunt data.
// It stores the array of items, saves and loads them to/from disk,
// and notifies the UI when anything changes (using ObservableObject).

class ScavengerStore: ObservableObject {
    
    // @Published means: whenever the items array changes, SwiftUI will automatically
    // refresh any view that is watching this object.
    // The didSet observer calls save() every time we modify the array.
   
    @Published var items: [ScavengerItem] {
        didSet {
            save()          // Immediately write changes to disk
        }
    }
    
    // The URL of the app's Documents folder – where we store the JSON file and images.
    
    static var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // The name of the JSON file that holds the items array.
    
    var filename: String {
        "scavengerItems.json"
    }
    
    // How many items have been FULLY completed (photo taken AND marked as found).
    // This is used for the progress bar and reward messages.
    
    var foundCount: Int {
        items.filter { $0.isFound == true && $0.imageFilename != nil }.count
    }
    
    // The reward message that changes based on how many items have been fully found.
    // It reads from the thresholds defined in Constants.
    
    var rewardMessage: String {
        if foundCount >= Constants.grandPrizeThreshold {
            return Constants.grandPrizeMessage
        } else if foundCount >= Constants.discount20Threshold {
            return Constants.discount20Message
        } else if foundCount >= Constants.discount10Threshold {
            return Constants.discount10Message
        } else {
            return "🔎 Keep searching! Need \(Constants.discount10Threshold - foundCount) more for discount"
        }
    }
    
    // When the app creates the store, it tries to load saved items from disk.
    // If there are none (first launch), it creates the default 10 items.
    
    init() {
        let savedItems = Self.load()
        if savedItems.isEmpty {
            
            // Default initial catalog of scavenger hunt discovery locations.
            
            self.items = [
                ScavengerItem(name: "Coffee Shop", clue: "Smells like fresh coffee beans"),
                ScavengerItem(name: "Movie Theater", clue: "Where movies come to life on big screen"),
                ScavengerItem(name: "Book Store", clue: "A quiet place full of stories and knowledge"),
                ScavengerItem(name: "Restaurant", clue: "Food lovers gather here for delicious meals"),
                ScavengerItem(name: "Library", clue: "Silent reading paradise with thousands of books"),
                ScavengerItem(name: "Gym", clue: "Where people go to stay fit and healthy"),
                ScavengerItem(name: "Park", clue: "Green space for relaxing and outdoor fun"),
                ScavengerItem(name: "Bakery", clue: "Follow the smell of fresh bread and pastries"),
                ScavengerItem(name: "Mall", clue: "Shopping paradise with many stores together"),
                ScavengerItem(name: "Ice Cream Shop", clue: "Cold sweet treats on a hot day")
            ]
            print("📱 Created default \(self.items.count) items")
        } else {
            self.items = savedItems
            print("📱 Loaded \(self.items.count) items from disk")
        }
        
        // Debug: print each item's image filename (helpful for checking saved photos)
        
        for item in self.items {
            print("📸 Item: \(item.name), Image: \(item.imageFilename ?? "nil")")
        }
    }
    
    // Writes the current items array to a JSON file in the Documents folder.
    
    func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted   // Makes the JSON human‑readable
            let data = try encoder.encode(items)
            let url = Self.documentsURL.appendingPathComponent(filename)
            try data.write(to: url)
            print("💾 Saved \(items.count) items to disk")
        } catch {
            print("❌ Save error: \(error.localizedDescription)")
        }
    }
    
    // Tries to read the JSON file from disk. Returns an empty array if the file doesn't exist.
    
    static func load() -> [ScavengerItem] {
        let url = documentsURL.appendingPathComponent("scavengerItems.json")
        
        guard let data = try? Data(contentsOf: url) else {
            print("📭 No saved file found")
            return []
        }
        
        do {
            let items = try JSONDecoder().decode([ScavengerItem].self, from: data)
            print("📖 Loaded \(items.count) items from disk")
            return items
        } catch {
            print("❌ Load error: \(error.localizedDescription)")
            return []
        }
    }
    
    // Given a ScavengerItem, find its position in the items array.
    // This is used to pass a binding to the detail view.
    
    func index(for item: ScavengerItem) -> Int? {
        items.firstIndex { $0.id == item.id }
    }
    
    // Adds a new custom item (used by the green "Add" button).
    
    func addItem(name: String, clue: String) {
        let newItem = ScavengerItem(name: name, clue: clue, isFound: false, imageFilename: nil, shapeIndex: 0)
        items.append(newItem)
        save()
        print("➕ Added new item: \(name)")
    }
    
    // Resets the whole game: deletes all saved photos, clears found status and shape indices.
    // It does NOT delete custom items – only clears their progress.
    
    func resetGame() {
        for i in 0..<items.count {
            if let filename = items[i].imageFilename {
                UIImage.delete(filename: filename)   // Delete the photo file from disk
            }
            items[i].isFound = false
            items[i].imageFilename = nil
            items[i].shapeIndex = 0                 // Reset shape to Circle
        }
        save()
        print("🔄 Game reset")
    }
}
