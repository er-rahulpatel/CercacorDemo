//
//  SubRecipeList.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-28.
//

import SwiftUI

typealias UpdateSubRecipeAction = (_ subRecipe: inout SubRecipe) -> Void

struct SubRecipeList: View {
    @Binding var subRecipes: [SubRecipe]
    let updateSubRecipe: UpdateSubRecipeAction
    
    var body: some View {
        VStack {
            ForEach(Array(subRecipes.enumerated()), id: \.offset) { index, subRecipe in
                SubRecipeRow(subRecipe: $subRecipes[index], updateSubRecipe: updateSubRecipe)
                
                index < subRecipes.count - 1 ? Divider() : nil
            }
        }
    }
}

struct SubRecipeList_Previews: PreviewProvider {
    @State static var subRecipes: [SubRecipe] = []
    static var previews: some View {
        SubRecipeList(subRecipes: $subRecipes) { subRecipe in
        }
    }
}
