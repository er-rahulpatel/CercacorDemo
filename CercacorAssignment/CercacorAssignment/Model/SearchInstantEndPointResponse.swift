//
//  SearchInstantEndPointResponse.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import Foundation

struct SearchInstantEndPointResponse: Codable, Equatable {
    let common: [CommonFood]?
    let branded: [BrandedFood]?
}
