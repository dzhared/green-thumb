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
    
    @State private var prediction: String?
    @State var selectedItem: PhotosPickerItem?
    
    let predictor = ImagePredictor()
    
    let speciesOptions = ["African Violet", "Calathea", "Dracaena", "Ivy", "Pothos", "Snake Plant", "Spider Plant"]
    
    func getSign(date: Date) -> String {
        let year = Calendar.current.component(.year, from: date)
        
        let aquarius: Date = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 21))!
        let pisces = Calendar.current.date(from: DateComponents(year: year, month: 2, day: 19))!
        let aries = Calendar.current.date(from: DateComponents(year: year, month: 3, day: 21))!
        let taurus = Calendar.current.date(from: DateComponents(year: year, month: 4, day: 20))!
        let gemini = Calendar.current.date(from: DateComponents(year: year, month: 5, day: 21))!
        let cancer = Calendar.current.date(from: DateComponents(year: year, month: 6, day: 21))!
        let leo = Calendar.current.date(from: DateComponents(year: year, month: 7, day: 23))!
        let virgo = Calendar.current.date(from: DateComponents(year: year, month: 8, day: 23))!
        let libra = Calendar.current.date(from: DateComponents(year: year, month: 9, day: 23))!
        let scorpio = Calendar.current.date(from: DateComponents(year: year, month: 10, day: 23))!
        let sagittarius = Calendar.current.date(from: DateComponents(year: year, month: 11, day: 22))!
        let capricorn = Calendar.current.date(from: DateComponents(year: year, month: 12, day: 21))!
        
        if date >= aquarius && date < pisces {
            return "Aquarius ♒️"
        } else if date >= pisces && date < aries {
            return "Pisces ♓️"
        } else if date >= aries && date < taurus {
            return "Aries ♈️"
        } else if date >= taurus && date < gemini {
            return "Taurus ♉️"
        } else if date >= gemini && date < cancer {
            return "Gemini ♊️"
        } else if date >= cancer && date < leo {
            return "Cancer ♋️"
        } else if date >= leo && date < virgo {
            return "Leo ♌️"
        } else if date >= virgo && date < libra {
            return "Virgo ♍️"
        } else if date >= libra && date < scorpio {
            return "Libra ♎️"
        } else if date >= scorpio && date < sagittarius {
            return "Scorpio ♏️"
        } else if date < capricorn {
            return "Sagittarius ♐️"
        } else {
            return "Capricorn ♑️"
        }
    }
    
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
                    ZStack(alignment: .bottomTrailing) {
                        Image(species)
                        VStack {
                            Text(species)
                            Text(getSign(date: birthday))
                        }
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(.black.opacity(0.75))
                            .clipShape(Capsule())
                            .offset(x: -5, y: -5)
                    }
                }
                
                Section {

                }
                
                Section {
                    // Add ML image ID functionality
                    PhotosPicker(selection: $selectedItem) {
                        HStack {
                            Spacer()
                            Image(systemName: "camera")
                            Text("Select Photo")
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

