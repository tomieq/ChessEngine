//
//  PawnMoveCalculator.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation
import Logger

class PawnMoveCalculator: MoveCalculator, MoveCalculatorProvider {
    private let logger = L(PawnMoveCalculator.self)
    var moveCounter: Int = 0
    private var calculatedMoves: CalculatedMoves?
    
    let chessBoard: ChessBoard
    private var square: BoardSquare
    private let color: ChessPieceColor
    private let type: ChessPieceType
    
    init(for piece: DetachedChessPiece, on chessBoard: ChessBoard) {
        self.square = piece.square
        self.color = piece.color
        self.type = piece.type
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
        self.invalidateMoves()
    }
    
    func invalidateMoves() {
        self.calculatedMoves = nil
    }
    
    func analize() -> CalculatedMoves {
        if let calculatedMoves = self.calculatedMoves {
            return calculatedMoves
        }
        var possibleMoves: [BoardSquare] = []
        var controlledSquares: [BoardSquare] = []
        var defends: [BoardSquare] = []
        var defenders: [BoardSquare] = []
        var possibleVictims: [BoardSquare] = []
        var possibleAttackers: [BoardSquare] = []
        var pinInfo: PinInfo?
        
        // find all knight attackers and defenders
        for position in square.knightMoves {
            if let piece = chessBoard.piece(at: position), piece.type == .knight {
                if piece.color == color {
                    defenders.append(piece.square)
                } else {
                    possibleAttackers.append(piece.square)
                }
            }
        }
        
        // find all pawn attackers and defenders
        let enemyPawnSearchDirection: [MoveDirection] = [.downLeft, .downRight, .upLeft, .upRight]
        for direction in enemyPawnSearchDirection {
            if let activePawn = chessBoard.activePawn(at: square.move(direction)),
               activePawn.attackedSquares.contains(square) {
                if activePawn.color == color {
                    defenders.append(activePawn.square)
                } else {
                    possibleAttackers.append(activePawn.square)
                }
            }
        }
        
        var allowedDirections = MoveDirection.allCases
        // check if move is pinned and update defenders and attackers
        for direction in MoveDirection.allCases {
            var hasDefenderFromThisDirection = false
            for piece in pieces(in: direction) {
                guard piece.longDistanceAttackDirections.contains(direction) else {
                    break
                }
                if piece.color == self.color {
                    defenders.append(piece.square)
                    hasDefenderFromThisDirection = true
                } else if hasDefenderFromThisDirection.not {
                    possibleAttackers.append(piece.square)
                    if let oppositeDirectionPiece = self.nearestPiece(in: direction.opposite),
                       oppositeDirectionPiece.color == self.color,
                       oppositeDirectionPiece.type.weight > self.type.weight {
                        logger.i("pawn at \(square) is pinned by \(piece), covered piece: \(oppositeDirectionPiece)")
                        if oppositeDirectionPiece.type == .king {
                            allowedDirections = allowedDirections.filter { $0 == direction || $0 == direction.opposite }
                        }
                        if piece.type.weight < oppositeDirectionPiece.type.weight {
                            pinInfo = PinInfo(attacker: piece, coveredVictim: oppositeDirectionPiece)
                        }
                    }
                }
            }
        }
        
        // find my king defender
        if let myKing = chessBoard.king(color: color), myKing.square.neighbours.contains(square) {
            defenders.append(myKing.square)
        }
        // find enemy king attacker
        if let enemyKing = chessBoard.king(color: color.other), enemyKing.square.neighbours.contains(square) {
            possibleAttackers.append(enemyKing.square)
        }
        
        let pawn = PawnUtils(square: square, color: color)
        let crawlingDirection = pawn.crawlingDirection

        if allowedDirections.contains(crawlingDirection) {
            if let oneMove = square.move(crawlingDirection) {
                if chessBoard.isFree(oneMove) {
                    possibleMoves.append(oneMove)
                    if pawn.isAtStartingSquare, let doubleMove = oneMove.move(crawlingDirection) {
                        if chessBoard.isFree(doubleMove) {
                            possibleMoves.append(doubleMove)
                        }
                    }
                }
            }
        }
        for attackDirection in pawn.attackDirections where allowedDirections.contains(attackDirection) {
            if let attackedSquare = square.move(attackDirection) {
                if let piece = chessBoard.piece(at: attackedSquare) {
                    if piece.color == color.other {
                        possibleMoves.append(attackedSquare)
                        possibleVictims.append(attackedSquare)
                    } else {
                        defends.append(attackedSquare)
                    }
                } else {
                    controlledSquares.append(attackedSquare)
                }
            }
        }
        // en passant
        for direction in pawn.enPassantDirections where allowedDirections.contains(direction) {
            if let possibleSquare = square.move(direction),
               let enemyPawsSqare = possibleSquare.move(crawlingDirection.opposite),
               let enemyPawn = chessBoard[enemyPawsSqare], enemyPawn.color == color.other, enemyPawn.type == .pawn {
                let enemyPawnUtils = PawnUtils(square: enemyPawn.square, color: enemyPawn.color)
                if let lastMove = chessBoard.movesHistory.last?.rawMove,
                   let enemyStartingSqaure = enemyPawnUtils.startingSquare,
                   lastMove == ChessBoardMove(from: enemyStartingSqaure, to: enemyPawsSqare) {
                    possibleMoves.append(possibleSquare)
                } else if chessBoard.possibleEnPassant == possibleSquare {
                    possibleMoves.append(possibleSquare)
                }
            }
        }
        // moves when my king is checked
        if let king = chessBoard.king(color: color) {
            if king.possibleAttackers.count == 1 {
                // if king is atacked once, you can beat attacker or cover attack path
                if let attackerSquare = king.possibleAttackers.first, let attacker = chessBoard[attackerSquare] {
                    var forcedMoves = [attackerSquare]
                    if attacker.longDistanceAttackDirections.isEmpty.not {
                        forcedMoves.append(contentsOf: king.square.path(to: attackerSquare))
                    }
                    // check possibility to neutralize check by en passant
                    if attacker.type == .pawn {
                        let attackerUtils = PawnUtils(square: attackerSquare, color: attacker.color)

                        if attacker.square == attackerUtils.squareAfterDoubleMove,
                           let enPassantMove = attackerSquare.move(attackerUtils.crawlingDirection.opposite) {
                            if let attackerStartSquare = attackerUtils.startingSquare,
                               let lastMove = chessBoard.movesHistory.last?.rawMove,
                               lastMove == ChessBoardMove(from: attackerStartSquare, to: attackerSquare) {
                                forcedMoves.append(enPassantMove)
                            } else if chessBoard.possibleEnPassant == enPassantMove {
                                forcedMoves.append(enPassantMove)
                            }
                        }
                    }
                    possibleMoves = possibleMoves.commonElements(with: forcedMoves)
                    controlledSquares = controlledSquares.commonElements(with: forcedMoves)
                }
            } else if king.possibleAttackers.count > 1 {
                // if king is atacked twice, you cannot cover, so it is king who must escape
                possibleMoves = []
                controlledSquares = []
            }
        }
        let calculatedMoves = CalculatedMoves(possibleMoves: possibleMoves,
                                              possibleVictims: possibleVictims,
                                              possibleAttackers: possibleAttackers,
                                              defends: defends,
                                              defenders: defenders,
                                              controlledSquares: controlledSquares,
                                              pinInfo: pinInfo)
        self.calculatedMoves = calculatedMoves
        return calculatedMoves
    }

    private func nearestPiece(in direction: MoveDirection) -> ChessPiece? {
        for position in square.squares(to: direction) {
            if let piece = chessBoard.piece(at: position) {
                return piece
            }
        }
        return nil
    }
    
    private func pieces(in direction: MoveDirection) -> [ChessPiece] {
        var pieces: [ChessPiece] = []
        for position in square.squares(to: direction) {
            if let piece = chessBoard.piece(at: position) {
                pieces.append(piece)
            }
        }
        return pieces
    }
}

extension PawnMoveCalculator: MoveHistoryDependentCalculator {
    func wipe() {
        invalidateMoves()
    }
}
