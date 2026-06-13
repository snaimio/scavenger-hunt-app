import SwiftUI

// This extension adds custom methods to UIImage for saving, loading, and deleting images.
// We use this to store user‑taken photos in the app's private Documents folder.
// The Documents folder is permanent, images stay there even after the app is closed.

extension UIImage {
    
    // Returns the URL of the app's Documents directory.
    // This is where we will save all image files.
    
    static var documentsDirectory: URL {
    
        // FileManager is the system tool for working with files and folders.
        // .documentDirectory is the standard place for user‑generated content.
        // .userDomainMask means "this app's sandboxed documents folder".
        
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // Saves the current UIImage to disk with the given filename.
    // It compresses the image to JPEG at 80% quality to save space.
    
    func save(filename: String) {
        
        // Convert the image to JPEG data. compressionQuality: 0.8 means 80% quality.
        
        guard let data = jpegData(compressionQuality: 0.8) else {
            print("❌ Could not convert image to JPEG")
            return
        }
        
        // Build the full file path by appending the filename to the documents folder.
        
        let url = Self.documentsDirectory.appendingPathComponent(filename)
        do {
        
            // Write the data to disk.
            
            try data.write(to: url)
            print("✅ Image saved: \(filename)")
            print("   Location: \(url.path)")
        } catch {
            print("❌ Image save error: \(error.localizedDescription)")
        }
    }
    
    // Loads an image from disk using a filename.
    // Returns nil if the file doesn't exist or can't be read.
    
    static func load(filename: String) -> UIImage? {
        let url = documentsDirectory.appendingPathComponent(filename)
        print("🔍 Looking for image at: \(url.path)")
        
        // Try to read the file's data.
    
        guard let data = try? Data(contentsOf: url) else {
            print("⚠️ Image not found: \(filename)")
            return nil
        }
        
        print("✅ Image loaded: \(filename)")
        
        // Create a UIImage from the raw data.
        
        return UIImage(data: data)
    }
    
    // Deletes the image file with the given filename from the Documents folder.
    
    static func delete(filename: String) {
        let url = documentsDirectory.appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
        print("🗑️ Image deleted: \(filename)")
    }
    
    // Helper method that prints every file inside the Documents folder.
    // Useful for debugging to see what images are stored.
    
    static func listAllSavedImages() {
        let url = documentsDirectory
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: url.path) else {
            print("📂 No files found in documents directory")
            return
        }
        
        print("📂 Files in Documents directory:")
        for file in files {
            print("   - \(file)")
        }
    }
}
