//
//  PlantView.swift
//  Green Thumb
//
//  Created by Jared on 3/8/23.
//

import SwiftUI
import Foundation

struct PlantDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let plant: Plant
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 10) {
                Group {
                    Image(plant.name)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(.white, lineWidth: 2)
                        )
                        .padding(.bottom)
                    Text(plant.name)
                        .font(.title)
                    RectangleDivider()
                }
                Group {
                    Text("Description")
                        .font(.title2)
                    Text(plant.description)
                    RectangleDivider()
                    Text("Watering Requirements")
                        .font(.title2)
                    Text(plant.wateringRequirements)
                    RectangleDivider()
                    Text("Growing Medium")
                        .font(.title2)
                    Text(plant.growingMedium)
                }
                
            }
            .padding()
        }
        .background(Color.darkGreen)
        .foregroundColor(.white)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    
    static let plants: [String: Plant] = Bundle.main.decode("plants.json")
    
    static var previews: some View {
        PlantDetailView(plant: plants["africanViolet"]!)
    }
}
