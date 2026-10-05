<div align="center">

# 🔍 Scavenger Hunt
### Native iOS Interactive Exploration, Photo Proof & Gesture Manipulation Suite

[![iOS](https://img.shields.io/badge/iOS-17.0%2B-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-F05138?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-0071E3?style=for-the-badge&logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
[![PhotosUI](https://img.shields.io/badge/Framework-PhotosUI-FF2D55?style=for-the-badge)](https://developer.apple.com/documentation/photokit)
[![Architecture](https://img.shields.io/badge/Architecture-ObservableObject%20Store-8B5CF6?style=for-the-badge)](https://developer.apple.com/)
[![License](https://img.shields.io/badge/License-MIT-CEFF00?style=for-the-badge&logoColor=black)](LICENSE)

<br/>

**A production-ready native iOS gamified exploration application engineered with SwiftUI, PhotosUI media picking, multi-touch gesture processing, custom vector shape clipping, and local JSON persistence.**

<br/>

[Core Architecture](#-core-architecture--technical-highlights) •
[Feature Breakdown](#-features--capabilities) •
[Project Structure](#-project-structure) •
[Setup & Run](#-how-to-build-and-run) •
[License](#-license)

</div>

<br/>

---

## 📌 Technical Overview

**Scavenger Hunt** is an interactive location-based discovery game designed for iOS 17+. Users solve localized clues, capture photo proof via Apple's `PhotosUI` framework, manipulate photos using combined multi-touch gestures, apply vector clipping masks, and track real-time progress toward unlocking promotional reward tiers.

---

## 🏛️ Core Architecture & Technical Highlights

### 💼 Key Engineering Competencies Demonstrated:
- **PhotosUI & Async Concurrency**: Seamless photo import via `PhotosPicker` utilizing `loadTransferable(type:)` on background `Task` workers with UI synchronization on `@MainActor`.
- **Multi-Touch Gesture Engine**: Advanced gesture handling combining `MagnificationGesture` and `RotationGesture` through `SimultaneousGesture` for fluid photo inspection.
- **Dynamic Vector Shape Clipping**: Custom geometric mask generator (Circle, Diamond, Star, Heart, Hexagon, Pentagon, Cone, Lens, Triangle) rendered via `clipShape`.
- **Local Persistence & Lifecycle Auto-Save**: Fully offline-capable persistence storing item states, custom clues, and shape indices in `scavengerItems.json` via Swift `Codable`, with automated saving triggered on `ScenePhase` transitions.
- **Centralized Reactive State**: `ScavengerStore` observable data pipeline broadcasting state mutations via `@Published` and shared across views with `@EnvironmentObject`.

---

## 📱 Features & Capabilities

### 1. 🧭 Navigation & Visual Experience
- **Type-Safe Navigation**: Structured navigation flows using `NavigationStack` and `.navigationDestination`.
- **Fluid Spring Animations**: Physics-based splash sequence with staggered letter-drop spring animations (`SplashScreenView`) and crossfade scale transitions.
- **Adaptive Color System**: Centralized design tokens (`AppColors.swift`) supporting dynamic contrast, semantic status indicators, and gradient fills.

### 2. 📸 Photo Capture & Interactive Manipulation
- **System PhotosPicker**: Native permission-managed photo library selection.
- **Multi-Touch Manipulation**: Real-time two-finger zoom scaling and 360° rotation physics.
- **Custom Vector Masking**: 10 selectable geometric shapes with live grid preview and instantaneous clipping application.
- **On-Device Storage**: High-performance image write/read operations directly within the app's sandboxed Documents folder.

### 3. 🎯 Gamification & Reward Pipeline
- **Clue Discovery Hub**: Built-in default destinations (Coffee Shop, Library, Bookstore, Bakery, Park) with custom clue creation capabilities.
- **Verification Workflow**: Enforces rigorous two-step verification (photo capture + explicit mark-as-found confirmation).
- **Milestone Rewards Engine**: Dynamic reward computation (10% off at 5 items, 20% off at 7 items, and grand prize entries at 10 items).
- **Native Result Sharing**: System share sheet integration for exporting verified discount credentials.

---

## 📁 Project Structure

```
ScavengerHunt/
├── App/
│   └── ScavengerHuntApp.swift        # App entry point & environment setup
├── Models/
│   ├── ScavengerItem.swift           # Codable item schema & shape indices
│   └── Shapes.swift                  # 10 custom vector shape definitions
├── Store/
│   └── ScavengerStore.swift          # ObservableObject state manager & disk I/O
├── Views/
│   ├── SplashScreenView.swift        # Spring animation launch sequence
│   ├── WelcomeView.swift             # Onboarding & gameplay overview
│   ├── ItemListView.swift            # Progress tracking & category grid
│   ├── ItemDetailView.swift          # Clue inspection, camera HUD & gestures
│   ├── ShapeSelectionModal.swift     # 10-shape geometric selection grid
│   └── AddItemView.swift             # Custom user-created item modal
├── Extensions/
│   ├── UIImage+Extensions.swift      # Documents folder file read/write
│   └── AppColors.swift               # Semantic color token definitions
├── Resources/
│   ├── Assets.xcassets               # App icons & default destination assets
│   └── Info.plist                    # Photo library privacy permissions
└── ScavengerHunt.xcodeproj
```

---

## 🚀 How to Build and Run

### Prerequisites
- macOS Sonoma 14.0 or later
- **Xcode 15.0+** (or Xcode 16.x)
- **iOS 17.0+** Simulator or physical iPhone

### Setup Steps
1. **Clone the repository:**
   ```bash
   git clone https://github.com/snaimio/scavenger-hunt-app.git
   cd scavenger-hunt-app
   ```

2. **Open in Xcode:**
   ```bash
   open ScavengerHunt.xcodeproj
   ```

3. **Build and Run:**
   - Select your target simulator (e.g. iPhone 15 Pro) and press `⌘ + R`.
   - Grant Photo Library permissions when prompted to enable custom photo proof.

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

---

## 👨‍💻 Author

**Sheikh Naim**  
*Mobile & Full-Stack Web Developer*  
- **LinkedIn**: [linkedin.com/in/snaimio](https://www.linkedin.com/in/snaimio)  
- **GitHub**: [@snaimio](https://github.com/snaimio)  
- **Portfolio**: [snaimio.github.io](https://snaimio.github.io)
