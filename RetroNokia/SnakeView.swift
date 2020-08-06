import SwiftUI

struct GridView<Cell: View>: View {
    typealias CellBuilder = (_ row: Int, _ column: Int) -> Cell
    let rows: Int
    let columns: Int
    let spacing: CGFloat
    let cellBuilder: CellBuilder
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignMent: VerticalAlignment

    init(rows: Int,
         columns: Int,
         spacing: CGFloat = 2,
         horizontalAlignment: HorizontalAlignment = .center,
         verticalAlignMent: VerticalAlignment = .center,
         cellBuilder: @escaping CellBuilder) {
        self.rows = rows
        self.columns = columns
        self.spacing = spacing
        self.cellBuilder = cellBuilder
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignMent = verticalAlignMent
    }

    private func cellSize(inFrame size: CGSize) -> CGFloat {
        let cellHeight = CGFloat(size.height - spacing * CGFloat(rows)) / CGFloat(rows)
        let cellWidth = CGFloat(size.width - spacing * CGFloat(columns)) / CGFloat(columns)
        let cellSize = min(cellHeight, cellWidth).rounded(.down)
        return max(cellSize, 0)
    }

    private func cellPositionInGrid(index: Int, size: CGSize) -> CGFloat {
        let cellSize = self.cellSize(inFrame: size)
        let halfCellSize = cellSize / 2
        let allCellsSize = CGFloat(index) * cellSize
        let space = CGFloat(index) * spacing
        return halfCellSize + allCellsSize + space
    }

    private func cellOffsetX(index: Int, size: CGSize) -> CGFloat {
        let position = cellPositionInGrid(index: index, size: size)
        let remainderWidth = size.width - frameSize(size: size).width

        switch horizontalAlignment {
        case .leading:
            return position
        case .center:
            return position + (remainderWidth / 2).rounded(.down)
        case .trailing:
            return position + remainderWidth
        default:
            return position + (remainderWidth / 2).rounded(.down)
        }
    }

    private func cellOffsetY(index: Int, size: CGSize) -> CGFloat {
        let position = cellPositionInGrid(index: index, size: size)
        let remainderHeight = size.height - frameSize(size: size).height

        switch verticalAlignMent {
        case .top:
            return position
        case .center:
            return position + (remainderHeight / 2).rounded(.down)
        case .bottom:
            return position + remainderHeight
        default:
            return position + (remainderHeight / 2).rounded(.down)
        }
    }

    private func cellAt(row: Int, column: Int, size: CGSize) -> some View {
        self.cellBuilder(row, column)
            .frame(width: self.cellSize(inFrame: size),
                   height: self.cellSize(inFrame: size),
                   alignment: .center)
            .position(x: self.cellOffsetX(index: column, size: size),
                      y: self.cellOffsetY(index: row, size: size))
    }

    private func frameSize(size: CGSize) -> CGSize {
        let cellSize = self.cellSize(inFrame: size)
        return CGSize(width: cellSize * CGFloat(columns) + spacing * CGFloat(columns - 1),
                      height: cellSize * CGFloat(rows) + spacing * CGFloat(rows - 1))
    }

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<self.rows) { row in
                ForEach(0..<self.columns) { column in
                    self.cellAt(row: row, column: column, size: geometry.size)
                }
            }
//                .frame(width: self.frameSize(size: geometry.size).width,
//                       height: self.frameSize(size: geometry.size).height,
//                       alignment: .center)
        }
    }
}

extension Color {
    static let snail = Color(0x29382c)
    static let food = Color(0x212d23)
    static let background = Color(0x7ea082)
}




extension Color {
    init(_ value: Int) {
        let red = Double(value >> 16 & 0xff) / 255.0
        let green = Double(value >> 8 & 0xff) / 255.0
        let blue = Double(value & 0xff) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

