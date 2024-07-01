//
//  SubRecipeRow.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-29.
//

import SwiftUI

struct SubRecipeRow: View {
    @Binding var subRecipe: SubRecipe
    let updateSubRecipe: UpdateSubRecipeAction
    
    var body: some View {
        VStack {
            HStack {
                Text(subRecipe.foodName)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(subRecipe.calories.format() + " Cal")
                    .fontWeight(.medium)
            }
            ///Quantity input text field with stepper
            QuantityInputView(
                quantity: $subRecipe.servingQuantity,
                servingUnit: subRecipe.servingUnit,
                servingWeightGrams: subRecipe.servingWeight,
                metricUOM: "g")
            .frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: subRecipe.servingQuantity) { newValue in
                updateSubRecipe(&subRecipe)
            }
        }
    }
}

struct SubRecipeRow_Previews: PreviewProvider {
    @State static var subRecipe: SubRecipe = SubRecipe.getPreviewInitial()
    static var previews: some View {
        SubRecipeRow(subRecipe: $subRecipe) { subRecipe in
            
        }
    }
}
