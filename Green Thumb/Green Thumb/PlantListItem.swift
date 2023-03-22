//
//  PlantBadge.swift
//  Green Thumb
//
//  Created by Jared on 3/9/23.
//

import SwiftUI

struct PlantListItem: View {
    let plant: Plant
    
    var body: some View {
        HStack {
            Image(plant.name)
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

struct PlantBadge_Previews: PreviewProvider {
    static var previews: some View {
        PlantListItem(plant: Plant(id: "calathea", name: "Calathea", description: "Calathea desc", water: "Calathea water", soil: "Calathea med", temperature: "Calathea temp", humidity: "Calathea humidity", light: "Calathea light", source: "Info source"))
            .preferredColorScheme(.dark)
    }
}
