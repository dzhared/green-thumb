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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
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
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
