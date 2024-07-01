//
//  RestaurantView.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-29.
//

import SwiftUI
import MapKit

enum RestaurantViewType: CaseIterable {
    case map
    case list
}

struct RestaurantView: View {
    @StateObject var restaurantViewModel: RestaurantViewModel
    
    var body: some View {
        VStack {
            if let foodName = restaurantViewModel.foodName, !restaurantViewModel.restaurants.isEmpty {
                Text("Nearby restaurants to get **\(foodName)**.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical,4)
                
                SegmentedPickerView(
                    segments: [RestaurantViewType.map, RestaurantViewType.list],
                    selection:$restaurantViewModel.selectedViewType)
                .padding(.horizontal)
                
                ZStack {
                    RestaurantMap(
                        restaurants: restaurantViewModel.restaurants,
                        coordinate: restaurantViewModel.currentLocation?.coordinate ?? CLLocationCoordinate2D())
                        .opacity(restaurantViewModel.selectedViewType == .map ? 1 : 0)
                    
                    RestaurantList(restaurants: restaurantViewModel.restaurants)
                        .opacity(restaurantViewModel.selectedViewType == .list ? 1 : 0)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
            }else {
                Text("No nearby restaurants found.")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Restaurants")
        .alert(restaurantViewModel.errorMessage,
               isPresented: $restaurantViewModel.isError,
               actions: {
            Button("Ok", role: .cancel){}
        })
    }
}



struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantView(restaurantViewModel: RestaurantViewModel(locationManager: LocationManager.shared, foodName: ""))
    }
}
