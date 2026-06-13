import SwiftUI

// This view decides whether to show the splash screen animation or the main welcome screen.
// It acts as a launch transition – it displays SplashScreenView for 2 seconds,
// then fades/zooms into the WelcomeView.

struct AppLoadingView: View {
    
    // Tracks whether the splash screen is still visible.
    // When true, we show the splash; when false, we show the welcome screen.
    
    @State private var showSplash = true
    
    // Access to the shared data store, so we can pass it down to WelcomeView.
    
    @EnvironmentObject var store: ScavengerStore
    
    var body: some View {
        
        // ZStack layers the two views on top of each other.
        
        ZStack {
            
            // WelcomeView is always in the hierarchy, but initially hidden (opacity 0).
            
            WelcomeView()
                .environmentObject(store)
                .opacity(showSplash ? 0 : 1)
            
            // SplashScreenView is on top, fully visible at start.
            
            SplashScreenView()
                .ignoresSafeArea()          // stretches to fill the whole screen
                .opacity(showSplash ? 1 : 0) // fades out when showSplash becomes false
                .scaleEffect(showSplash ? 1 : 1.1) // slight zoom out while fading
        }
        .onAppear {
            
            // After 2 seconds, trigger the transition.
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                // Animate the change of showSplash – this will animate opacity and scale.
                
                withAnimation(.easeOut(duration: 0.6)) {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    AppLoadingView()
        .environmentObject(ScavengerStore())
}
