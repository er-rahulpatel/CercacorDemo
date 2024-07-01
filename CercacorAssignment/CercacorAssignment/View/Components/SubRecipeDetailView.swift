//
//  SubRecipeDetailView.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-28.
//

import SwiftUI

struct SubRecipeDetailView: View {
    @ObservedObject var foodItemDetailViewModel: FoodItemDetailViewModel
    
    var body: some View {
        VStack {
            if let food = foodItemDetailViewModel.food {
                Text("Nutritionix sub-recipe for \(food.servingQuantity.format()) \(food.servingUnit): ")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .overlay(.primary)
                
                SubRecipeList(
                    subRecipes: $foodItemDetailViewModel.subRecipes,
                    updateSubRecipe: foodItemDetailViewModel.updateSubRecipe(_:))
            }
        }
        
    }
}

struct SubRecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SubRecipeDetailView(
            foodItemDetailViewModel: FoodItemDetailViewModel(
                nutritionixAPIManager: NutritionixAPIManager(
                    nutritionixConfiguration: NutritionixConfiguration.shared,
                    networkManager: NetworkManager.shared),
                selectedNixItemId: "")
        )
    }
}
