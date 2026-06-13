import SwiftUI

// This screen shows an animated splash (logo + letters dropping in)
// before the main app appears. It uses spring animations for a playful feel.

struct SplashScreenView: View {
    
    // Controls whether the letters have dropped into place.
    // Starts false, becomes true when the view appears.
    
    @State private var animateLetters = false
    
    // The letters that make up "SCAVENGER"
    
    let letters = ["S", "C", "A", "V", "E", "N", "G", "E", "R"]
    
    // Colours for each letter – taken from our AppColors palette.
    
    let colors: [Color] = [
        Color(hex: "#1B4D8C"),  // S – sapphire
        Color(hex: "#2DAA9E"),  // C – emerald
        Color(hex: "#FF6B6B"),  // A – coral
        Color(hex: "#6B4EFF"),  // V – royal purple
        Color(hex: "#48CAE4"),  // E – ocean breeze
        Color(hex: "#FF9F1C"),  // N – amber
        Color(hex: "#2DAA9E"),  // G – emerald
        Color(hex: "#FF6B6B"),  // E – coral
        Color(hex: "#1B4D8C")   // R – sapphire
    ]
    
    var body: some View {
        ZStack {
            
            // Very subtle gradient background (almost white but with a hint of blue/purple)
            
            LinearGradient(
                colors: [Color(hex: "#1B4D8C").opacity(0.12),
                         Color(hex: "#6B4EFF").opacity(0.12)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // Binoculars icon, grows from small to normal size with a spring.
                
                Image(systemName: "binoculars.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "#1B4D8C"))
                    .scaleEffect(animateLetters ? 1 : 0.3)
                    .opacity(animateLetters ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2),
                               value: animateLetters)
                
                // The letters "SCAVENGER", each drops from above with a spring and a random slight rotation.
                
                HStack(spacing: 6) {
                    ForEach(Array(letters.enumerated()), id: \.offset) { index, letter in
                        Text(letter)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(colors[index])
                        
                            // Start position: 300 points above, then animate to 0.
                        
                            .offset(y: animateLetters ? 0 : -300)
                            .rotationEffect(.degrees(animateLetters ? 0 : Double.random(in: -30...30)))
                            .animation(.spring(duration: 0.7, bounce: 0.5).delay(Double(index) * 0.07),
                                       value: animateLetters)
                    }
                }
                
                // "HUNT" word, appears a little later, also with a spring.
                
                HStack(spacing: 8) {
                    Text("H").foregroundColor(Color(hex: "#1B4D8C"))
                    Text("U").foregroundColor(Color(hex: "#2DAA9E"))
                    Text("N").foregroundColor(Color(hex: "#FF9F1C"))
                    Text("T").foregroundColor(Color(hex: "#6B4EFF"))
                }
                .font(.system(size: 36, weight: .black))
                .opacity(animateLetters ? 1 : 0)
                .offset(y: animateLetters ? 0 : 50)
                .animation(.spring(duration: 0.6, bounce: 0.3).delay(0.85),
                           value: animateLetters)
                
                // Tagline, fades in last.
                
                Text("Find 10 hidden treasures!")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .opacity(animateLetters ? 1 : 0)
                    .animation(.easeIn.delay(1.1), value: animateLetters)
            }
        }
        .onAppear {
            
            // Trigger all animations when the view first appears.
            
            animateLetters = true
        }
    }
}

#Preview {
    SplashScreenView()
}
