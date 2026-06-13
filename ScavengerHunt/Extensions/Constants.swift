import SwiftUI

// This file holds all the fixed values used across the app.
// Putting them in one place makes it easy to change things later (like discount thresholds or messages)
// without having to search through every file.

struct Constants {
    
    // Basic app info
    
    static let appName = "Scavenger Hunt"
    static let totalItems = 10          // How many built‑in items the game starts with
    
    // Sizes used in the user interface
    
    static let photoSize: CGFloat = 250      // Width and height of the photo in the detail screen
    static let cornerRadius: CGFloat = 12    // How rounded corners should be (cards, buttons)
    static let buttonCornerRadius: CGFloat = 10 // Slightly smaller radius for some buttons
    
    // How long animations should last (in seconds)
    
    static let animationDuration: Double = 0.3
    
    // Reward thresholds: how many items you need to find to earn each discount
    
    static let discount10Threshold = 5   // 5 items → 10% off
    static let discount20Threshold = 7   // 7 items → 20% off
    static let grandPrizeThreshold = 10   // All 10 items → grand prize entry + 20% off
    
    // The actual messages shown to the user when they submit their results
    
    static let discount10Message = "🎁 10% Discount Code: SCAV10"
    static let discount20Message = "🎉 20% Discount Code: SCAV20"
    static let grandPrizeMessage = "🏆 $5,000 GRAND PRIZE ENTRY! + 20% Discount Code: SCAV20"
    
    // Layout values for the grid that shows all scavenger items
    
    static let gridSpacing: CGFloat = 12   // Space between grid items
    static let gridColumns = 2             // Number of columns in the grid (2 items per row)
}
