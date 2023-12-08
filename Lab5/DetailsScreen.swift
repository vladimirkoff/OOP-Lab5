//
//  DetailsScreen.swift
//  Lab5
//
//  Created by user on 08.12.2023.
//

import SwiftUI

struct DetailScreen: View {
    let shapeType: ShapeType
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(DataManager.shared.getShapes(type: shapeType), id: \.self) { shape in
                        Text("Координати: (\(String(format: "%.3f", shape.startPoint.x)), \(String(format: "%.3f", shape.startPoint.y))) -> (\(String(format: "%.3f", shape.endPoint.x)), \(String(format: "%.3f", shape.endPoint.y)))")
                    }
                }
            }
            .navigationBarTitle("Деталі", displayMode: .inline)
        }
    }
}
