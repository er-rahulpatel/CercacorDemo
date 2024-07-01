//
//  RestaurantList.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-30.
//

import SwiftUI

struct RestaurantList: View {
    let restaurants: [Restaurant]
    
    var body: some View {
        VStack {
            List(restaurants.enumerated().map{ $0 }, id: \.offset) { index, restaurant in
                VStack {
                    Text(restaurant.name)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(restaurant.title)
                        .font(.callout)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct RestaurantList_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantList(restaurants: [])
    }
}
