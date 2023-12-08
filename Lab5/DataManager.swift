
import Foundation

final class DataManager {
    
    static let shared = DataManager()
    private init() {}

    private var curves: [SavedShape] = []
    private var lines: [SavedShape] = []
    private var ellipses: [SavedShape] = []
    private var rectangles: [SavedShape] = []
    private var dumbbells: [SavedShape] = []
    private var cubes: [SavedShape] = []
    
    func appendCurve(shape: SavedShape, type: ShapeType) {
        switch type {
        case .rect:
            rectangles.append(shape)
        case .ellipse:
            ellipses.append(shape)
        case .cube:
            cubes.append(shape)
        case .curve:
            curves.append(shape)
        case .line:
            lines.append(shape)
        case .dumbbell:
            dumbbells.append(shape)
        }
    }
    
    func getShapes(type: ShapeType) -> [SavedShape] {
        switch type {
        case .rect:
            return rectangles
        case .ellipse:
            return ellipses
        case .cube:
            return cubes
        case .curve:
            return curves
        case .line:
            return lines
        case .dumbbell:
            return dumbbells
        }
    }
    
    func clear() {
        curves.removeAll()
        cubes.removeAll()
        ellipses.removeAll()
        rectangles.removeAll()
        dumbbells.removeAll()
        lines.removeAll()
    }
}
