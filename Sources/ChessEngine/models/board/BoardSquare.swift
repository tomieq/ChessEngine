//
//  BoardSquare.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation
import Logger

public struct BoardSquare {
    let column: BoardColumn
    let row: Int
    
    public var coordinates: (columnIndex: Int, row: Int) {
        (column.rawValue, row)
    }

    init?(_ column: BoardColumn?, _ row: Int) {
        guard row <= 8, row >= 1, let column = column else {
            return nil
        }
        self.row = row
        self.column = column
    }
    
    public init?(_ value: String) {
        guard value.count == 2,
              let firstLetter = value.first,
              let column = BoardColumn(firstLetter),
              let lastLetter = value.last,
              let row = Int("\(lastLetter)") else {
            L(BoardSquare.self).e("Invalid text address(\(value)) while creating BoardSquare")
            return nil
        }
        self.column = column
        self.row = row
    }
}

extension BoardSquare: Equatable {}
extension BoardSquare: Hashable {}
extension BoardSquare: Sendable {}

extension BoardSquare: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard value.count == 2,
              let firstLetter = value.first,
              let column = BoardColumn(firstLetter),
              let lastLetter = value.last,
              let row = Int("\(lastLetter)") else {
            L(BoardSquare.self).e("Invalid text address(\(value)) while creating BoardSquare")
            fatalError()
        }
        self.column = column
        self.row = row
    }
}

extension BoardSquare: CustomStringConvertible {
    public var description: String {
        "\(self.column.letter)\(self.row)"
    }
}

extension BoardSquare {
    public func move(_ direction: MoveDirection) -> BoardSquare? {
        switch direction {
        case .right:
            return BoardSquare(self.column.toRight, self.row)
        case .left:
            return BoardSquare(self.column.toLeft, self.row)
        case .up:
            return BoardSquare(self.column, self.row + 1)
        case .down:
            return BoardSquare(self.column, self.row - 1)
        case .upRight:
            return BoardSquare(self.column.toRight, self.row + 1)
        case .upLeft:
            return BoardSquare(self.column.toLeft, self.row + 1)
        case .downRight:
            return BoardSquare(self.column.toRight, self.row - 1)
        case .downLeft:
            return BoardSquare(self.column.toLeft, self.row - 1)
        }
    }
}

extension BoardSquare {
    func squares(to direction: MoveDirection) -> [BoardSquare] {
        var moves: [BoardSquare?] = []
        var square: BoardSquare? = self
        for _ in 1..<8 {
            square = square?.move(direction)
            if square.isNil {
                break
            }
            moves.append(square)
        }
        return moves.compactMap { $0 }
    }
}

extension BoardSquare {
    var knightMoves: [BoardSquare] {
        [
            self.move(.right)?.move(.upRight),
            self.move(.right)?.move(.downRight),
            self.move(.left)?.move(.upLeft),
            self.move(.left)?.move(.downLeft),
            self.move(.up)?.move(.upRight),
            self.move(.up)?.move(.upLeft),
            self.move(.down)?.move(.downRight),
            self.move(.down)?.move(.downLeft)
        ].compactMap { $0 }
    }
}

extension BoardSquare {
    var neighbours: [BoardSquare] {
        MoveDirection.allCases.compactMap { self.move($0) }
    }
}

extension BoardSquare {
    func path(to destination: BoardSquare) -> [BoardSquare] {
        var addresses: [BoardSquare?] = []
        if self.row == destination.row {
            // horizontal
            if self.column < destination.column {
                // to the right
                var toRight: BoardSquare? = self
                while toRight.notNil, toRight!.column < destination.column {
                    toRight = toRight?.move(.right)
                    addresses.append(toRight)
                }
            }
            if self.column > destination.column {
                // to the left
                var toLeft: BoardSquare? = self
                while toLeft.notNil, toLeft!.column > destination.column {
                    toLeft = toLeft?.move(.left)
                    addresses.append(toLeft)
                }
            }
        }
        if self.column == destination.column {
            // vertival
            if self.row < destination.row {
                // to up
                var toUp: BoardSquare? = self
                while toUp.notNil, toUp!.row < destination.row {
                    toUp = toUp?.move(.up)
                    addresses.append(toUp)
                }
            }
            if self.row > destination.row {
                // to down
                var toDown: BoardSquare? = self
                while toDown.notNil, toDown!.row > destination.row {
                    toDown = toDown?.move(.down)
                    addresses.append(toDown)
                }
            }
        }
        if destination.isDiagonal(to: self) {
            var horizontalDirection = MoveDirection.right
            var verticalDirection = MoveDirection.up

            if destination.row > self.row, destination.column < self.column {
                // top left
                horizontalDirection = .left
            } else if destination.row < self.row, destination.column < self.column {
                // bottom left
                verticalDirection = .down
                horizontalDirection = .left
            } else if destination.row < self.row, destination.column > self.column {
                // bottom right
                verticalDirection = .down
                horizontalDirection = .right
            }

            var next: BoardSquare? = self
            while next.notNil, next! != destination {
                next = next?.move(verticalDirection)?.move(horizontalDirection)
                addresses.append(next)
            }
        }
        return addresses.compactMap{ $0 }
    }

    func isDiagonal(to destination: BoardSquare) -> Bool {
        guard self != destination else {
            return false
        }
        let horizontalDistance = abs(self.column.rawValue - destination.column.rawValue)
        let verticalDistance = abs(self.row - destination.row)
        return horizontalDistance == verticalDistance
    }
}
