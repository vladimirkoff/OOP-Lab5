//
//  ShapeType.swift
//  Lab4
//
//  Created by Vladimir Kovalev on 14.11.2023.
//

import SwiftUI

enum ShapeType: String, CaseIterable {
    case rect = "Квадрат"
    case ellipse = "Еліпс"
    case cube = "Куб"
    case curve = "Крива"
    case line = "Пряма"
    case dumbbell = "Гантеля"

    var image: String {
        switch self {
        case .rect:
            return "square.fill"
        case .ellipse:
            return "circle.fill"
        case .cube:
            return "cube.fill"
        case .curve:
            return "scribble.variable"
        case .line:
            return "line.diagonal"
        case .dumbbell:
            return "dumbbell.fill"
        }
    }
    
    var imageColor: Color {
        switch self {
        case .rect:
            return Color.blue
        case .ellipse:
            return Color.green
        case .cube:
            return Color.red
        case .curve:
            return Color.orange
        case .line:
            return Color.purple
        case .dumbbell:
            return Color.yellow
        }
    }
    
    var color: Color {
        switch self {
        case .rect:
            return Color.blue
        case .ellipse:
            return Color.green
        case .cube:
            return Color.red
        case .curve:
            return Color.orange
        case .line:
            return Color.purple
        case .dumbbell:
            return Color.yellow
        }
    }
}
