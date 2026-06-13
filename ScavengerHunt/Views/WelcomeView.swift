import SwiftUI

// This is the first screen the user sees after the splash animation disappears.
// It explains the rules of the scavenger hunt and gives a "Start Hunt" button.

struct WelcomeView: View {
    
    // The shared data store, needed because the Start button navigates to the main list.
    
    @EnvironmentObject var store: ScavengerStore
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 0)   // pushes content down slightly, but not too much
            
            // ----- APP ICON (binoculars) -----
            // Uses a gradient to look modern and match the splash screen.
            
            Image(systemName: "binoculars.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "#1B4D8C"), Color(hex: "#6B4EFF")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color(hex: "#1B4D8C").opacity(0.4), radius: 10, x: 0, y: 5)
            
            // ----- APP TITLE -----
            // Uses a three‑colour gradient that matches the coloured letters in the splash.
            
            Text("Scavenger Hunt")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "#1B4D8C"), Color(hex: "#2DAA9E"), Color(hex: "#FF9F1C")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .multilineTextAlignment(.center)
            
            // ----- SUBTITLE -----
            
            Text("Find hidden treasures in your city")
                .font(.title3)
                .foregroundColor(AppColors.Neutral.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            // ----- INSTRUCTION BOX (three rows) -----
            // Shows what the user can do: take photos, follow clues, earn rewards.
            
            VStack(alignment: .leading, spacing: 16) {
                InstructionRow(icon: "camera.fill", color: Color(hex: "#48CAE4"), text: "Take a photo of each item you find")
                InstructionRow(icon: "map.circle.fill", color: Color(hex: "#FF9F1C"), text: "Follow clues to discover locations")
                InstructionRow(icon: "gift.fill", color: Color(hex: "#FF6B6B"), text: "Earn amazing rewards and prizes!")
            }
            .padding(20)
            .background(AppColors.Neutral.surface)          // white card
            .cornerRadius(20)
            .shadow(color: AppColors.Neutral.border.opacity(0.6), radius: 12, x: 0, y: 4)
            .padding(.horizontal, 24)
            
            Spacer()   // pushes the button to the bottom, creating equal space above and below
            
            // ----- START BUTTON -----
            // Uses a gradient similar to the splash screen letters.
            
            NavigationLink(destination: ScavengerListView()
                .environmentObject(store)) {
                Text("START THE HUNT")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .tracking(2)                    // adds letter spacing for a bold look
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#1B4D8C"), Color(hex: "#6B4EFF"), Color(hex: "#2DAA9E")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .shadow(color: Color(hex: "#1B4D8C").opacity(0.5), radius: 15, x: 0, y: 6)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)   // makes the VStack fill the whole screen
        .background(AppColors.Neutral.background)           // very light gray background
        .navigationBarHidden(true)                         // no back button or title on this screen
    }
}

// A helper view that displays one instruction row (icon + text).
// It is used three times inside the instructions box.

struct InstructionRow: View {
    let icon: String
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 32)          // fixed width keeps all icons aligned
                .shadow(color: color.opacity(0.3), radius: 3, x: 0, y: 2)
            
            Text(text)
                .font(.body)
                .foregroundColor(AppColors.Neutral.textPrimary)
            
            Spacer()   // pushes content to the left, leaving any extra space on the right
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
            .environmentObject(ScavengerStore())
    }
}
