import SwiftUI

// This struct represents one scavenger hunt item (e.g., "Coffee Shop").
// It stores the name, clue, whether it's found, the user's photo (as a filename on disk),
// and which shape the user chose to clip the photo.
//
// It conforms to:
// - Identifiable → so we can use it in ForEach and fullScreenCover(item:)
// - Codable     → to save/load the item to/from a JSON file
// - Hashable    → needed for navigationDestination(item:) and ForEach to work correctly

struct ScavengerItem: Identifiable, Codable, Hashable {
    
    // Unique identifier for each item. SwiftUI uses this to track items in lists.
    
    var id = UUID()
    
    // The name of the business (e.g., "Coffee Shop")
    
    var name: String
    
    // The clue that helps the user find this location
    
    var clue: String
    
    // Whether the user has tapped "Mark as Found" for this item
    
    var isFound: Bool = false
    
    // The name of the image file saved in the app's Documents folder.
    // If nil, no user photo has been taken (or it was deleted).
    
    var imageFilename: String?
    
    // Which shape the user chose to clip the photo.
    // 0 means "Circle", 1 = "Rectangle", etc. (matches the Shapes.all array order)
    // Default is 0 (Circle).
    
    var shapeIndex: Int = 0
    
    // Required by Hashable – combines the id into the hash.
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Required by Hashable – compares two items by their id.
    
    static func == (lhs: ScavengerItem, rhs: ScavengerItem) -> Bool {
        lhs.id == rhs.id
    }
    
    // Computed property that gives access to the actual UIImage.
    // - When you GET it, it loads the image from disk using imageFilename.
    // - When you SET it, it saves the new image to disk, deletes the old one,
    //   and stores the new filename in imageFilename.
    
    var image: UIImage? {
        get {
            
            // If there's a filename, try to load the image; otherwise return nil.
            
            guard let filename = imageFilename else { return nil }
            return UIImage.load(filename: filename)
        }
        set {
            if let newImage = newValue {
                
                // If we already had a photo, delete the old file.
                
                if let oldFilename = imageFilename {
                    UIImage.delete(filename: oldFilename)
                }
                
                // Create a unique filename and save the new image.
                
                let filename = UUID().uuidString + ".jpg"
                newImage.save(filename: filename)
                imageFilename = filename
            } else {
                
                // If we are setting the image to nil, delete the existing file.
                
                if let oldFilename = imageFilename {
                    UIImage.delete(filename: oldFilename)
                }
                imageFilename = nil
            }
        }
    }
    
    // Which properties to include when encoding/decoding JSON.
    
    enum CodingKeys: String, CodingKey {
        case id, name, clue, isFound, imageFilename, shapeIndex
    }
    
    // Custom decoder – reads from JSON and prints the loaded shapeIndex for debugging.
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        id = UUID(uuidString: idString) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        clue = try container.decode(String.self, forKey: .clue)
        isFound = try container.decode(Bool.self, forKey: .isFound)
        imageFilename = try container.decodeIfPresent(String.self, forKey: .imageFilename)
        shapeIndex = try container.decode(Int.self, forKey: .shapeIndex)
        print("📖 Loaded \(name) with shapeIndex \(shapeIndex)")
    }
    
    // Custom encoder – writes to JSON and prints the saved shapeIndex.
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(clue, forKey: .clue)
        try container.encode(isFound, forKey: .isFound)
        try container.encode(imageFilename, forKey: .imageFilename)
        try container.encode(shapeIndex, forKey: .shapeIndex)
        print("💾 Saved \(name) with shapeIndex \(shapeIndex)")
    }
    
    // Regular initializer – used when creating a new item (e.g., the default 10 items or a new custom item).
    
    init(name: String, clue: String, isFound: Bool = false, imageFilename: String? = nil, shapeIndex: Int = 0) {
        self.id = UUID()
        self.name = name
        self.clue = clue
        self.isFound = isFound
        self.imageFilename = imageFilename
        self.shapeIndex = shapeIndex
    }
}
