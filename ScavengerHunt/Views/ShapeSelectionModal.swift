import SwiftUI

// This modal appears when the user taps "Add Shape" or "Change Shape".
// It shows all available shapes in a scrollable grid.
// The user taps a shape, and the modal closes, passing back the chosen index.

struct ShapeSelectionModal: View {
    
    // Binding to the shape index stored in the current ScavengerItem.
    // When the user selects a shape, we update this value and dismiss.
    
    @Binding var selectedShapeIndex: Int
    
    // Environment dismiss, allows us to close the modal programmatically.
    
    @Environment(\.dismiss) var dismiss
    
    // Grid layout: each column tries to be at least 100 points wide,
    // but can expand if there is extra space.
    
    private let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 20)
    ]
    
    var body: some View {
        
        // Embed in a NavigationStack to get a navigation bar with title and Cancel button.
        
        NavigationStack {
            
            // ScrollView because there are many shapes – the user may need to scroll.
            
            ScrollView {
                
                // LazyVGrid creates a grid that only loads rows when they appear on screen.
                
                LazyVGrid(columns: columns, spacing: 20) {
                    
                    // Loop over all shapes using their index.
                    
                    ForEach(Array(Shapes.all.enumerated()), id: \.offset) { index, shape in
                        VStack {
                            
                            // The shape itself – stroke (outline) and fill.
                            
                            shape
                                .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                                .fill(Color.blue.opacity(0.15))
                                .frame(width: 80, height: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                                // Highlight the currently selected shape with a blue border.
                            
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedShapeIndex == index ? Color.blue : Color.clear, lineWidth: 3)
                                )
                            
                            // Shape name underneath (e.g., "Circle", "Star").
                            
                            Text(Shapes.names[index])
                                .font(.caption)
                                .fontWeight(selectedShapeIndex == index ? .bold : .regular)
                                .foregroundColor(selectedShapeIndex == index ? .blue : .primary)
                        }
                        .padding(8)
                        
                        // When the user taps on a shape, update the binding and close the modal.
                        
                        .onTapGesture {
                            selectedShapeIndex = index
                            dismiss()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose a Shape")
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
    
    // Preview with a constant binding (0 = Circle selected initially).
    
    ShapeSelectionModal(selectedShapeIndex: .constant(0))
}
