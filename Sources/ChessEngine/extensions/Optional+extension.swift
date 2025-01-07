//
//  Optional+extension.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

extension Optional {
    var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }

    var notNil: Bool {
        !self.isNil
    }
}
