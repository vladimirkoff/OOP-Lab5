import SwiftUI
import Foundation
import Combine

protocol OriginReadable {
    var origin: CGPoint { get set }
    var width: CGFloat { get set }
    var height: CGFloat { get set }
}

protocol PointsReadable {
    var points: [CGPoint] { get set }
}

class ObservableArray<T>: ObservableObject {
    @Published var array:[T] = []

    init(array: [T]) {
        self.array = array
    }
}

class MyShape: ObservableObject {
    var color: Color
    var lineWidth: CGFloat
    
    init(color: Color, lineWidth: CGFloat) {
        self.color = color
        self.lineWidth = lineWidth
    }
}

class Curve: MyShape, PointsReadable {
    var points: [CGPoint]
    
    init(points: [CGPoint], color: Color, lineWidth: CGFloat) {
        self.points = points
        super.init(color: color, lineWidth: lineWidth)
    }
}

class LineShape: MyShape, PointsReadable {
    var points: [CGPoint]
    
    init(points: [CGPoint], color: Color, lineWidth: CGFloat) {
        self.points = points
        super.init(color: color, lineWidth: lineWidth)
    }
}

class EllipseShape: MyShape, OriginReadable {
    var origin: CGPoint
    var width: CGFloat
    var height: CGFloat
    
    init(origin: CGPoint, width: CGFloat, height: CGFloat, color: Color, lineWidth: CGFloat) {
        self.origin = origin
        self.width = width
        self.height = height
        super.init(color: color, lineWidth: lineWidth)
    }
}

class Dumbbell: LineShape {
    var firstOrigin: CGPoint
    var secondOrigin: CGPoint
    var width: CGFloat = 30
    var height: CGFloat = 30
    
    init(firstOrigin: CGPoint, secondOrigin: CGPoint, points: [CGPoint], color: Color, lineWidth: CGFloat) {
        self.firstOrigin = firstOrigin
        self.secondOrigin = secondOrigin
        super.init(points: points, color: color, lineWidth: lineWidth)
    }
}

class RectShape: MyShape, OriginReadable {
    var origin: CGPoint
    var width: CGFloat
    var height: CGFloat
    
    init(origin: CGPoint, width: CGFloat, height: CGFloat, color: Color, lineWidth: CGFloat) {
        self.origin = origin
        self.width = width
        self.height = height
        super.init(color: color, lineWidth: lineWidth)
    }
}

class CubeShape: RectShape {
    var firstOrigin: CGPoint
    var secondOrigin: CGPoint
    
    init(firstOrigin: CGPoint, width: CGFloat, height: CGFloat, color: Color, lineWidth: CGFloat) {
        self.firstOrigin = firstOrigin
        self.secondOrigin = CGPoint(x: firstOrigin.x + 40, y: firstOrigin.y - 40)
        super.init(origin: firstOrigin, width: width, height: height, color: color, lineWidth: lineWidth)
    }
    
}

struct SavedShape: Hashable {
    let startPoint: CGPoint
    let endPoint: CGPoint

    func hash(into hasher: inout Hasher) {
        hasher.combine(startPoint.x)
        hasher.combine(startPoint.y)
        hasher.combine(endPoint.x)
        hasher.combine(endPoint.y)
    }

    static func == (lhs: SavedShape, rhs: SavedShape) -> Bool {
        return lhs.startPoint == rhs.startPoint && lhs.endPoint == rhs.endPoint
    }
}
