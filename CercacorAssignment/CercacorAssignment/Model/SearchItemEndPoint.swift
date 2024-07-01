//
//  SearchItemEndPoint.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-27.
//

import Foundation

struct SearchItemEndPointParameter {
    let nix_item_id: String
    
    enum Keys: String, CaseIterable {
        case nix_item_id
    }
    
    func getValueFor(key: Keys) -> String {
        switch key{
        case .nix_item_id:
            return nix_item_id
        }
    }
}

struct SearchItemEndPointResponse: Codable {
    var foods: [Food]
}
