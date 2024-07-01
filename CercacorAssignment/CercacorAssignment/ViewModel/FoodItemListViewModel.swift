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
    @Published var searchInstantResponse: SearchInstantEndPointResponse = SearchInstantEndPointResponse()
    @Published var isError: Bool = false
    var errorMessage: String = ""
    ///Nutritionix recommendation.
    ///https://docx.syndigo.com/developers/docs/instant-endpoint#:~:text=recommended%20debounce%20metrics
    private var searchCancellable: AnyCancellable?
    private let charCount = 3 ///ref:
    private let debounceTime = 300
    @Published var selectedItemIndex: Int?
    @Published var selectedFoodType: FoodItemTypes = .common
    @Published var searchText = "" {
        didSet {
            ///call api and manage view updates
            showListView = searchText.count > charCount
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
                self.searchInstantResponse = SearchInstantEndPointResponse()
            }
        }
    }
    
    init(nutritionixAPIManager: NutritionixAPIManagerDelegate) {
        self.nutritionixAPIManager = nutritionixAPIManager
    }
    /// Fetch Instant Food Item response
    /// Excluding common food items because it does not contain calorie information and has different end point to fetch detail information
    func searchInstantFoodItem(for foodItem: String,
                               foodTypes:[FoodItemTypes] = [.common,.branded],
                               includeDetail: Bool = true ) {
        Task {
            do {
                let response: SearchInstantEndPointResponse = try await nutritionixAPIManager.searchInstantFoodItemsWith(
                    parameters: SearchInstantEndPointParameter(
                        query: foodItem,
                        common: foodTypes.contains(.common),
                        branded: foodTypes.contains(.branded),
                        detailed: includeDetail))
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.searchInstantResponse = response
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
        
        //        let filePath = Bundle.main.path(forResource: "SearchInstantMock", ofType: "json")!
        //        let fileUrl  = URL(fileURLWithPath: filePath)
        //        let data = try! Data(contentsOf: fileUrl)
        //        self.searchInstantResponse = try! JSONDecoder().decode(SearchInstantEndPointResponse.self, from: data)
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
        guard let branded = searchInstantResponse.branded, index < branded.count else { return nil }
        return branded[index].nixItemId
    }
    
    ///Get food name for selected row
    func getFoodName(for index: Int) -> String? {
        guard let common = searchInstantResponse.common, index < common.count else { return nil }
        return common[index].foodName
    }
    
}
