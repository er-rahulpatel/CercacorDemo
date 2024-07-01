//
//  NutritionDetailView.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-24.
//

import SwiftUI

struct NutritionDetailView: View {
    @ObservedObject var foodItemDetailViewModel: FoodItemDetailViewModel
    
    var body: some View {
        VStack {
            if let food = foodItemDetailViewModel.food {
                Text("Nutrition Facts")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .overlay(.primary)
                
                Text("Serving size")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ///Quantity input text field with stepper
                QuantityInputView(
                    quantity: $foodItemDetailViewModel.quantity,
                    servingUnit: food.servingUnit,
                    servingWeightGrams: foodItemDetailViewModel.getTotalWeightGrams(for:food),
                    metricUOM: food.metricUOM)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ThickDivider()
                
                ///Displays total calories
                CalorieView(calories: foodItemDetailViewModel.getTotalCalories(for: food))
                
                ThickDivider()
                
                ///Displays all nutrient information
                NutrientList(nutrients: foodItemDetailViewModel.nutrientsInfo)
                
                ThickDivider()
                
                ///Displays ingredients if available in response
                if let ingredients = food.ingredients {
                    (Text("INGREDIENTS: ")
                        .bold() +
                     Text(ingredients))
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

struct NutritionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionDetailView(
            foodItemDetailViewModel: FoodItemDetailViewModel(
                nutritionixAPIManager: NutritionixAPIManager(
                    nutritionixConfiguration: NutritionixConfiguration.shared,
                    networkManager: NetworkManager.shared),
                selectedNixItemId: "")
        )
    }
}
