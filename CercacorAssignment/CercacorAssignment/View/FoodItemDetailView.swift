//
//  FoodItemDetailView.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-21.
//

import SwiftUI

struct FoodItemDetailView: View {
    @StateObject var foodItemDetailViewModel: FoodItemDetailViewModel
    
    var body: some View {
        ScrollView{
            if let food = foodItemDetailViewModel.food {
                VStack {
                    FoodDetailHeader(
                        name: food.foodName,
                        photo: food.photo?.thumb,
                        brandName: food.brandName)
                    
                    NutritionDetailView(foodItemDetailViewModel: foodItemDetailViewModel)
                        .padding()
                        .border(.primary)
                    
                }
            } else {
                Text("No details found. Please try again later.")
            }
        }
        .padding()
        /// To solve scrollview's top  padding
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Details")
        .alert(foodItemDetailViewModel.errorMessage,
               isPresented: $foodItemDetailViewModel.isError,
               actions: {
            Button("Ok", role: .cancel){}
        })
    }
}

struct FoodItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodItemDetailView(
            foodItemDetailViewModel: FoodItemDetailViewModel(
                nutritionixAPIManager: NutritionixAPIManager(
                    nutritionixConfiguration: NutritionixConfiguration.shared,
                    networkManager: NetworkManager.shared),
                selectedNixItemId: "")
        )
    }
}
