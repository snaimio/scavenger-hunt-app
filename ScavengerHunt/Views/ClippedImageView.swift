import SwiftUI

// A reusable view that displays an image, optionally clipped into a custom shape.
// If a shapeIndex is provided (and is valid), the image gets clipped to that shape.
// This is used in the detail screen so the user can see their photo with the chosen frame.

struct ClippedImageView: View {
    let image: UIImage           // the photo to display
    let shapeIndex: Int?         // which shape to clip with (nil means no clipping)
    
    var body: some View {
        
        // Only clip if we have a valid shapeIndex (0…9)
        
        if let shapeIndex = shapeIndex, shapeIndex >= 0 && shapeIndex < Shapes.all.count {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
                // Apply the shape as a clip mask.
            
                .clipShape(Shapes.all[shapeIndex])
            
                // .contentShape defines the tappable area.
                // For shapes with curved paths (like Lens), the default hit area might be wrong.
                // Using Ellipse() is a workaround to keep the photo tappable everywhere inside its bounding box.
                .contentShape(Ellipse())
        } else {
            
            // No clipping – just show the image as is.
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
