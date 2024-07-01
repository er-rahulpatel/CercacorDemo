//
//  CercacorAssignmentApp.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import SwiftUI
import IQKeyboardManagerSwift

@main
struct CercacorAssignmentApp: App {
    init() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                FoodItemListView(
                    foodItemListViewModel: FoodItemListViewModel(
                        nutritionixAPIManager: NutritionixAPIManager(
                            nutritionixConfiguration: NutritionixConfiguration.shared,
                            networkManager: NetworkManager.shared)
                    )
                )
            }
        }
    }
}
