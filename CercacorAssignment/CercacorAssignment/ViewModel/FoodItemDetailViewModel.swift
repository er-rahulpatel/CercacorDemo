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
            scaleSubRecipesByServingWeight()
        }
    }
    @Published var selectedNixItemId: String? {
        didSet {
            if let selectedNixItemId = selectedNixItemId, !selectedNixItemId.isEmpty{
                searchBrandedFoodByNixItemId(selectedNixItemId) { food in
                    self.food = food
                }
            }
        }
    }
    @Published var selectedFoodName: String? {
        didSet {
            if let selectedFoodName = selectedFoodName, !selectedFoodName.isEmpty{
                searchNaturalNutrientsForCommonFood(selectedFoodName) { food in
                    self.food = food
                }
            }
        }
    }
    @Published var quantity: Double = 0 {
        didSet {
            updateNutrientInformation()
        }
    }
    @Published var nutrientsInfo: [NutrientInfo] = []
    @Published var subRecipes: [SubRecipe] = [] {
        didSet {
            updateNutrientInformation()
        }
    }
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
    
    init(nutritionixAPIManager: NutritionixAPIManagerDelegate, selectedFoodName: String) {
        self.nutritionixAPIManager = nutritionixAPIManager
        self.selectedFoodName = selectedFoodName
    }
    
    ///Fetch food details for selected branded food item
    func searchBrandedFoodByNixItemId(_ nixItemId: String, completion: @escaping (Food?) -> Void) {
        Task {
            do {
                let response: SearchItemEndPointResponse = try await nutritionixAPIManager.searchItemForBrandedFoodWith(
                    parameters: SearchItemEndPointParameter(nix_item_id: nixItemId))
                DispatchQueue.main.async {
                    guard !response.foods.isEmpty else  {
                        completion(nil)
                        return
                    }
                    completion(response.foods[0])
                }
            } catch {
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else  {
                        return
                    }
                    weakSelf.handleError(error)
                    completion(nil)
                }
                
            }
        }
        
        //        let filePath = Bundle.main.path(forResource: "SearchItemMock", ofType: "json")!
        //        let fileUrl  = URL(fileURLWithPath: filePath)
        //        let data = try! Data(contentsOf: fileUrl)
        //        self.food = try! JSONDecoder().decode(SearchItemEndPointResponse.self, from: data).foods[0]
    }
    
    ///Fetch food details for selected common food item
    func searchNaturalNutrientsForCommonFood(_ name: String,
                                             includeIngredientStatement: Bool = true,
                                             includeSubRecipe: Bool = true,
                                             completion: @escaping (Food?) -> Void) {
        Task {
            do {
                let response: NaturalNutrientsEndPointResponse = try await nutritionixAPIManager.naturalNutrientForCommonFoodWith(
                    parameters: NaturalNutrientsEndPointParameter(
                        query: name,
                        ingredient_statement: includeIngredientStatement,
                        include_subrecipe: includeSubRecipe))
                DispatchQueue.main.async {
                    guard !response.foods.isEmpty else  {
                        completion(nil)
                        return
                    }
                    completion(response.foods[0])
                }
            } catch {
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else  {
                        return
                    }
                    weakSelf.handleError(error)
                    completion(nil)
                }
            }
        }
        //        let filePath = Bundle.main.path(forResource: "NaturalNutrientsMock", ofType: "json")!
        //        let fileUrl  = URL(fileURLWithPath: filePath)
        //        let data = try! Data(contentsOf: fileUrl)
        //        self.food = try! JSONDecoder().decode(NaturalNutrientsEndPointResponse.self, from: data).foods[0]
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
    
    func updateNutrientInformation() {
        guard let food = self.food,
              let fullNutrients = food.fullNutrients else { return }
        
        guard let subRecipes = food.subRecipes, !subRecipes.isEmpty else {
            self.nutrientsInfo.updateEach{ nutrient in
                guard let originalNutrient = fullNutrients.first(where: { $0.attributeId == nutrient.attributeId }) else { return }
                nutrient.amount = calculateAmount(for: originalNutrient.amount, servingQuantity: quantity, defaultQuantity: food.servingQuantity)
            }
            return
        }
        
        // Dictionary to aggregate nutrient amounts
        var totalNutrientAmounts: [Int: Double] = [:]
        
        // Aggregate nutrient amounts from subRecipes
        self.subRecipes.forEach { subRecipe in
            guard let subRecipeFoodDetail = subRecipe.foodDetail,
                  let subRecipeFullNutrients = subRecipeFoodDetail.fullNutrients else { return }
            
            subRecipeFullNutrients.forEach { nutrient in
                totalNutrientAmounts[nutrient.attributeId, default: 0] += calculateAmount(for: nutrient.amount, servingQuantity: subRecipe.servingQuantity, defaultQuantity: subRecipeFoodDetail.servingQuantity)
                
            }
        }
        
        // Update self.nutrientsInfo based on aggregated amounts
        self.nutrientsInfo.updateEach { nutrientInfo in
            guard let totalAmount = totalNutrientAmounts[nutrientInfo.attributeId] else { return }
            nutrientInfo.amount = calculateAmount(for: totalAmount, servingQuantity: quantity, defaultQuantity: food.servingQuantity)
        }
    }
    /// Scale sub-recipes because for some food record, all ingredients total serving weight miss-match with food's serving weight
    func scaleSubRecipesByServingWeight() {
        guard let subRecipes = self.food?.subRecipes,
              let servingWeightGrams = self.food?.servingWeightGrams else { return }
        
        self.subRecipes = subRecipes
        let scale = servingWeightGrams / subRecipes.reduce(0, { $0+($1.servingWeight ?? 0) })
        self.subRecipes.updateEach { subRecipe in
            subRecipe.servingQuantity *= scale
            subRecipe.calories *=  scale
            subRecipe.servingWeight = (subRecipe.servingWeight ?? 0) * scale
        }
        // getSubRecipeDetailsTest()
        getSubRecipeDetails()
    }
    ///Fetch details for all sub recipes
    func getSubRecipeDetails() {
        // Create a DispatchGroup to synchronize async operations
        let group = DispatchGroup()
        
        // Use a temporary array to collect the updated sub-recipes
        var updatedSubRecipes: [SubRecipe?] = Array(repeating: nil, count: subRecipes.count)
        
        for (index, subRecipe) in subRecipes.enumerated() {
            group.enter() // Notify the group that we are entering
            searchNaturalNutrientsForCommonFood(subRecipe.foodName) { food in
                var updatedSubRecipe = subRecipe
                updatedSubRecipe.foodDetail = food
                updatedSubRecipes[index] = updatedSubRecipe
                
                group.leave() // Notify the group that we are leaving
            }
        }
        
        // Notify when all async tasks are completed
        group.notify(queue: DispatchQueue.main) {
            // Assign the updated sub-recipes after all async tasks are done
            self.subRecipes = updatedSubRecipes.compactMap { $0 }
        }
    }
    
    
    //    func getSubRecipeDetailsTest() {
    //        subRecipes[0].foodDetail = try! JSONDecoder().decode(NaturalNutrientsEndPointResponse.self, from: try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "SubRecipe1Mock", ofType: "json")!))).foods[0]
    //        subRecipes[1].foodDetail = try! JSONDecoder().decode(NaturalNutrientsEndPointResponse.self, from: try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "SubRecipe2Mock", ofType: "json")!))).foods[0]
    //        subRecipes[2].foodDetail = try! JSONDecoder().decode(NaturalNutrientsEndPointResponse.self, from: try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "SubRecipe3Mock", ofType: "json")!))).foods[0]
    //        subRecipes[3].foodDetail = try! JSONDecoder().decode(NaturalNutrientsEndPointResponse.self, from: try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "SubRecipe4Mock", ofType: "json")!))).foods[0]
    //    }
    
    ///Method to update sub-recipe calories and weight when it's quantity changes
    func updateSubRecipe(_ subRecipe: inout SubRecipe) {
        guard let originalSubRecipes = self.food?.subRecipes,
              originalSubRecipes.count == self.subRecipes.count,
              let originalSubRecipe = originalSubRecipes.first(where:{ $0.ndbNumber == subRecipe.ndbNumber }) else { return }
        
        subRecipe.calories = calculateAmount(for: originalSubRecipe.calories, servingQuantity: subRecipe.servingQuantity, defaultQuantity: originalSubRecipe.servingQuantity)
        subRecipe.servingWeight = calculateAmount(for: originalSubRecipe.servingWeight ?? 0, servingQuantity: subRecipe.servingQuantity, defaultQuantity: originalSubRecipe.servingQuantity)
    }
    
    func setQuantity(_ value: Double) {
        quantity = value
    }
    
    /// Calculate calories and nutrient amount when serving size is changed.
    /// Formula ref: https://docx.syndigo.com/developers/docs/natural-language-for-nutrients#:~:text=Important%20note%20about%20serving%20sizes%3A
    func calculateAmount(for amount: Double, servingQuantity: Double, defaultQuantity: Double ) -> Double {
        (servingQuantity/defaultQuantity) * amount
    }
    
    func getTotalWeightGrams(for food: Food) -> Double {
        guard let subRecipes = food.subRecipes, !subRecipes.isEmpty else { return (food.servingWeightGrams ?? 0) * quantity }
        return (self.subRecipes.reduce(0){ $0 + ($1.servingWeight ?? 0) }) * quantity
    }
    
    func getTotalCalories(for food: Food) -> Double {
        guard let subRecipes = food.subRecipes, !subRecipes.isEmpty else { return food.calories * quantity }
        return (self.subRecipes.reduce(0){ $0 + $1.calories }) * quantity
    }
    
}
