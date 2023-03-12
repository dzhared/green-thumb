//
//  PlantBadge.swift
//  Green Thumb
//
//  Created by Jared on 3/9/23.
//

import SwiftUI

struct PlantBadge: View {
    
    @State var showingPlantView = false
    
    let plant: Plant
    
    var body: some View {
        NavigationLink {
            PlantDetailView(plant: plant)
        } label: {
            HStack {
                Image(plant.id)
                    .resizable()
                    .scaledToFill()
                    .frame(width:50, height:50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.white, lineWidth: 2)
                    )
                    .padding()
                Text(plant.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: 70)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.white, lineWidth: 2)
            )
        }
    }
}
