//
//  MutableCollection+Extension.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-29.
//

import Foundation

extension MutableCollection {
    mutating func updateEach(_ body: (inout Element) throws -> Void) rethrows {
        for index in self.indices {
            try body(&self[index])
        }
    }
}
