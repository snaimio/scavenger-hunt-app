import SwiftUI
import PhotosUI
import Combine

// This screen lets the user handle one scavenger item: take/choose a photo, apply a shape,
// mark it as found, and save everything.

struct ScavengerDetailView: View {
    
    // The actual item (binding so changes go back to the main array)
    
    @Binding var item: ScavengerItem
    
    // Shared data store, needed for saving and refreshing the grid
    
    @EnvironmentObject var store: ScavengerStore
    
    // Allows us to dismiss this screen (go back) programmatically
    
    @Environment(\.dismiss) var dismiss
    
    // Detects when the app moves to the background, we'll auto‑save
    
    @Environment(\.scenePhase) private var scenePhase

    // Photo picker state
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    // Controls whether the shape selection modal is shown
    
    @State private var showShapeModal = false
    
    // Controls whether the "Choose Default" modal is shown
    
    @State private var showStickerModal = false
    
    // Pinch & rotation gestures for the photo
    
    @State private var photoScale: CGFloat = 1.0
    @State private var photoRotation: Angle = .zero
    
    // Temporary storage for a newly selected photo (from library or default picker)
    
    @State private var tempImage: UIImage?

    let photoSize: CGFloat = 200   // fixed preview size for the photo

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12) {
                
                // ----- ITEM NAME -----
                
                Text(item.name)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(AppColors.Neutral.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)

                // ----- STATUS MESSAGE (dynamic help text) -----
                
                statusMessage

                // ----- CLUE SECTION -----
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(AppColors.Primary.amber)
                            .font(.caption)
                        Text("CLUE")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.Neutral.textSecondary)
                    }
                    Text(item.clue)
                        .font(.subheadline)
                        .foregroundColor(AppColors.Neutral.textPrimary)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppColors.Neutral.surface)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                // ----- PHOTO PROOF SECTION (image or placeholder) -----
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "camera.fill")
                            .foregroundColor(AppColors.Secondary.coral)
                            .font(.caption)
                        Text("PHOTO PROOF")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.Neutral.textSecondary)
                    }

                    if let image = tempImage ?? item.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: photoSize, height: photoSize)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .clipShape(Shapes.all[item.shapeIndex])
                            .scaleEffect(photoScale)
                            .rotationEffect(photoRotation)
                            .gesture(
                                SimultaneousGesture(
                                    MagnificationGesture()
                                        .onChanged { value in photoScale = value }
                                        .onEnded { _ in withAnimation(.spring()) { photoScale = 1.0 } },
                                    RotationGesture()
                                        .onChanged { angle in photoRotation = angle }
                                        .onEnded { _ in withAnimation(.spring()) { photoRotation = .zero } }
                                )
                            )
                            .onTapGesture(count: 2) {
                                withAnimation(.spring()) {
                                    photoScale = 1.0
                                    photoRotation = .zero
                                }
                            }
                    } else {
                        
                        // Placeholder when no photo exists yet
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.Neutral.placeholder.opacity(0.15))
                            .frame(width: photoSize, height: photoSize)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .overlay(
                                VStack(spacing: 8) {
                                    Image(systemName: "camera.viewfinder")
                                        .font(.system(size: 40))
                                        .foregroundColor(AppColors.Neutral.textTertiary)
                                    Text("No photo yet")
                                        .font(.subheadline)
                                        .foregroundColor(AppColors.Neutral.textSecondary)
                                    Text("Tap 'Take Photo' or 'Choose Default'")
                                        .font(.caption2)
                                        .foregroundColor(AppColors.Neutral.textTertiary)
                                }
                            )
                    }
                }
                .padding(.horizontal)

                // ----- BUTTON ROW: TAKE PHOTO & CHOOSE DEFAULT -----
                
                HStack(spacing: 12) {
                    
                    // System photo library picker
                    
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        HStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                            Text("Take Photo")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "#48CAE4"))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                    }

                    // Default images from Assets.xcassets
                    
                    Button(action: { showStickerModal = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "photo.fill")
                            Text("Choose Default")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "#1B4D8C"))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                    }
                }
                .padding(.horizontal)
                .onChange(of: selectedPhotoItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            await MainActor.run {
                                tempImage = uiImage
                                item.image = uiImage
                                store.save()
                                store.objectWillChange.send()
                                selectedPhotoItem = nil
                            }
                        }
                    }
                }

                // ----- REMOVE PHOTO BUTTON (only visible if a photo exists) -----
                
                if item.image != nil {
                    Button(action: {
                        tempImage = nil
                        item.image = nil
                        store.save()
                        store.objectWillChange.send()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "trash")
                            Text("Remove Photo")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "#FF6B6B"))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                    }
                    .padding(.horizontal)
                }

                // ----- SHAPE BUTTON (only visible if a photo exists) -----
                
                if item.image != nil {
                    Button(action: { showShapeModal = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.on.circle")
                            Text(item.shapeIndex != 0 ? "Change Shape" : "Add Shape")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "#6B4EFF"))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                    }
                    .padding(.horizontal)
                }

                // ----- MARK AS FOUND BUTTON -----
                
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        item.isFound = true
                        store.save()
                        store.objectWillChange.send()
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: item.isFound ? "checkmark.seal.fill" : "checkmark.seal")
                            .font(.body)
                        Text(item.isFound ? "Marked as Found" : "Mark as Found")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(item.isFound ? Color(hex: "#4ECDC4") : Color(hex: "#8B5E3C"))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                }
                .disabled(item.isFound)
                .padding(.horizontal)

                Spacer(minLength: 0)   // pushes the Done button to the bottom

                // ----- DONE BUTTON (only enabled when both photo and mark are done) -----
                
                Button(action: {
                    if (tempImage != nil || item.image != nil) && item.isFound {
                        store.save()
                        store.objectWillChange.send()
                        dismiss()
                    }
                }) {
                    Text("Done")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .tracking(2)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundColor(.white)
                        .background(
                            Group {
                                if (tempImage != nil || item.image != nil) && item.isFound {
                                    LinearGradient(colors: [Color(hex: "#00B4D8"), Color(hex: "#0096C7")],
                                                   startPoint: .leading, endPoint: .trailing)
                                } else {
                                    Color(hex: "#ADB5BD")   // disabled gray
                                }
                            }
                        )
                        .cornerRadius(30)
                }
                .disabled(!((tempImage != nil || item.image != nil) && item.isFound))
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
            .frame(minHeight: geometry.size.height)
            .padding(.vertical, 8)
        }
        .background(AppColors.Neutral.background)
        .navigationTitle((item.image != nil && item.isFound) ? "Complete!" : item.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppColors.Primary.sapphire, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)

        // ----- SHAPE MODAL (CRITICAL FIX) -----
        // Uses a custom Binding that saves immediately and tells the store to refresh.
        
        .sheet(isPresented: $showShapeModal) {
            ShapeSelectionModal(selectedShapeIndex: Binding(
                get: { item.shapeIndex },
                set: { newValue in
                    item.shapeIndex = newValue
                    store.save()
                    store.objectWillChange.send()
                }
            ))
        }

        // ----- DEFAULT PHOTOS MODAL (from Assets) -----
        
        .sheet(isPresented: $showStickerModal) {
            StickerModal(selectedImage: $tempImage)
                .onDisappear {
                    if let image = tempImage {
                        item.image = image
                        store.save()
                        store.objectWillChange.send()
                    }
                }
        }

        // Auto‑save when the app becomes inactive
        
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .inactive {
                store.save()
            }
        }

        // When this view disappears, tell the store to refresh any other views (like the grid)
        
        .onDisappear {
            store.objectWillChange.send()
        }
    }

    // Status Message (dynamic help text)
    
    @ViewBuilder
    var statusMessage: some View {
        
        // Case 1: nothing done yet, need both
        
        if (tempImage == nil && item.image == nil) && !item.isFound {
            Text("Need Photo AND Mark as Found")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.Semantic.error)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .background(AppColors.Semantic.error.opacity(0.12))
                .cornerRadius(10)
                .padding(.horizontal)
        }
        // Case 2: photo exists but not marked, needs Mark as Found
        
        else if (tempImage != nil || item.image != nil) && !item.isFound {
            Text("Photo taken! Now tap 'Mark as Found'")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.Semantic.error)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .background(AppColors.Semantic.error.opacity(0.12))
                .cornerRadius(10)
                .padding(.horizontal)
        }
        // Case 3: marked but no photo, needs a photo
        
        else if item.isFound && (tempImage == nil && item.image == nil) {
            Text("Marked as Found! Now Take a Photo")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.Semantic.error)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .background(AppColors.Semantic.error.opacity(0.12))
                .cornerRadius(10)
                .padding(.horizontal)
        }
        // Case 4: both done, ready to submit
        
        else if item.isFound && (tempImage != nil || item.image != nil) {
            Text("Complete! Ready to submit")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.Semantic.success)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .background(AppColors.Semantic.success.opacity(0.12))
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        ScavengerDetailView(item: .constant(ScavengerStore().items[0]))
            .environmentObject(ScavengerStore())
    }
}
