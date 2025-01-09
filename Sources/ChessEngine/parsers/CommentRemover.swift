//
//  CommentRemover.swift
//  ChessEngine
//
//  Created by Tomasz on 09/01/2025.
//

import Foundation

enum CommentRemover {
    static func removeComments(_ content: String) -> String {
        var content = content
        while let openIndex = content.firstIndex(of: "{"),
              let closeIndex = content.firstIndex(of: "}") {
            let start = content.distance(from: content.startIndex, to: openIndex)
            let end = content.distance(from: content.startIndex, to: closeIndex)
            content.removeSubrange(start...end)
        }
        return content
    }
}

extension String {
    var pgnWithoutComments: String {
        CommentRemover.removeComments(self)
    }
}
