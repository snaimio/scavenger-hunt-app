import SwiftUI

// ================================================================
// CUSTOM SHAPES – used to clip the user's photos.
// Each shape defines a path (lines, arcs, curves) inside a given rectangle.
// The path is drawn relative to the rectangle's size, so it scales automatically.
// ================================================================

// Triangle, three straight lines: top centre, bottom right, bottom left.

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        var path = Path()
        
        // Move to the top centre point.
        
        path.move(to: CGPoint(x: width * 0.5, y: 0))
        
        // Draw line to bottom right.
        
        path.addLine(to: CGPoint(x: width, y: height))
        
        // Draw line to bottom left.
        
        path.addLine(to: CGPoint(x: 0, y: height))
        
        // Close the path – connects back to the start point.
        
        path.closeSubpath()
        return path
    }
}

// Cone, a semi‑circle (arc) with a straight bottom edge.

struct Cone: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // The radius is half the smaller side, so the arc fits nicely.
        
        let radius = min(rect.midX, rect.midY)
        
        // Draw a 180° arc (from right edge to left edge, clockwise).
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: radius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(180),
                    clockwise: true)
        
        // From the end of the arc (left side), go straight down to the bottom middle.
        
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
        
        // Then back to the right side of the arc.
        
        path.addLine(to: CGPoint(x: rect.midX + radius, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

// Lens, an eye‑like shape made from two quadratic curves.
// Quadratic curves use a start point, an end point, and one control point.

struct Lens: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start at the left middle edge.
        
        path.move(to: CGPoint(x: 0, y: rect.midY))
        
        // Upper curve: from left middle to right middle, control point at top centre.
        
        path.addQuadCurve(to: CGPoint(x: rect.width, y: rect.midY),
                          control: CGPoint(x: rect.midX, y: 0))
        
        // Lower curve: back to left middle, control point at bottom centre.
        
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.midY),
                          control: CGPoint(x: rect.midX, y: rect.height))
        path.closeSubpath()
        return path
    }
}

// Diamond, a four‑pointed shape (like a rotated square).

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Top point.
        
        path.move(to: CGPoint(x: rect.midX, y: 0))
        
        // Right point.
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        
        // Bottom point.
        
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
        
        // Left point.
        
        path.addLine(to: CGPoint(x: 0, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

// Star, a 5‑pointed star made by alternating outer and inner radius points.

struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let centerX = rect.midX
        let centerY = rect.midY
        let outerRadius = min(width, height) / 2
        let innerRadius = outerRadius * 0.4   // how far the inner points go inward
        var points: [CGPoint] = []
        
        // We need 10 points: outer, inner, outer, inner, …
        
        for i in 0..<10 {
            
            // Each step is 36 degrees (360°/10). Subtract 90° so that the top point is straight up.
            
            let angle = Double(i) * 36.0 - 90
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let radians = angle * .pi / 180
            points.append(CGPoint(x: centerX + radius * cos(radians),
                                  y: centerY + radius * sin(radians)))
        }
        
        // Draw lines between all points in order.
        
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}

// Heart, a classic heart shape using cubic Bézier curves.
// A cubic curve has two control points that "pull" the curve.

struct Heart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Start at the bottom centre (the point of the heart).
        
        path.move(to: CGPoint(x: width * 0.5, y: height * 0.85))
        
        // Left side curve: from bottom centre to left middle.
        
        path.addCurve(to: CGPoint(x: 0, y: height * 0.35),
                      control1: CGPoint(x: width * 0.5, y: height * 0.65),
                      control2: CGPoint(x: 0, y: height * 0.55))
        
        // Left top lobe: from left middle to top centre.
        
        path.addCurve(to: CGPoint(x: width * 0.5, y: height * 0.2),
                      control1: CGPoint(x: 0, y: height * 0.15),
                      control2: CGPoint(x: width * 0.35, y: height * 0.05))
        
        // Right top lobe: from top centre to right middle.
        
        path.addCurve(to: CGPoint(x: width, y: height * 0.35),
                      control1: CGPoint(x: width * 0.65, y: height * 0.05),
                      control2: CGPoint(x: width, y: height * 0.15))
        
        // Right side curve: back to bottom centre.
        
        path.addCurve(to: CGPoint(x: width * 0.5, y: height * 0.85),
                      control1: CGPoint(x: width, y: height * 0.55),
                      control2: CGPoint(x: width * 0.5, y: height * 0.65))
        path.closeSubpath()
        return path
    }
}

// Hexagon, six‑sided polygon.

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let centerX = rect.midX
        let centerY = rect.midY
        let radius = min(width, height) / 2
        
        // Angles for each vertex (0°, 60°, 120°, …)
        
        let angles: [Double] = [0, 60, 120, 180, 240, 300]
        
        // Convert each angle to a point on the circle.
        
        let points = angles.map { angle in
            let radians = angle * .pi / 180
            return CGPoint(x: centerX + radius * cos(radians),
                           y: centerY + radius * sin(radians))
        }
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}

// Pentagon – five‑sided polygon, rotated so that one point is at the top.

struct Pentagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let centerX = rect.midX
        let centerY = rect.midY
        let radius = min(width, height) / 2
        
        // Angles for a pentagon (starting at -90° = top)
        
        let angles: [Double] = [-90, -18, 54, 126, 198]
        let points = angles.map { angle in
            let radians = angle * .pi / 180
            return CGPoint(x: centerX + radius * cos(radians),
                           y: centerY + radius * sin(radians))
        }
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}

// ================================================================
// COLLECTION OF ALL SHAPES
// I need an array that can hold different types of Shape.
// Shape is a protocol with an associated type, so I cannot write `[Shape]`.
// `AnyShape` is a "type eraser" provided by SwiftUI – it wraps any shape
// and lets us store them together in the same array.
// ================================================================

enum Shapes {
    
    // All 10 shapes, wrapped in AnyShape.
    
    static let all: [AnyShape] = [
        AnyShape(Circle()),       // built‑in circle
        AnyShape(Rectangle()),    // built‑in rectangle
        AnyShape(Diamond()),
        AnyShape(Star()),
        AnyShape(Heart()),
        AnyShape(Hexagon()),
        AnyShape(Pentagon()),
        AnyShape(Cone()),
        AnyShape(Lens()),
        AnyShape(Triangle())
    ]
    
    
    // User‑friendly names for the shape picker modal.
    
    static let names: [String] = [
        "Circle", "Rectangle", "Diamond", "Star", "Heart",
        "Hexagon", "Pentagon", "Cone", "Lens", "Triangle"
    ]
}
