//
//  AddPlantView.swift
//  Green Thumb
//
//  Created by Jared on 3/10/23.
//

import CoreData
import PhotosUI
import SwiftUI

struct AddPlantView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var nickName = ""
    @State private var species: String = "African Violet"
    @State private var info: String = ""
    @State private var birthday: Date = Date()
    @State private var signString: String = "Sign"
    @State private var signEmoji: String = "Emoji"
    
    var sign: (String, String) {
        getSign(date: birthday)
    }
    
    @State private var prediction: String?
    @State var selectedItem: PhotosPickerItem?
    
    let predictor = ImagePredictor()
    
    let speciesOptions = ["African Violet", "Calathea", "Dracaena", "Ivy", "Pothos", "Snake Plant", "Spider Plant"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Nickname", text: $nickName)
                        .autocorrectionDisabled()
                        .autocapitalization(.words)
                        .keyboardType(.default)
                    TextField("Description", text: $info)
                        .keyboardType(.default)
                    Picker("Species", selection: $species) {
                        ForEach(speciesOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    DatePicker(
                        "Birthday",
                        selection: $birthday,
                        displayedComponents: [.date]
                    )
                    HStack {
                        Spacer()
                        ZStack(alignment: .bottomTrailing) {
                            Image(species)
                            VStack {
                                Text(species)
                                Text("\(sign.0) \(sign.1)")
                            }
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(.black.opacity(0.75))
                            .clipShape(Capsule())
                            .offset(x: -5, y: -5)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        Spacer()
                    }
                }
                
                Section {
                    // Add ML image ID functionality
                    PhotosPicker(selection: $selectedItem) {
                        HStack {
                            Spacer()
                            Image(systemName: "camera")
                            Text("Visual ID")
                            Spacer()
                        }
                    }
                }
                Section {
                    Button("Save") {
                        // Add plant to library
                        let newUserPlant = UserPlant(context: moc)
                        newUserPlant.id = UUID()
                        newUserPlant.nickName = nickName
                        newUserPlant.info = info
                        newUserPlant.species = species
                        newUserPlant.signString = sign.0
                        newUserPlant.signEmoji = sign.1
                        
                        // Save and dismiss
                        try? moc.save()
                        dismiss()
                    }
                }
                .navigationTitle("Add a Plant")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct AddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlantView()
    }
}

