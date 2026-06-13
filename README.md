# iOSApp2 - Scavenger Hunt App 

## Description
A polished scavenger hunt app that helps users find hidden items at local businesses. Users get clues, take photos (or choose default images), apply creative shapes, track progress, and earn discounts. Data persists between app launches.

## Core Features

### Navigation & UI
- `NavigationStack` – Screen navigation between Welcome, List, and Detail views.
- `navigationDestination` – Pushes the detail view with an automatic back button.
- `.toolbar` – Custom toolbar buttons (Back, Done).
- `PhotosPicker` modal – System photo picker for taking photos.
- Custom shape picker modal – Select from 10 shapes to clip the photo.

### Gestures
- `MagnificationGesture` – Pinch to zoom in/out on photos.
- `RotationGesture` – Rotate photos with two fingers.
- `SimultaneousGesture` – Combine pinch and rotate together.

### Data Management (Persistence)
- `ScavengerStore` class with `ObservableObject` – Central data store.
- `@Published` – Auto‑refresh UI when data changes.
- `@Binding` – Two‑way data binding between views.
- `@EnvironmentObject` – Share data store across all views.
- **Codable** – Items, progress, image filenames, and shape indices saved to `scavengerItems.json`.
- **UIImage extensions** – Save, load, and delete photos from the app’s Documents folder.
- **ScenePhase** – Auto‑save when app becomes inactive.

### Assets & Design
- `AppIcon` – Custom app icon for home screen.
- `LaunchColor` – Custom launch screen background colour.
- **11 default image sets** – bakery, book, coffee, comp, gym, icecream, library, mall, movie, park, restaurant.
- **Professional colour system** (`AppColors.swift`) – Primary, secondary, semantic, neutral colours and gradients.

### Photo Features (PhotosUI)
- `PhotosPicker` – Select photos from user’s photo library.
- `loadTransferable` – Async loading of selected photos.
- `Task` – Background thread for photo loading.
- `MainActor.run` – UI updates on main thread.
- **Photo Library Permissions** – Access requested via Info.plist.

### Shape Features (Chapter 18)
- **10 custom shapes** – Circle, Rectangle, Diamond, Star, Heart, Hexagon, Pentagon, Cone, Lens, Triangle.
- `ShapeSelectionModal` – Grid of shapes with live preview.
- Custom binding saves shape immediately and updates both detail view and grid.
- `clipShape(Shapes.all[item.shapeIndex])` – Applied consistently everywhere.

### Animation (Chapter 21)
- **Animated splash screen** – Letters drop with spring delays (`SplashScreenView`).
- **Transition** – Crossfade + scale from splash to welcome (`AppLoadingView`).

### Game Features
- `WelcomeScreen` – App introduction and instructions.
- **10 default items** – Coffee Shop, Movie Theatre, Book Store, Restaurant, Library, Gym, Park, Bakery, Mall, Ice Cream Shop.
- **Add custom items** – Green “Add” button creates new items with name and clue.
- **Take real photos** – From device library using `PhotosPicker`.
- **Choose default photos** – Modal with 11 asset images as instant “proof”.
- **Remove photo** – Red button to delete current photo.
- **Apply shapes** – Tap “Add Shape” / “Change Shape” to clip the photo.
- **Mark as Found** – Button turns red when photo taken but not yet marked.
- **Done button** – Only enabled when **both** photo exists **and** mark as found is tapped.
- **Progress tracking** – Visual progress bar and counter (only counts fully completed items).
- **Reward system** – 5+ items = 10% off, 7+ items = 20% off, 10 items = $5,000 grand prize entry.
- **Submit results** – Share discount code via native share sheet.
- **Reset game** – Clears all progress and deletes saved photos (custom items remain).

## How to Run
1. Open `ScavengerHunt.xcodeproj` in Xcode.
2. Select an iPhone simulator (iPhone 17 Pro or later).
3. Press `Command + R`.
4. Grant photo library access when prompted.

## How to Play
1. Tap **“Start Hunt”** on the welcome screen.
2. Tap any item to see its clue.
3. Tap **“Take Photo”** (or **“Choose Default”**) to add a photo.
4. Pinch or rotate the photo to view details (gestures).
5. Tap **“Add Shape”** and select a shape to clip the photo.
6. Tap **“Mark as Found”** (the button turns red after photo taken).
7. Tap **“Done”** to save and return to the list.
8. Find **5+ items** → tap **“Submit”** to share your discount code.
9. Tap **“Reset”** to start a new game (or **“Add”** to create custom items).

## Technologies
- SwiftUI
- PhotosUI
- Combine (for `ObservableObject` and `objectWillChange`)
- Xcode 16.2
- iOS 18

## Author
Sheikh Naim

## GitHub Repository
[https://github.com/snaimio/iOSApp2](https://github.com/snaimio/iOSApp2)
