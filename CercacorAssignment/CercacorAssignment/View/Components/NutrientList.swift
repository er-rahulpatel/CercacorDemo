//
//  NutrientList.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-24.
//

import SwiftUI

struct NutrientList: View {
    let nutrients: [NutrientInfo]
    
    var body: some View {
        VStack {
            ForEach(Array(nutrients.enumerated()), id: \.offset) { index, nutrient in
                HStack{
                    Text(nutrient.name)
                        .fontWeight(.medium)
                    
                    Text("\(nutrient.amount.format())\(nutrient.unit)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                index < nutrients.count - 1 ? Divider() : nil
            }
            
        }
        
    }
}

struct NutrientList_Previews: PreviewProvider {
    static var previews: some View {
        NutrientList(nutrients: [NutrientInfo.getPreviewInitial()])
    }
}
