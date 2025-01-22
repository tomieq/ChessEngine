//
//  ChessBoard.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation
import Logger

typealias GamePiece = DetachedChessPiece & ChessPieceConvertible

public class ChessBoard {
    private let logger = Logger(ChessBoard.self)
    public var colorOnMove: ChessPieceColor = .white
    private var pieces: [ChessPiece]
    private var listeners: [(ChessBoardEvent) -> Void] = []
    public var movesHistory: [ChessMove] = []
    public var pgn: [String] {
        movesHistory.map { $0.notation }
    }
    public var pgnFlat: String {
        pgn.joined(separator: " ")
    }

    public var allPieces: [ChessPiece] {
        self.pieces
    }

    public init() {
        self.pieces = []
    }

    private init(pieces: [ChessPiece]) {
        self.pieces = pieces
    }
    
    func subscribe(subscriber: @escaping (ChessBoardEvent) -> Void) {
        self.listeners.append(subscriber)
    }
    
    private func broadcast(event: ChessBoardEvent) {
        listeners.forEach { $0(event) }
    }
    
    @discardableResult
    func add(_ piece: GamePiece?, _ mode: ChessMoveMode = .normal) -> ChessBoard {
        self.addPiece(piece, mode)
        return self
    }

    func add(_ pieces: GamePiece?..., mode: ChessMoveMode = .normal) {
        for piece in pieces {
            self.addPiece(piece, emitChanges: false)
        }
        let squares = pieces.compactMap{ $0?.square }
        broadcast(event: ChessBoardEvent(change: .pieceAdded(at: squares), mode: mode))
    }
    
    func remove(_ square: BoardSquare, _ mode: ChessMoveMode = .normal) {
        self.pieces = self.pieces.filter{ $0.square != square }
        broadcast(event: ChessBoardEvent(change: .pieceRemoved(from: [square]), mode: mode))
    }
    
    func remove(_ squares: BoardSquare..., mode: ChessMoveMode = .normal) {
        self.pieces = self.pieces.filter{ !squares.contains($0.square) }
        broadcast(event: ChessBoardEvent(change: .pieceRemoved(from: squares), mode: mode))
    }

    func move(_ move: ChessBoardMove, _ mode: ChessMoveMode = .normal) {
        guard let movedPiece = piece(at: move.from)?.moved(to: move.to) else { return }
        pieces.removeAll { [move.to, move.from].contains($0.square) }
        pieces.append(movedPiece)
        broadcast(event: ChessBoardEvent(change: .pieceMoved(move), mode: mode))
    }
    
    private func addPiece(_ piece: GamePiece?, emitChanges: Bool = true, _ mode: ChessMoveMode = .normal) {
        if let chessPiece = piece?.chessPiece(chessBoard: self) {
            self.pieces.append(chessPiece)
            if emitChanges {
                broadcast(event: ChessBoardEvent(change: .pieceAdded(at: [chessPiece.square]), mode: mode))
            }
        }
    }

    func piece(at square: BoardSquare?) -> ChessPiece? {
        self.pieces.first{ $0.square == square }
    }
    
    public subscript(square: BoardSquare?) -> ChessPiece? {
        set {}
        get {
            piece(at: square)
        }
    }

    func activePawn(at square: BoardSquare?) -> ActivePawn? {
        guard let piece = self.piece(at: square), piece.type == .pawn else { return nil }
        return ActivePawn(color: piece.color, square: piece.square)
    }

    func king(color: ChessPieceColor) -> ChessPiece? {
        self.pieces.first { $0.type == .king && $0.color == color }
    }

    func isInCheck(_ color: ChessPieceColor) -> Bool {
        if let king = king(color: color), king.possibleAttackers.isEmpty.not {
            return true
        }
        return false
    }
    
    func isCheckMated(_ color: ChessPieceColor) -> Bool {
        for piece in getPieces(color: color) {
            if piece.possibleMoves.count > 0 {
                return false
            }
        }
        return true
    }
    
    public var status: ChessGameStatus {
        for color in ChessPieceColor.allCases {
            if isCheckMated(color) {
                logger.i("It is checkmate for \(color) is check mated")
                return .checkmate(winner: color.other)
            }
            if isInCheck(color) {
                logger.i("It is check for \(color) possible moves: \(getPieces(color: color).filter{ $0.moveCalculator.possibleMoves.isEmpty.not }.map{ "\($0) moves: \($0.moveCalculator.possibleMoves)" }.joined(separator: ", "))")
                return .check(attacker: color.other)
            }
        }
        return .normal
    }

    func isFree(_ square: BoardSquare) -> Bool {
        !self.pieces.contains{ $0.square == square }
    }

    @discardableResult
    public func setupGame() -> ChessBoard {
        logger.i("Setup new game")
        removeAllPieces()
        colorOnMove = .white
        movesHistory = []
        let chessboardLoader = ChessBoardLoader(chessBoard: self)
        chessboardLoader
            .load(.white, "Ra1 Nb1 Bc1 Qd1 Ke1 Bf1 Ng1 Rh1")
            .load(.white, "a2 b2 c2 d2 e2 f2 g2 h2")
            .load(.black, "Ra8 Nb8 Bc8 Qd8 Ke8 Bf8 Ng8 Rh8")
            .load(.black, "a7 b7 c7 d7 e7 f7 g7 h7")
        broadcast(event: ChessBoardEvent(change: .pieceAdded(at: pieces.map { $0.square }), mode: .normal))
        return self
    }
    
    public func removeAllPieces() {
        let occupiedSquares = pieces.map { $0.square }
        pieces.removeAll()
        colorOnMove = .white
        movesHistory = []
        broadcast(event: ChessBoardEvent(change: .pieceRemoved(from: occupiedSquares), mode: .normal))
    }

    public func getPieces(color: ChessPieceColor) -> [ChessPiece] {
        self.pieces.filter{ $0.color == color }
    }

    public func dump(color: ChessPieceColor) -> String {
        self.pieces
            .filter{ $0.color == color }
            .map { "\($0.type.enLetter)\($0.square)" }
            .joined(separator: " ")
    }
}

extension ChessBoard {
    public var clone: ChessBoard {
        let board = ChessBoard()
        board.colorOnMove = self.colorOnMove
        board.movesHistory = self.movesHistory
        self.pieces.map {
            $0.gamePiece
        }.forEach {
            board.add($0)
        }
        return board
    }
}
