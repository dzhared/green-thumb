//
//  ContentView.swift
//  Green Thumb
//
//  Created by Jared on 3/8/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var showingPlantView = false
    @State var showingAddPlantView = false
    @State var showingCollectionView = false
    @StateObject var userPlants = UserPlants()
    @Environment(\.managedObjectContext) private var viewContext
    
    let plants: [String: Plant] = Bundle.main.decode("plants.json")
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(Array(plants.values).sorted { $0.name < $1.name } ) { plant in
                        PlantBadge(plant: plant)
                            .padding(.horizontal)
                            .sheet(isPresented: $showingPlantView) {
                                PlantDetailView(plant: plant)
                            }
                    }
                    .onTapGesture {
                        showingPlantView = true
                    }
                }
            }
            .background(Color.darkGreen)
            .preferredColorScheme(.dark)
            .navigationTitle("Green Thumb")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingAddPlantView = true
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle")
                        }
                    }
                    .sheet(isPresented: $showingAddPlantView) {
                        AddPlantView(userPlants: UserPlants())
                    }
                }
                // Change to open PlantCollectionView as screen, not sheet
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCollectionView = true
                    }) {
                        HStack {
                            Image(systemName: "leaf")
                            Spacer()
                        }
                    }
                    .sheet(isPresented: $showingCollectionView) {
                        CollectionView()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
