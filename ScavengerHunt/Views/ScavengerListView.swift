import SwiftUI
import Combine

// This is the main screen that shows all scavenger items in a grid.
// It displays the progress (how many fully found), reward message, and action buttons:
// Add (create a custom item), Submit (share discount code), Reset (clear all progress).

struct ScavengerListView: View {
    
    // Access to the shared data store, the array of items lives here.
    
    @EnvironmentObject var store: ScavengerStore
    
    // The item the user tapped, used to trigger navigation to the detail screen.
    
    @State private var selectedItem: ScavengerItem?
    
    // Control flags for different alerts and sheets.
    
    @State private var showSubmitAlert = false   // when not enough items found
    @State private var showResetAlert = false    // confirm reset
    @State private var showAddItemAlert = false  // add new item form
    @State private var showShareSheet = false    // share discount code
    
    // A unique ID that forces the whole view to redraw when changed.
    // We update this after returning from the detail screen to make sure shapes refresh.
    
    @State private var refreshID = UUID()
    
    // Temporary storage for the "Add Item" form.
    
    @State private var newItemName = ""
    @State private var newItemClue = ""
    
    // Grid layout: two flexible columns with spacing defined in Constants.
    
    private let columns = [
        GridItem(.flexible(), spacing: Constants.gridSpacing),
        GridItem(.flexible(), spacing: Constants.gridSpacing)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // ----- PROGRESS HEADER (found count, progress bar, reward message) -----
            
            VStack(spacing: 8) {
                Text("Found: \(store.foundCount) / \(store.items.count)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.Primary.sapphire)
                
                // Progress bar, value between 0 and total items.
                
                ProgressView(value: Double(store.foundCount), total: Double(store.items.count))
                    .tint(AppColors.Primary.emerald)
                    .frame(height: 8)
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)   // makes the bar thicker
                    .padding(.horizontal)
                
                Text(store.rewardMessage)
                    .font(.subheadline)
                    .foregroundColor(store.foundCount >= Constants.discount10Threshold ? AppColors.Primary.amber : AppColors.Neutral.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(AppColors.Neutral.surface.shadow(color: AppColors.Neutral.border, radius: 2, y: 2))
            
            // ----- ACTION BUTTONS ROW (Add, Submit, Reset) -----
            
            HStack(spacing: 10) {
                
                // ADD BUTTON, green, opens an alert to create a new custom item.
                
                Button(action: { showAddItemAlert = true }) {
                    Label("Add", systemImage: "plus.circle.fill")
                        .labelStyle(.titleAndIcon)
                        .font(.system(size: 14, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .frame(height: 40)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(20)
                
                // SUBMIT BUTTON, gold/orange when enough items are found, otherwise gray.
                // If enough items, opens share sheet; otherwise shows an alert telling how many more needed.
                
                Button(action: {
                    if store.foundCount >= Constants.discount10Threshold {
                        showShareSheet = true
                    } else {
                        showSubmitAlert = true
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 13))
                        Text("Submit")
                            .font(.system(size: 14, weight: .semibold))
                        
                        // Small badge showing the discount percentage (10% or 20%) when eligible.
                        
                        if store.foundCount >= Constants.discount10Threshold {
                            Text(store.foundCount >= Constants.discount20Threshold ? "20%" : "10%")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .frame(height: 40)
                .background(store.foundCount >= Constants.discount10Threshold ? Color(hex: "#FF9F1C") : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(20)
                .disabled(store.foundCount < Constants.discount10Threshold)
                
                // RESET BUTTON, purple, clears all progress after confirmation.
                
                Button(action: { showResetAlert = true }) {
                    Label("Reset", systemImage: "arrow.clockwise")
                        .labelStyle(.titleAndIcon)
                        .font(.system(size: 14, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .frame(height: 40)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            
            // ----- ALERTS (pop‑ups) -----
            // Alert for adding a new item – two text fields.
            
            .alert("Add New Item", isPresented: $showAddItemAlert) {
                TextField("Item name", text: $newItemName)
                TextField("Clue", text: $newItemClue)
                Button("Cancel", role: .cancel) { newItemName = ""; newItemClue = "" }
                Button("Add") { addNewItem() }
            } message: { Text("Enter the business name and a clue") }
            
            // Alert shown when Submit is tapped but not enough items are found.
            
            .alert("Not Enough Items", isPresented: $showSubmitAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You need to find \(Constants.discount10Threshold - store.foundCount) more item(s) to qualify for a discount.")
            }
            
            // Reset confirmation alert, destructive action.
            
            .alert("Reset Game?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    store.resetGame()
                    refreshID = UUID()   // force grid to refresh after reset
                }
            } message: { Text("All progress and photos will be lost.") }
            
            // ----- MAIN CONTENT (grid of items) -----
            
            ScrollView {
                if store.items.isEmpty {
                    
                    // Empty state: friendly message and binoculars icon.
                    
                    VStack(spacing: 20) {
                        Image(systemName: "binoculars")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No Items")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Tap the green 'Add' button to create your first scavenger item")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 100)
                } else {
                    
                    // Two‑column grid using LazyVGrid for efficiency.
                    
                    LazyVGrid(columns: columns, spacing: Constants.gridSpacing) {
                        ForEach(store.items) { item in
                            ItemCard(item: item)
                                .environmentObject(store)
                                .onTapGesture { selectedItem = item }   // navigate to detail
                        }
                    }
                    .padding(Constants.gridSpacing)
                }
            }
        }
        .background(AppColors.Neutral.background)
        .navigationTitle(Constants.appName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppColors.Primary.sapphire, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        
        // ----- NAVIGATION TO DETAIL SCREEN -----
        // When selectedItem changes, push the detail view.
        
        .navigationDestination(item: $selectedItem) { item in
            if let index = store.index(for: item) {
                ScavengerDetailView(item: $store.items[index])
                    .environmentObject(store)
                    .onDisappear {
                        
                        // Force the grid to refresh when we come back from the detail screen.
                        // This is crucial for updating shapes and other changes.
                        
                        refreshID = UUID()
                        store.objectWillChange.send()
                        
                        // Extra send to ensure any lingering update is caught.
                        
                        if let idx = store.index(for: item) {
                            store.objectWillChange.send()
                        }
                    }
            }
        }
        
        // Share sheet for discount codes (iOS standard share sheet).
        
        .sheet(isPresented: $showShareSheet) {
            ActivityView(activityItems: [store.rewardMessage])
        }
        
        // The .id(refreshID) makes SwiftUI treat this view as brand new whenever refreshID changes.
        // This forces the whole grid to redraw – essential for showing shape changes after returning.
        
        .id(refreshID)
        
        // Also refresh when the view appears (in case something changed elsewhere).
        
        .onAppear {
            store.objectWillChange.send()
        }
    }
    
    // Helper Functions
    // Creates a new custom item and adds it to the store, then refreshes the grid.
    
    func addNewItem() {
        guard !newItemName.isEmpty && !newItemClue.isEmpty else { return }
        let newItem = ScavengerItem(name: newItemName, clue: newItemClue, isFound: false, imageFilename: nil, shapeIndex: 0)
        store.items.append(newItem)
        store.save()
        refreshID = UUID()   // force grid to show the new item immediately
        newItemName = ""
        newItemClue = ""
        print("➕ Added new item: \(newItemName)")
    }
}

// Activity View for Share Sheet
// This is a UIKit wrapper that presents the standard iOS share sheet.

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        ScavengerListView()
            .environmentObject(ScavengerStore())
    }
}
