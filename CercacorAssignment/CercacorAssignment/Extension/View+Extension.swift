//
//  View+Extension.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-22.
//

import Foundation
import SwiftUI

extension View {
    func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @ViewBuilder
    func ThickDivider() -> some View {
        Divider()
            .frame(height: 8)
            .overlay(.primary)
    }
}
