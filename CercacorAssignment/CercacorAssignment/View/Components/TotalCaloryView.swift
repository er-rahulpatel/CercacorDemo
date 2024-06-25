//
//  TotalCaloryView.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-24.
//

import SwiftUI

struct TotalCaloryView: View {
    let calory: Double
    
    var body: some View {
        
        Text("Amount Per Serving")
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
            Text("Calories")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(calory.format())
                .bold()
        }
        .font(.title3)
    }
}

struct TotalCaloryView_Previews: PreviewProvider {
    static var previews: some View {
        TotalCaloryView(calory: 50)
    }
}
