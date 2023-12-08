import SwiftUI

struct ImportView: View {
    var body: some View {
        Text("Import Screen")
    }
}

struct ContentView: View {
    
    @State private var selectedShape: ShapeType = .line
    @State private var width: CGFloat = 3
    @State private var isDrawing = false
    
    @ObservedObject var curves: ObservableArray<Curve> = ObservableArray(array: [])
    @ObservedObject var lines: ObservableArray<LineShape> = ObservableArray(array: [])
    @ObservedObject var ellipses: ObservableArray<EllipseShape> = ObservableArray(array: [])
    @ObservedObject var rectangles: ObservableArray<RectShape> = ObservableArray(array: [])
    @ObservedObject var dumbbells: ObservableArray<Dumbbell> = ObservableArray(array: [])
    @ObservedObject var cubes: ObservableArray<CubeShape> = ObservableArray(array: [])
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack(spacing: 10) {
                        ForEach(ShapeType.allCases, id: \.self) { type in
                            ToolButton(
                                selectedTool: $selectedShape,
                                tool: type
                            )
                        }
                    }
                    .padding()
                    
                    HStack {
                        Button("Очистити", action: {
                            clearShapes()
                            DataManager.shared.clear()
                        })
                        .frame(width: 100, height: 30)
                        .foregroundColor(.white)
                        .background(.red)
                        .cornerRadius(10)
                        Spacer()
                    }
                }
                .padding()
                
                Divider()
                
                Canvas { context, size in
                    updateCurves(context: context)
                    updateStraights(context: context)
                    updateCubes(context: context)
                    updateEllipses(context: context)
                    updateRectangles(context: context)
                    updateDumbbells(context: context)
                }
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        isDrawing = true
                        
                        switch selectedShape {
                        case .line:
                            drawLine(value: value)
                        case .ellipse:
                            drawEllipse(value: value)
                        case .rect:
                            drawRect(value: value)
                        case .dumbbell:
                            drawDumbbell(value: value)
                        case .cube:
                            drawCube(value: value)
                        default:
                            drawPoint(value: value)
                        }
                    }
                              )
                        .onEnded({ value in
                            let firstPoint = value.startLocation
                            let lastPoint = value.location
                            DataManager.shared.appendCurve(shape: SavedShape(startPoint: firstPoint,
                                                                             endPoint: lastPoint),
                                                           type: selectedShape)
                            isDrawing = false
                        }))
                Divider()
            }
            .navigationBarItems(trailing:
                 NavigationLink(destination: AllShapes()) {
                     Image(systemName: "tablecells")
                         .imageScale(.large)
                 }
             )
            .navigationBarTitle("Paint", displayMode: .inline)
        }
    }
    
    // MARK: Helpers
    
    private func clearShapes() {
        curves.array = []
        lines.array = []
        ellipses.array = []
        rectangles.array = []
        dumbbells.array = []
        cubes.array = []
    }
    
    private func updateCurves(context: GraphicsContext) {
        for line in curves.array {
            var path = Path()
            path.addLines(line.points)
            
            let defaultStyle = StrokeStyle(lineWidth: line.lineWidth)
            let style = StrokeStyle(lineWidth: line.lineWidth, dash: [5])
            
            
            if line === curves.array.last && selectedShape == .curve {
                context.stroke(path, with: .color(line.color), style: isDrawing ? style : defaultStyle)
            } else {
                context.stroke(path, with: .color(line.color), style: defaultStyle)
            }
        }
    }
    
    private func updateStraights(context: GraphicsContext) {
        for straight in lines.array {
            var path = Path()
            path.addLines(straight.points)
            
            let defaultStyle = StrokeStyle(lineWidth: straight.lineWidth)
            let style = StrokeStyle(lineWidth: straight.lineWidth, dash: [5])
            
            if straight === lines.array.last && selectedShape == .line {
                context.stroke(path, with: .color(straight.color), style: isDrawing ? style : defaultStyle)
            } else {
                context.stroke(path, with: .color(straight.color), style: defaultStyle)
            }
        }
    }
    
    private func updateEllipses(context: GraphicsContext) {
        for ellipse in ellipses.array {
            var path = Path()
            path.addEllipse(in: CGRect(origin: ellipse.origin, size: CGSize(width: ellipse.width, height: ellipse.height)))
            
            let defaultStyle = StrokeStyle(lineWidth: ellipse.lineWidth)
            let style = StrokeStyle(lineWidth: ellipse.lineWidth, dash: [5])
            
            
            if ellipse === ellipses.array.last && selectedShape == .ellipse {
                context.stroke(path, with: .color(ellipse.color), style: isDrawing ? style : defaultStyle)
            } else {
                context.stroke(path, with: .color(ellipse.color), style: defaultStyle)
            }
        }
    }
    
    private func updateRectangles(context: GraphicsContext) {
        for rectangle in rectangles.array {
            var path = Path()
            path.addRect(CGRect(origin: rectangle.origin, size: CGSize(width: rectangle.width, height: rectangle.height)))
            
            let defaultStyle = StrokeStyle(lineWidth: rectangle.lineWidth)
            let style = StrokeStyle(lineWidth: rectangle.lineWidth, dash: [5])
            
            if rectangle === rectangles.array.last && selectedShape == .rect {
                context.stroke(path, with: .color(rectangle.color), style: isDrawing ? style : defaultStyle)
            } else {
                context.stroke(path, with: .color(rectangle.color), style: defaultStyle)
            }
        }
    }
    
    private func updateDumbbells(context: GraphicsContext) {
        for dumbbell in dumbbells.array {
            var linePath = Path()
            var ellipsesPath = Path()
            linePath.addLines(dumbbell.points)
            ellipsesPath.addEllipse(in: CGRect(origin: dumbbell.firstOrigin, size: CGSize(width: dumbbell.width, height: dumbbell.height)))
            ellipsesPath.addEllipse(in: CGRect(origin: dumbbell.secondOrigin, size: CGSize(width: dumbbell.width, height: dumbbell.height)))
            
            let defaultStyle = StrokeStyle(lineWidth: dumbbell.lineWidth)
            let style = StrokeStyle(lineWidth: dumbbell.lineWidth, dash: [5])
            context.fill(ellipsesPath, with: .color(dumbbell.color))
            
            if dumbbell === dumbbells.array.last && selectedShape == .dumbbell {
                context.stroke(linePath, with: .color(dumbbell.color), style: isDrawing ? style : defaultStyle)
            } else {
                context.stroke(linePath, with: .color(dumbbell.color), style: defaultStyle)
            }
        }
    }
    
    private func updateCubes(context: GraphicsContext) {
        for cube in cubes.array {
            var path = Path()
            path.addRect(CGRect(origin: cube.origin, size: CGSize(width: cube.width, height: cube.height)))
            
            path.addRect(CGRect(origin: cube.secondOrigin, size: CGSize(width: cube.width, height: cube.height)))
            
            path.addLines([cube.firstOrigin, cube.secondOrigin])
            
            path.addLines([CGPoint(x: cube.firstOrigin.x + cube.width, y: cube.firstOrigin.y),
                           CGPoint(x: cube.secondOrigin.x + cube.width, y: cube.secondOrigin.y)])
            
            path.addLines([CGPoint(x: cube.firstOrigin.x, y: cube.firstOrigin.y + cube.height),
                           CGPoint(x: cube.secondOrigin.x, y: cube.secondOrigin.y + cube.height)])
            
            path.addLines([CGPoint(x: cube.firstOrigin.x + cube.width, y: cube.firstOrigin.y + cube.height),
                           CGPoint(x: cube.secondOrigin.x + cube.width, y: cube.secondOrigin.y + cube.height)])
            
            let defaultStyle = StrokeStyle(lineWidth: cube.lineWidth)
            let style = StrokeStyle(lineWidth: cube.lineWidth, dash: [5])
            if cube === cubes.array.last && selectedShape == .cube {
                context.stroke(path, with: .color(cube.color), style: isDrawing ? style : defaultStyle)
            } else {
                context.stroke(path, with: .color(cube.color), style: defaultStyle)
            }
        }
    }
    
    private func drawLine(value: DragGesture.Value) {
        let lastPoint = value.location
        if value.translation.width + value.translation.height == 0 {
            let firstPoint = value.location
            lines.array.append(LineShape(points: [firstPoint],
                                         color: selectedShape.color,
                                         lineWidth: width))
        } else {
            let index = lines.array.count - 1
            
            if lines.array[index].points.count == 2 {
                lines.objectWillChange.send()
                lines.array[index].points[1] = lastPoint
            } else {
                lines.array[index].points.append(lastPoint)
            }
        }
    }
    
    private func drawRect(value: DragGesture.Value) {
        if value.translation.width + value.translation.height == 0 {
            let firstPoint = value.startLocation
            rectangles.array.append(RectShape(origin: firstPoint,
                                              width: 0,
                                              height: 0,
                                              color: selectedShape.color,
                                              lineWidth: width))
        } else {
            let index = rectangles.array.count - 1
            rectangles.objectWillChange.send()
            rectangles.array[index].width = value.translation.width
            rectangles.array[index].height = value.translation.height
        }
    }
    
    private func drawDumbbell(value: DragGesture.Value) {
        let lastPoint = value.location
        if value.translation.width + value.translation.height == 0 {
            let firstPoint = value.location
            let origin = CGPoint(x: value.location.x - 15,
                                 y: value.location.y - 15)
            dumbbells.array.append(Dumbbell(firstOrigin: origin,
                                            secondOrigin: origin,
                                            points: [firstPoint],
                                            color: selectedShape.color,
                                            lineWidth: width))
        } else {
            let index = dumbbells.array.count - 1
            
            if dumbbells.array[index].points.count == 2 {
                dumbbells.objectWillChange.send()
                dumbbells.array[index].points[1] = lastPoint
                let origin = CGPoint(x: value.location.x - 15,
                                     y: value.location.y - 15)
                dumbbells.array[index].secondOrigin = origin
            } else {
                dumbbells.array[index].points.append(lastPoint)
            }
        }
    }
    
    private func drawCube(value: DragGesture.Value) {
        if value.translation.width + value.translation.height == 0 {
            let firstPoint = value.startLocation
            cubes.array.append(CubeShape(firstOrigin: firstPoint,
                                         width: 0,
                                         height: 0,
                                         color: selectedShape.color,
                                         lineWidth: width))
        } else {
            let index = cubes.array.count - 1
            cubes.objectWillChange.send()
            cubes.array[index].width = value.translation.width
            cubes.array[index].height = value.translation.height
        }
    }
    
    private func drawEllipse(value: DragGesture.Value) {
        if value.translation.width + value.translation.height == 0 {
            let firstPoint = value.startLocation
            ellipses.array.append(EllipseShape(origin: firstPoint,
                                               width: 0,
                                               height: 0,
                                               color: selectedShape.color,
                                               lineWidth: width))
        } else {
            let index = ellipses.array.count - 1
            ellipses.objectWillChange.send()
            ellipses.array[index].width = value.translation.width
            ellipses.array[index].height = value.translation.height
        }
    }
    
    private func drawPoint(value: DragGesture.Value) {
        let lastPoint = value.location
        if value.translation.width + value.translation.height == 0 {
            let firstPoint = value.startLocation
            curves.array.append(Curve(points: [lastPoint],
                                      color: selectedShape.color,
                                      lineWidth: width))
        } else {
            let index = curves.array.count - 1
            curves.objectWillChange.send()
            curves.array[index].points.append(lastPoint)
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

