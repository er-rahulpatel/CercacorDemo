//
//  CalorieView.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-25.
//

import SwiftUI

struct CalorieView: View {
    let calories: Double
    
    var body: some View {
        
        Text("Amount Per Serving")
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
            Text("Calories")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(calories.format())
                .bold()
        }
        .font(.title3)
    }
}

struct CalorieView_Previews: PreviewProvider {
    static var previews: some View {
        CalorieView(calories: 50)
    }
}
