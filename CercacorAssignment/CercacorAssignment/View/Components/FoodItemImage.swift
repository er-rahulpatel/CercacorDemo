//
//  FoodItemImage.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-21.
//

import SwiftUI
import SDWebImageSwiftUI

struct FoodItemImage: View {
    var url: String
    
    var body: some View {
        WebImage(url: URL(string: url))
            .resizable()
            .scaledToFill()
            .aspectRatio(contentMode: .fit)
    }
}

struct FoodItemImage_Previews: PreviewProvider {
    static var previews: some View {
        FoodItemImage(url: FoodItemThumbnail.getPreviewInitial().thumb)
    }
}
