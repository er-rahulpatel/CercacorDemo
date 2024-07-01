//
//  FoodDetailHeader.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-24.
//

import SwiftUI

struct FoodDetailHeader: View {
    let name: String
    let photo: String?
    let brandName: String?
    
    var body: some View {
        HStack(alignment: .center) {
            FoodItemImage(url: photo ?? "")
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .shadow(radius: 2)
            
            VStack {
                Text(name.capitalized)
                    .font(.title3)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let brandName = brandName {
                    Text(brandName)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct FoodDetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailHeader(
            name: "Hamburger Buns, Enriched",
            photo: "https://nutritionix-api.s3.amazonaws.com/536020b12ae36a5775c0a4da.jpeg",
            brandName: "Great Value")
    }
}
