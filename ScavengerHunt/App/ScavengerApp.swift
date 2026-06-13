import SwiftUI

// This is the main entry point of the app.
// The @main attribute tells SwiftUI that this struct is the app's starting point.

@main
struct ScavengerApp: App {
    
    // @StateObject creates and owns the data store for the entire app.
    // It lives for the whole lifetime of the app and does not get recreated.
    // ScavengerStore holds all scavenger hunt items, their photos, and progress.
    
    @StateObject var store = ScavengerStore()
    
    // The body describes the scenes (windows) of the app.
    // WindowGroup is the main window, on iOS it's the entire screen.
    
    var body: some Scene {
        WindowGroup {
            
            // NavigationStack allows us to push and pop screens (like a navigation controller).
            // It gives us the ability to have a back button and navigate between views.
            
            NavigationStack {
                
                // AppLoadingView is the first screen: it shows a splash animation,
                // then automatically transitions to the WelcomeView.
                
                AppLoadingView()
                
                    // .environmentObject injects the store into the view hierarchy.
                    // Any child view can access it with @EnvironmentObject.
                
                    .environmentObject(store)
            }
        }
    }
}
