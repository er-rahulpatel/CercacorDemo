//
//  QuantityInputView.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-24.
//

import SwiftUI

struct QuantityInputView: View {
    
    /// To manage keyboard and keep track of which field the user is focused on
    @FocusState private var focusedField: String?
    @Binding var quantity: Double
    let servingUnit: String
    let servingWeightGrams: Double?
    let metricUOM: String?
    
    var body: some View {
        Text("Serving size")
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
        
        
        HStack {
            Stepper("", value: $quantity, in: 0...Double.greatestFiniteMagnitude) { _ in
                focusedField = nil
            }
            .labelsHidden()
            TextField("Enter Value", value: $quantity, formatter: Double.decimalValueFormatter)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 15, maxWidth: 60)
                .focused($focusedField, equals: "quantity")
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Done") {
                            focusedField = nil
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            Text(self.servingUnit)
                .bold()
            if let servingWeightGrams = self.servingWeightGrams {
                Text("(\(servingWeightGrams.format())\(self.metricUOM ?? ""))")
                    .bold()
            }
        }
    }
}

struct QuantityInputView_Previews: PreviewProvider {
    @State static var quantity: Double = 0
    static var previews: some View {
        QuantityInputView(quantity: $quantity, servingUnit: "bun", servingWeightGrams: 50, metricUOM: "mg")
    }
}
