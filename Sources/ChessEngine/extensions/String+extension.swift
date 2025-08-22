//
//  String+extension.swift
//
//
//  Created by Tomasz on 04/04/2023.
//

import Foundation

extension String {
    func subString(_ from: Int, _ to: Int) -> String {
        if self.count < to {
            return self
        }

        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: to)

        let range = start..<end
        return String(self[range])
    }
}

extension String {
    func with(_ elems: CustomStringConvertible...) -> String {
        return String(format: self, arguments: elems.map{ $0.description })
    }
}

extension String {
    mutating func removeSubrange(_ range: ClosedRange<Int>) {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        self.removeSubrange(startIndex..<index(startIndex, offsetBy: range.count))
    }
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }

    subscript(range: Range<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return String(self[startIndex..<index(startIndex, offsetBy: range.count)])
    }

    subscript(range: ClosedRange<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return String(self[startIndex..<index(startIndex, offsetBy: range.count)])
    }

    subscript(range: PartialRangeFrom<Int>) -> String {
        String(self[index(startIndex, offsetBy: range.lowerBound)...])
    }

    subscript(range: PartialRangeThrough<Int>) -> String {
        String(self[...index(startIndex, offsetBy: range.upperBound)])
    }

    subscript(range: PartialRangeUpTo<Int>) -> String {
        String(self[..<index(startIndex, offsetBy: range.upperBound)])
    }
}

extension String {
    static var chessPieceID: String {
        UUID().uuidString.prefix(4).description.appending(".")
    }
}
