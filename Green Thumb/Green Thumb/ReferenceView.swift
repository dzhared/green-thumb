//
//  ContentView.swift
//  Green Thumb
//
//  Created by Jared on 3/8/23.
//

import SwiftUI
import CoreData

struct ReferenceView: View {
    
    // MARK: - Properties
    
    @State var showingPlantDetailView = false
    @State private var plantDetail: Plant?
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var plants: [String: Plant] {
        Bundle.main.decode("plants.json")
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(Array(plants.values).sorted { $0.name < $1.name } ) { plant in
                        PlantListItem(plant: plant)
                            .padding(.horizontal)
                            .onTapGesture {
                                plantDetail = plant
                                showingPlantDetailView = true
                            }
                    }
                }
            }
            .preferredColorScheme(.dark)
            .background(Color.darkGreen)
            .navigationTitle("Plant Reference")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingPlantDetailView) {
                PlantDetailView(plant: plantDetail ?? Plant(id: "calathea", name: "Calathea", description: "Calathea desc", water: "Calathea water", soil: "Calathea med", temperature: "Calathea temp", humidity: "Calathea humidity", light: "Calathea light", source: "Info source"))
            }
        }
    }
}

struct ReferenceView_Previews: PreviewProvider {
    static var previews: some View {
        ReferenceView()
    }
}
