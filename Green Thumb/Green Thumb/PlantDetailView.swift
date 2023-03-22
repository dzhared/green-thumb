//
//  PlantView.swift
//  Green Thumb
//
//  Created by Jared on 3/8/23.
//

import SwiftUI

struct PlantDetailView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    
    let plant: Plant
    
    // MARK: - View
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                HeaderView(plant: plant)
                ParagraphView(title: "Description", info: plant.description)
                ParagraphView(title: "Watering", info: plant.water)
                ParagraphView(title: "Soil", info: plant.soil)
                ParagraphView(title: "Temperature", info: plant.temperature)
                ParagraphView(title: "Humidity", info: plant.humidity)
                ParagraphView(title: "Light", info: plant.light)
                Text("Information from \(plant.source)")
                    .font(.subheadline)
            }
        }
        .padding()
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
    
    struct HeaderView: View {
        let plant: Plant
        
        var body: some View {
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
            }
        }
    }
    
    struct ParagraphView: View {
        let title: String
        let info: String
        
        var body: some View {
            if !info.isEmpty {
                RectangleDivider()
                Text(title)
                    .font(.title2)
                Text(info)
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
