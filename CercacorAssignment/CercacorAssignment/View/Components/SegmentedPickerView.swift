//
//  SegmentedPickerView.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-27.
//

import SwiftUI

struct SegmentedPickerView<T: Hashable>: View {
    @State private var favoriteColor = 0
    let segments: [T]
    @Binding var selection: T
    
    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                ForEach(segments, id: \.self) { segment in
                    Text(String(describing:segment).capitalized)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct SegmentedPickerView_Previews: PreviewProvider {
    @State static var selection: FoodItemTypes? = .common
    static var previews: some View {
        SegmentedPickerView(segments: FoodItemTypes.allCases, selection: $selection)
    }
}
