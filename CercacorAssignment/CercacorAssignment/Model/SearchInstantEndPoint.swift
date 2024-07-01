//
//  SearchInstantEndPoint.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-27.
//

import Foundation

struct SearchInstantEndPointParameter {
    let query: String
    let common: Bool
    let branded: Bool
    let detailed: Bool
    
    enum Keys: String, CaseIterable {
        case query
        case common
        case branded
        case detailed
    }
    
    func getValueFor(key: Keys) -> String {
        switch key{
        case .query:
            return query
        case .common:
            return String(common)
        case .branded:
            return String(branded)
        case .detailed:
            return String(detailed)
        }
    }
}

struct SearchInstantEndPointResponse: Codable, Equatable {
    let common: [CommonFood]?
    let branded: [BrandedFood]?
}

extension SearchInstantEndPointResponse {
    init() {
        self.common = []
        self.branded = []
    }
}
