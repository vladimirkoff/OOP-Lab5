import SwiftUI

struct AllShapes: View {
    let numberOfCells = 6
    let cellSize: CGFloat = 120
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.fixed(cellSize), spacing: 10),
                GridItem(.fixed(cellSize), spacing: 10),
                GridItem(.fixed(cellSize), spacing: 10),
            ], spacing: 20) {
                ForEach(0..<numberOfCells) { index in
                    CellView(image: ShapeType.allCases[index].image, text: "Кількість - \(DataManager.shared.getShapes(type: ShapeType.allCases[index]).count)", shapeType: ShapeType.allCases[index] )
                        .frame(width: cellSize, height: cellSize)
                }
            }
            .padding()
        }
        .navigationBarTitle("Фігури", displayMode: .inline)
    }
}

struct AllShapes_Previews: PreviewProvider {
    static var previews: some View {
        AllShapes()
    }
}



