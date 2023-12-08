//
//  CellView.swift
//  Lab5
//
//  Created by user on 08.12.2023.
//

import SwiftUI

struct CellView: View {
    let image: String
    let text: String
    let shapeType: ShapeType
    
    var body: some View {
        NavigationLink(destination: DetailScreen(shapeType: shapeType)) {
            VStack {
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                
                Text(text)
                    .font(.caption)
                    .padding(.bottom, -4)
            }
            .frame(width: 120, height: 120)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
}
