//
//  QuantityInputView.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-24.
//

import SwiftUI
import IQKeyboardManagerSwift

struct QuantityInputView: View {
    
    /// To manage keyboard and keep track of which field the user is focused on
    @Binding var quantity: Double
    let servingUnit: String?
    let servingWeightGrams: Double?
    let metricUOM: String?
    
    var body: some View {
        HStack {
            Stepper("", value: $quantity, in: 0...Double.greatestFiniteMagnitude){ _ in
                IQKeyboardManager.shared.resignFirstResponder()
            }
            .labelsHidden()
            TextField("Enter Value", value: $quantity, formatter: Double.decimalValueInputFormatter)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 15, maxWidth: 60)
            Text(self.servingUnit ?? "")
                .bold()
            if let servingWeightGrams = self.servingWeightGrams {
                Text("(\(servingWeightGrams.format())\(self.metricUOM ?? "g"))")
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
