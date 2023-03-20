//
//  PlantCollectionView.swift
//  Green Thumb
//
//  Created by Jared on 3/9/23.
//

import SwiftUI

struct ContentView: View {
    
    // Assign managed object context to property
    @Environment(\.managedObjectContext) var moc
    // Fetch plants from CoreData
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.nickName)
    ]) var userPlants: FetchedResults<UserPlant>
    
    @State var showingAddView = false
    @State var showingPlantView = false
    @Environment(\.dismiss) var dismiss
    
    func deleteUserPlants(at offsets: IndexSet) {
        for offset in offsets {
            let plant = userPlants[offset]
            moc.delete(plant)
        }
        try? moc.save()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("My Plants")) {
                    ForEach(userPlants) { plant in
                        NavigationLink(destination: HoroscopeView(plant: plant)) {
                            HStack {
                                // TODO: Source clearer, cited plant photos
                                Image(plant.species ?? "Calathea")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:75, height:75)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(.white, lineWidth: 2)
                                    )
                                    .padding()
                                VStack(alignment: .leading) {
                                    Text("\(plant.nickName ?? "Nickname") \(plant.signEmoji ?? "")")
                                        .font(.title3)
                                    Text(plant.info ?? "Description")
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteUserPlants)
                }
            }
            // How to change background color?
            .background(Color.darkGreen)
            .navigationTitle("My Plants")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ReferenceView()
                    } label: {
                        Image(systemName: "book")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddPlantView()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddPlantView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
