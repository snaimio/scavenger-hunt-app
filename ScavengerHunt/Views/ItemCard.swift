import SwiftUI
import Combine

// This view represents one card in the main grid.
// It shows a small photo (or placeholder), the item name, and a short clue.
// A green checkmark appears only when the item is fully completed (photo taken AND marked as found).

struct ItemCard: View {
    
    // The data for this single scavenger item.
    
    let item: ScavengerItem
    
    // The shared store, not used directly here, but I need it to listen for changes.
    
    @EnvironmentObject var store: ScavengerStore
    
    // Returns true only when BOTH conditions are met:
    // 1. isFound == true (user tapped "Mark as Found")
    // 2. imageFilename != nil (a photo has been taken)
    
    var isFullyComplete: Bool {
        item.isFound == true && item.imageFilename != nil
    }
    
    var body: some View {
        VStack(spacing: 10) {
            
            // ----- PHOTO OR PLACEHOLDER -----
            
            ZStack {
                if let image = item.image {
                    
                    // User has a photo, display it, clipped to the chosen shape.
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)   // fills the frame, cropping if needed
                        .frame(width: 160, height: 140)
                        .clipShape(Shapes.all[item.shapeIndex])   // apply the shape (circle, star, etc.)
                        .cornerRadius(16)
                } else {
                    
                    // No photo yet, show a placeholder with a camera icon.
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.Neutral.placeholder.opacity(0.15))
                        .frame(width: 160, height: 140)
                        .overlay(
                            VStack(spacing: 10) {
                                Image(systemName: "camera.viewfinder")
                                    .font(.largeTitle)
                                    .foregroundColor(AppColors.Neutral.textTertiary)
                                Text("No photo yet")
                                    .font(.caption)
                                    .foregroundColor(AppColors.Neutral.textTertiary)
                            }
                        )
                }
                
                // ----- GREEN CHECKMARK (only when fully complete) -----
                
                if isFullyComplete {
                    VStack {
                        HStack {
                            Spacer()   // pushes checkmark to the right edge
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(AppColors.Semantic.success)
                                .background(Color.white.clipShape(Circle()))   // white circle behind
                                .shadow(radius: 2)
                                .padding(6)
                        }
                        Spacer()       // keeps the checkmark at the top
                    }
                }
            }
            .frame(width: 160, height: 140)   // fixed size for all cards
            
            // ----- ITEM NAME -----
            
            Text(item.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.Neutral.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)                // prevent long names from overflowing
                .padding(.horizontal, 6)
            
            // ----- SHORT CLUE (preview) -----
            
            Text(item.clue)
                .font(.caption2)
                .foregroundColor(AppColors.Neutral.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 6)
        }
        .frame(width: 170)                  // total card width (slightly wider than the photo)
        .padding(.vertical, 8)
        .background(AppColors.Neutral.surface)
        .cornerRadius(20)
        .shadow(color: AppColors.Neutral.border.opacity(0.5), radius: 6, x: 0, y: 2)
        
        // Force SwiftUI to treat this view as completely new when either the item's id changes
        // OR the shapeIndex changes. This is crucial to make the grid update the photo's shape
        // after the user selects a different shape in the detail screen.
        
        .id(item.id)
        .id(item.shapeIndex)
        
        // Listen for changes from the store – when the store broadcasts an update,
        // this card will redraw itself (the closure does nothing, but the mere presence triggers a refresh).
        
        .onReceive(store.objectWillChange) { _ in }
    }
}

#Preview {
    let sampleItem = ScavengerItem(name: "Coffee Shop", clue: "Smells like fresh coffee beans")
    return ItemCard(item: sampleItem)
        .environmentObject(ScavengerStore())
        .padding()
        .background(AppColors.Neutral.background)
}
