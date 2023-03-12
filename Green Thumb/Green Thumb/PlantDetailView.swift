//
//  PlantView.swift
//  Green Thumb
//
//  Created by Jared on 3/8/23.
//

import SwiftUI
import Foundation

struct PlantView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let plant: Plant
    
    var body: some View {
        ScrollView {
            VStack {
                Image(plant.id)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(.white, lineWidth: 2)
                    )
                Text(plant.name)
                    .font(.title)
                RectangleDivider()
                Text(plant.description)
            }
            .padding()
        }
        .background(Color.darkGreen)
        .foregroundColor(.white)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            Button("Add") {
                // Add plant to collection
                dismiss()
            }
        }
    }
}

struct PlantView_Previews: PreviewProvider {
    
    static let plants: [String: Plant] = Bundle.main.decode("plants.json")
    
    static var previews: some View {
        PlantView(plant: plants["africanViolet"]!)
    }
}
