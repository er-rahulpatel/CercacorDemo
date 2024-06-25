//
//  FoodItemListViewModel.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import Foundation
import Combine

class FoodItemListViewModel: ObservableObject {
    let nutritionixAPIManager: NutritionixAPIManagerDelegate
    @Published var foodItems: [BrandedFood] = []
    @Published var isError: Bool = false
    var errorMessage: String = ""
    ///Nutritionix recommendation.
    ///https://docx.syndigo.com/developers/docs/instant-endpoint#:~:text=recommended%20debounce%20metrics
    private var searchCancellable: AnyCancellable?
    private let charCount = 3 ///ref:
    private let debounceTime = 300
    @Published var selectedItemIndex: Int?
    @Published var searchText = "" {
        didSet {
            ///call api and manage view updates
            showListView = searchText.count >= charCount
            if searchText.count > charCount {
                searchCancellable?.cancel()
                searchCancellable = $searchText
                    .debounce(for: .milliseconds(debounceTime), scheduler: DispatchQueue.main)
                    .sink {[weak self] _ in
                        guard let weakSelf = self else {
                            return
                        }
                        if weakSelf.searchText.count >= weakSelf.charCount {
                            weakSelf.searchInstantFoodItem(for: weakSelf.searchText)
                        }
                    }
            }
        }
    }
    @Published var showListView: Bool = false {
        didSet {
            if searchText.count > charCount {
                self.foodItems = []
            }
        }
    }
    
    init(nutritionixAPIManager: NutritionixAPIManagerDelegate) {
        self.nutritionixAPIManager = nutritionixAPIManager
    }
    /// Fetch Instant Food Item response
    /// Excluding common food items because it does not contain calory information and has different end point to fetch detail information
    func searchInstantFoodItem(for foodItem: String, includeCommonFoodItem: Bool = false ) {
        Task {
            do {
                let response: SearchInstantEndPointResponse = try await nutritionixAPIManager.getFoodItemsByInstantSearch(query: foodItem, includeCommonFoodItem: includeCommonFoodItem)
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.foodItems = response.branded ?? []
                }
            } catch {
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else  {
                        return
                    }
                    weakSelf.handleError(error)
                }
            }
        }
    }
    
    /// API response error handling
    func handleError(_ error: Error) {
        self.isError = true
        if let error = error as? NetworkError {
            self.errorMessage = error.description
        } else {
            self.errorMessage = error.localizedDescription
        }
    }
    
    ///Get nixItemId for selected row
    func getNixItemId(for index: Int) -> String? {
        guard index < foodItems.count else { return nil }
        return foodItems[index].nixItemId
    }
    
}
