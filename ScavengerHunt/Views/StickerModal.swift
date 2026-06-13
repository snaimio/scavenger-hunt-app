import SwiftUI

// This modal appears when the user taps "Choose Default".
// It shows a grid of pre‑made images from the app's asset catalog (Assets.xcassets).
// The user taps any image, and that image becomes the photo for the current scavenger item.

struct StickerModal: View {
    
    // Binding to a temporary UIImage that will be passed back to the detail screen.
    // When the user selects a default image, we set this binding and close the modal.
    
    @Binding var selectedImage: UIImage?
    
    // Environment dismiss, lets close the modal programmatically.
    
    @Environment(\.dismiss) var dismiss
    
    // The exact names of the images inside Assets.xcassets.
    // These must match the asset names exactly (case‑sensitive).
    
    let stickerNames = [
        "bakery",
        "book",
        "coffee",
        "comp",
        "gym",
        "icecream",
        "library",
        "mall",
        "movie",
        "park",
        "restaurant"
    ]
    
    // User friendly names to display under each image.
    
    let displayNames = [
        "Bakery",
        "Book Store",
        "Coffee Shop",
        "Computer Store",
        "Gym",
        "Ice Cream Shop",
        "Library",
        "Mall",
        "Movie Theater",
        "Park",
        "Restaurant"
    ]
    
    // Grid layout, each column tries to be at least 100 points wide.
    
    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                // LazyVGrid loads only the visible rows, which is more efficient.
                
                LazyVGrid(columns: columns, spacing: 20) {
                    
                    // Loop over each sticker name together with its index.
                    
                    ForEach(Array(stickerNames.enumerated()), id: \.offset) { index, name in
                        
                        // Try to load the image from the asset catalog by name.
                        
                        if let image = UIImage(named: name) {
                            VStack {
                                
                                // The actual image, resized to fill a 100x100 square.
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(radius: 2)
                                
                                // The friendly name underneath.
                                
                                Text(displayNames[index])
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                            
                            // When the user taps this item, update the binding and close.
                            
                            .onTapGesture {
                                selectedImage = image
                                dismiss()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Default Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // A Cancel button in the top‑right corner.
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    
    // Preview with a constant binding that holds nil (no image selected yet).
    
    StickerModal(selectedImage: .constant(nil))
}
