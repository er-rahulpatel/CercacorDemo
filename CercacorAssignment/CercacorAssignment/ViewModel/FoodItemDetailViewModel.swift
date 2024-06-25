//
//  FoodItemDetailViewModel.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-22.
//

import Foundation

class FoodItemDetailViewModel: ObservableObject {
    let nutritionixAPIManager: NutritionixAPIManagerDelegate
    @Published var isError: Bool = false
    var errorMessage: String = ""
    @Published var food: Food? = nil {
        didSet {
            setQuantity(food?.servingQuantity ?? 0)
            mapNutrientInformation()
        }
    }
    @Published var selectedNixItemId = "" {
        didSet {
            searchFoodItemByNixId(selectedNixItemId)
        }
    }
    @Published var quantity: Double = 0
    @Published var nutrientsInfo: [NutrientInfo] = []
    /// Nutrients name and unit mapping
    /// Ref: https://docx.syndigo.com/developers/docs/list-of-all-nutrients-and-nutrient-ids-from-api
    lazy var nutrientMap: [NutrientMap] = {
        let filePath = Bundle.main.path(forResource: "Nutrients", ofType: "json")!
        let fileUrl  = URL(fileURLWithPath: filePath)
        guard let data = try? Data(contentsOf: fileUrl), let nutrientMap = try? JSONDecoder().decode([NutrientMap].self, from: data)
        else { return [] }
        return nutrientMap
    }()
    
    
    init(nutritionixAPIManager: NutritionixAPIManagerDelegate, selectedNixItemId: String) {
        self.nutritionixAPIManager = nutritionixAPIManager
        self.selectedNixItemId = selectedNixItemId
    }
    
    ///Fetch food details for selected item
    func searchFoodItemByNixId(_ nixId: String) {
        Task {
            do {
                let response: SearchItemEndPointResponse = try await nutritionixAPIManager.getFoodItemsByNixId(nixId)
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self, response.foods.count > 0 else  {
                        return
                    }
                    weakSelf.food = response.foods[0]
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
    /// Mapping name and unit for retrived nutrient ids
    func mapNutrientInformation() {
        guard let food = self.food,
              let fullNutrients = food.fullNutrients else { return }
        
        self.nutrientsInfo = fullNutrients.compactMap{ nutrient -> NutrientInfo? in
            guard let nutrientMap = nutrientMap.first(where: { $0.attributeId == nutrient.attributeId }) else {
                return nil
            }
            return NutrientInfo(
                attributeId: nutrient.attributeId,
                amount: nutrient.amount,
                name: nutrientMap.name,
                unit: nutrientMap.unit)
        }
    }
    
    func setQuantity(_ value: Double) {
        quantity = value
    }
    
    /// Calculate calory and nutrient amount when serving size is changed.
    /// Formula ref: https://docx.syndigo.com/developers/docs/natural-language-for-nutrients#:~:text=Important%20note%20about%20serving%20sizes%3A
    func calculateNutrientAmount(for amount: Double, servingQuantity: Double, defaultQuantity: Double ) -> Double {
        (servingQuantity/defaultQuantity) * amount
    }
}
