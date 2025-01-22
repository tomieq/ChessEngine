# ChessEngine
Chess library for moving chess pieces on chess board according to chess rules.

### ChessBoard
The main object of the library is the `ChessBoard`.
```swift
let chessBoard = ChessBoard()

chessBoard.colorOnMove // tells what pieces should move now, default: .white
chessBoard.pgn // array of PGN moves in the game
chessBoard.pgnFlat // PGN moves separated with space
chessBoard.movesHistory // array of ChessMove usable when updating UI to specific point in game
chessBoard.allPieces // array of ChessPiece that are present on the board
chessBoard["a1"] // returns ChessPiece? on given square
chessBoard.status // ChessGameStatus of current game: normal/check/checkmate
chessBoard.setupGame() // setup pieces for new game
```

### Load custom piece setup
If you want custom piece setup, e.g for puzzle use `ChessBoardLoader` class.
```swift
let chessBoard = ChessBoard()
let loader = ChessBoardLoader(chessBoard: sut)

loader.load(.white, "d2 e2 f2")
      .load(.black, "Bh4")
```

### ChessPiece
`ChessPiece` represents a piece on the board.
```swift
let piece = chessBoard["a1"]
piece.color // color of the piece: .white/.black
piece.type // the type of piece: .pawn/.rook etc.
piece.square // the square the piece is located: e.g. "a1"
piece.moveCounter // amount of moves the piece did
piece.possibleMoves // fields where this piece can move (including possibleVictims)
piece.possibleVictims // fields that this piece can attack
piece.possibleAttackers // fields that this piece might get attack from
piece.defends // fields that are defended by this piece
piece.defenders // fields that defend this piece
```

### How to make moves?
In order to make manual moves on the board, you need to use `ChessMoveExecutor`:
```swift
let chessboard = ChessBoard()
chessboard.setupGame()
let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
let commandFactory = ChessMoveCommandFactory(chessboard: chessboard)
let command = try commandFactory.make(from: "e4", to: "e5")
moveExecutor.process(command)
moveExecutor.revert() // you can revert last move like this
```

In order to make multiple moves at once, you can use `NotationParser` that is capable of parsing PGN notation:
```swift
let chessboard = ChessBoard()
chessboard.setupGame()
let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
let parser = NotationParser(moveExecutor: moveExecutor)
try parser.process("""
1. e4 f5
2. exf5 e6
3. fxe6
""")
```
### How to connect UI to chessboard?
In order to update UI on moves, register callback in `ChessMoveExecutor`:
```swift
let chessboard = ChessBoard()
chessboard.setupGame()
let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
moveExecutor.moveListener = { chessMove in

}
```
On every piece change you will get `ChessMove` object.
