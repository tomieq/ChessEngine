//
//  KingMoveCalculator.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

class KingMoveCalculator: MoveCalculator, MoveCalculatorProvider {
    var moveCounter: Int = 0
    private var calculatedMoves: CalculatedMoves?
    
    let chessBoard: ChessBoard
    private var square: BoardSquare
    private var color: ChessPieceColor
    
    init(for piece: DetachedChessPiece, on chessBoard: ChessBoard) {
        self.square = piece.square
        self.color = piece.color
        self.chessBoard = chessBoard
        self.chessBoard.subscribe { [weak self] event in
            self?.gameChanged(event)
        }
    }
    
    private func gameChanged(_ event: ChessBoardEvent) {
        switch event.change {
        case .pieceMoved(let move):
            if self.square == move.from {
                self.square = move.to
                switch event.mode {
                case .normal:
                    moveCounter += 1
                case .revert:
                    moveCounter -= 1
                }
                
            }
        default:
            break
        }
        self.calculatedMoves = nil
    }
    
    private func attackersFor(square: BoardSquare) -> [BoardSquare] {
        var attackers: [BoardSquare] = []
        // find all knight attackers and defenders
        for position in square.knightMoves {
            if let piece = chessBoard.piece(at: position), piece.type == .knight, piece.color == color.other  {
                attackers.append(piece.square)
            }
        }
        // find enemy king attacker
        if let enemyKing = chessBoard.king(color: color.other), enemyKing.square.neighbours.contains(square) {
            attackers.append(enemyKing.square)
        }
        
        // find all pawn attackers and defenders
        let enemyPawnSearchDirection: [MoveDirection] = [.downLeft, .downRight, .upLeft, .upRight]
        for direction in enemyPawnSearchDirection {
            if let activePawn = chessBoard.activePawn(at: square.move(direction)), activePawn.color == color.other,
               activePawn.attackedSquares.contains(square) {
                attackers.append(activePawn.square)
            }
        }
        // check long distance hitters
        for direction in MoveDirection.allCases {
            if let piece = nearestPiece(in: direction, from: square) {
                if piece.color == color.other, piece.longDistanceAttackDirections.contains(direction.opposite) {
                    attackers.append(piece.square)
                }
            }
        }
        return attackers
    }

    func analize() -> CalculatedMoves {
        if let calculatedMoves = self.calculatedMoves {
            return calculatedMoves
        }
        var possibleMoves: [BoardSquare] = []
        var defends: [BoardSquare] = []
        let defenders: [BoardSquare] = []
        var possibleVictims: [BoardSquare] = []
        var possibleAttackers: [BoardSquare] = []
        
        let allowedSquares = square.neighbours
        
        for position in allowedSquares {
            if let piece = chessBoard.piece(at: position) {
                if piece.color == color {
                    defends.append(piece.square)
                } else {
                    possibleVictims.append(piece.square)
                    if attackersFor(square: piece.square).isEmpty {
                        possibleMoves.append(piece.square)
                    }
                }
            } else {
                if attackersFor(square: position).isEmpty {
                    possibleMoves.append(position)
                }
            }
        }
        possibleAttackers = attackersFor(square: square)
        
        // castling
        if moveCounter == 0, square == startingSquare, possibleAttackers.isEmpty {
            if rookCanCastle(at: BoardSquare(.a, square.row)) {
                possibleMoves.append(BoardSquare(.c, square.row)!)
            }
            if rookCanCastle(at: BoardSquare(.h, square.row)) {
                possibleMoves.append(BoardSquare(.g, square.row)!)
            }
        }

        let calculatedMoves = CalculatedMoves(possibleMoves: possibleMoves,
                                              possibleVictims: possibleVictims,
                                              possibleAttackers: possibleAttackers,
                                              defends: defends,
                                              defenders: defenders,
                                              pinInfo: nil)
        self.calculatedMoves = calculatedMoves
        return calculatedMoves
    }

    private func nearestPiece(in direction: MoveDirection, from square: BoardSquare) -> ChessPiece? {
        for position in square.squares(to: direction) {
            if let piece = chessBoard[position], piece.square != self.square {
                return piece
            }
        }
        return nil
    }
    
    private var startingSquare: BoardSquare {
        switch color {
        case .white:
            "e1"
        case .black:
            "e8"
        }
    }
    
    private func rookCanCastle(at square: BoardSquare?) -> Bool {
        guard let rook = chessBoard.piece(at: square), rook.type == .rook,
              rook.color == color, rook.moveCalculator.moveCounter == 0 else {
            return false
        }
        let side: MoveDirection = self.square.column > rook.square.column ? .left : .right
        let wayToCrawl = self.square.squares(to: side).dropLast(1)
        guard wayToCrawl.map({ chessBoard.isFree($0) }).allSatisfy({ $0 }) else {
            return false
        }
        guard wayToCrawl.map( { attackersFor(square: $0).isEmpty }).allSatisfy( { $0 }) else {
            return false
        }
        return true
    }
}
