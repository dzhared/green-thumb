//
//  AddPlantView.swift
//  Green Thumb
//
//  Created by Jared on 3/10/23.
//

import SwiftUI

struct AddPlantView: View {
    
    @State private var nickName = ""
    @State private var name: String = ""
    @State private var description: String = ""
    @ObservedObject var userPlants: UserPlants
    @Environment(\.dismiss) var dismiss
    
    let plants: [String: Plant] = Bundle.main.decode("plants.json")
    var plantIDs: [String] {
        Array(plants.keys).sorted()
    }
    
    enum Plants: String {
        case africanViolet = "African Violet"
        case calathea = "Calathea"
        case dracaena = "Dracaena"
        case ivy = "Ivy"
        case pothos = "Pothos"
        case snakePlant = "Snake Plant"
        case spiderPlant = "Spider Plant"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // TODO: Is there a more elegant way to do this?
                    Picker("Species", selection: $name) {
                        ForEach(plantIDs, id: \.self) { plantID in
                            Text(plants[plantID]!.name)
                        }
                    }
                    TextField("Nickname", text: $nickName)
                        .autocorrectionDisabled()
                        .autocapitalization(.words)
                        .keyboardType(.default)
                    TextField("Description", text: $description)
                        .keyboardType(.default)
                }
                Section {
                    // Add ML image ID functionality
                    Button(action: {  }) {
                        HStack {
                            Spacer()
                            Image(systemName: "camera")
                            Text("Visual ID")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Add a Plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // "name: name" is entering plantID, not name, into new entry
                        print(plants["\(name)"] ?? "Calathea")
                        
                        let newPlant = UserPlant(name: name, nickName: nickName, description: description)
                        userPlants.plants.append(newPlant)
                        dismiss()
                    }
                }
            }
        }
    }
}


struct AddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlantView(userPlants: UserPlants())
    }
}
