//
//  FoodItemList.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-21.
//

import SwiftUI

struct FoodItemDisplay {
    let thumbnail: String
    let name: String
    let calories: Double
}

struct FoodItemList: View {
    let foodItems: [FoodItemDisplay]?
    @Binding var selectedIndex: Int?
    
    var body: some View {
        VStack {
            if let foodItems = self.foodItems{
                List(foodItems.enumerated().map{ $0 }, id: \.offset) { index, foodItem in
                    FoodItemRow(foodItem: foodItem)
                        .onTapGesture {
                            selectedIndex = index
                        }
                }
            }
        }
    }
}

struct FoodItemList_Previews: PreviewProvider {
    @State static var selectedIndex: Int? = nil
    static var previews: some View {
        FoodItemList(foodItems: [FoodItemDisplay.getPreviewInitial()], selectedIndex: $selectedIndex)
    }
}
