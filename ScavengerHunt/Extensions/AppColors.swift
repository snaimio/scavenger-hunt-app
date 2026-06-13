import SwiftUI

// This file defines a professional color system for the whole app.
// Instead of using hardcoded colors everywhere, I grouped them by purpose.
// That makes it easy to change the app's look later without hunting through every file.

// Main container for all our custom colors.

struct AppColors {
    
    // Primary brand colors, these are the main personality of the app.
    
    struct Primary {
        static let sapphire = Color(hex: "#1B4D8C")   // Deep blue, used for navigation bars
        static let amber = Color(hex: "#FF9F1C")      // Golden orange, for rewards and highlights
        static let emerald = Color(hex: "#2DAA9E")    // Fresh green, for success states
        static let royalPurple = Color(hex: "#6B4EFF") // Purple, for creative features like shapes
    }
    
    // Secondary colors, supporting colors for variety and depth.
    
    struct Secondary {
        static let coral = Color(hex: "#FF6B6B")      // Soft red, for "Retake Photo" buttons
        static let oceanBreeze = Color(hex: "#48CAE4") // Light blue, for "Take Photo" buttons
        static let honey = Color(hex: "#F4A261")      // Warm beige, for discount badges
        static let lavender = Color(hex: "#B8A9E8")    // Light purple, for "Reset" button
    }
    
    // Semantic colors, functional colors that tell the user something about the state.
    
    struct Semantic {
        static let success = Color(hex: "#4ADE80")    // Green: task completed
        static let warning = Color(hex: "#FBBF24")    // Yellow: needs attention
        static let error = Color(hex: "#F87171")      // Red: missing requirement
        static let info = Color(hex: "#60A5FA")       // Blue: information
    }
    
    // Neutral colors, backgrounds, text, borders, placeholders.
    
    struct Neutral {
        static let background = Color(hex: "#F7F9FC")   // Very light gray for main background
        static let surface = Color(hex: "#FFFFFF")     // White for cards and surfaces
        static let textPrimary = Color(hex: "#1E293B") // Dark gray for main text
        static let textSecondary = Color(hex: "#64748B") // Medium gray for less important text
        static let textTertiary = Color(hex: "#94A3B8") // Light gray for hints
        static let border = Color(hex: "#E2E8F0")      // Subtle border color
        static let placeholder = Color(hex: "#CBD5E1") // For empty states
        static let disabled = Color(hex: "#CBD5E1")    // Same as placeholder, for disabled buttons
    }
    
    // Gradients – smooth transitions between colors, used for special buttons.
    
    struct Gradients {
        
        // A green gradient for success messages and the "Add" button.
        
        static let success = LinearGradient(
            colors: [Primary.emerald, Color(hex: "#6EE7B7")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // A gold gradient for the "Submit" button when a discount is available.
        
        static let gold = LinearGradient(
            colors: [Secondary.honey, Primary.amber],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// Helper to create Color from hex string
// This makes it easy to write colors like Color(hex: "#1B4D8C")

extension Color {
    init(hex: String) {
        
        // Removes any spaces or # symbols, keep only hex characters
        
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        // Convert the hex string to an integer value
        
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // Format: RGB (12‑bit) – each component is repeated to become 8‑bit
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // Format: RRGGBB (24‑bit) – most common
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // Format: AARRGGBB (32‑bit) – includes alpha
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: // If something is wrong, fall back to black
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        // Creates the SwiftUI Color from the red, green, blue, alpha values
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
