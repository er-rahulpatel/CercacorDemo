//
//  FoodItemRow.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-21.
//

import SwiftUI

struct FoodItemRow: View {
    let foodItem: FoodItemDisplay
    
    var body: some View {
        HStack {
            //            AsyncImage(url: URL(string: foodItem.photo.thumb)) { response in
            //                switch response {
            //                case .failure:
            //                    Image(systemName: "placeholder")
            //                        .font(.largeTitle)
            //                case .success(let image):
            //                    image.resizable()
            //                default: ProgressView()
            //                }
            //            }
            FoodItemImage(url: foodItem.thumbnail)
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .shadow(radius: 2)
            
            VStack {
                Text(foodItem.name.capitalized)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(foodItem.calories.format()) cal")
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Image(systemName: "chevron.right")
        }
    }
}

struct FoodItemRow_Previews: PreviewProvider {
    static var previews: some View {
        FoodItemRow(foodItem: FoodItemDisplay.getPreviewInitial())
    }
}
