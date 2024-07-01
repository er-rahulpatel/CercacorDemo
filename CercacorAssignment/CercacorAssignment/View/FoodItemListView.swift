//
//  FoodItemListView.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import SwiftUI

struct FoodItemListView: View {
    @StateObject var foodItemListViewModel: FoodItemListViewModel
    
    var body: some View {
        VStack {
            if (foodItemListViewModel.showListView) {
                SegmentedPickerView(
                    segments: [FoodItemTypes.common, FoodItemTypes.branded],
                    selection:$foodItemListViewModel.selectedFoodType)
                .padding(.horizontal)
                
                ZStack {
                    FoodItemList(
                        foodItems: foodItemListViewModel.searchInstantResponse.common?.map{ foodItem in
                            FoodItemDisplay(thumbnail: foodItem.photo.thumb, name: foodItem.foodName, calories: foodItem.nfCalories)
                        }, selectedIndex: $foodItemListViewModel.selectedItemIndex)
                    .opacity(foodItemListViewModel.selectedFoodType == .common ? 1 : 0)
                    
                    FoodItemList(
                        foodItems: foodItemListViewModel.searchInstantResponse.branded?.map{ foodItem in
                            FoodItemDisplay(thumbnail: foodItem.photo.thumb, name: foodItem.foodName, calories: foodItem.nfCalories)
                        }, selectedIndex: $foodItemListViewModel.selectedItemIndex)
                    .opacity(foodItemListViewModel.selectedFoodType == .branded ? 1 : 0)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            else {
                Text("No food items to display.")
            }
        }
        .navigationTitle("Food Items")
        /// Displays searchbar within navigation
        .searchable(text: $foodItemListViewModel.searchText)
        .alert(foodItemListViewModel.errorMessage,
               isPresented: $foodItemListViewModel.isError,
               actions: {
            Button("Ok", role: .cancel){}
        })
        .background(
            /// Navigation to next screen when click on row and manage bidning
            NavigationLink(
                destination: navigateToFoodItemDetaiView(),
                isActive: Binding<Bool>(
                    get: {
                        foodItemListViewModel.selectedItemIndex != nil
                    },
                    set: { newValue in
                        if !newValue {
                            foodItemListViewModel.selectedItemIndex = nil
                        }
                    }
                ),
                label: { EmptyView() }
            )
            .isDetailLink(false)
        )
    }
}

extension FoodItemListView {
    @ViewBuilder
    func navigateToFoodItemDetaiView() -> (some View)?? {
        if let selectedItemIndex = foodItemListViewModel.selectedItemIndex {
            (foodItemListViewModel.selectedFoodType == .common) ?
            FoodItemDetailView(
                foodItemDetailViewModel:FoodItemDetailViewModel(
                    nutritionixAPIManager: NutritionixAPIManager(
                        nutritionixConfiguration: NutritionixConfiguration.shared,
                        networkManager: NetworkManager.shared),
                    selectedFoodName: foodItemListViewModel.getFoodName(for: selectedItemIndex) ?? "")
            )
            :
            FoodItemDetailView(
                foodItemDetailViewModel:FoodItemDetailViewModel(
                    nutritionixAPIManager: NutritionixAPIManager(
                        nutritionixConfiguration: NutritionixConfiguration.shared,
                        networkManager: NetworkManager.shared),
                    selectedNixItemId: foodItemListViewModel.getNixItemId(for: selectedItemIndex) ?? "")
            )
        }
    }
}

struct FoodItemListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodItemListView(
            foodItemListViewModel: FoodItemListViewModel(
                nutritionixAPIManager: NutritionixAPIManager(
                    nutritionixConfiguration: NutritionixConfiguration.shared,
                    networkManager: NetworkManager.shared
                )
            )
        )
    }
}
