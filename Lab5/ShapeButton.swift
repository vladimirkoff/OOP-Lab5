//
//  ShapeButton.swift
//  Lab4
//
//  Created by Vladimir Kovalev on 14.11.2023.
//

import SwiftUI

struct ToolButton: View {
    @Binding var selectedTool: ShapeType
    
    let tool: ShapeType

    var body: some View {
        Button(action: {
            selectedTool = tool
        }) {
            Image(systemName: tool.image)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(tool.imageColor)
        }
        .contextMenu {
            Button(action: {
            }) {
                Text(tool.rawValue)
            }
        }
    }
}
