//
//  AddPlantView.swift
//  Green Thumb
//
//  Created by Jared on 3/10/23.
//

import CoreData
import PhotosUI
import SwiftUI
import Vision

struct AddPlantView: View {
    
    static func createImageClassifier() -> VNCoreMLModel {
        let defaultConfig = MLModelConfiguration()
        let imageClassifierWrapper = try? GreenThumbML(configuration: defaultConfig)
        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("Failed to create image classifier model instance.")
        }
        let imageClassifierModel = imageClassifier.model
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("Failed to create VNCoreMLModel instance.")
        }
        return imageClassifierVisionModel
    }
    
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
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    @State private var imagePredictor = ImagePredictor()
    
    
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
                    // PhotosPicker is causing memory leak!
                    PhotosPicker(selection: $selectedPhoto) {
                        HStack {
                            Spacer()
                            Image(systemName: "camera")
                            Text("Pick Photo")
                            Spacer()
                        }
                    }
                    Text("Predicted Species: \(prediction ?? "N/A")")
                    Button("Run ML") {
                        // Get photo data to be converted to image
                        guard let data = selectedPhotoData else {
                            return
                        }
                        
                        // Run the image classification request on a background thread
                        DispatchQueue.global(qos: .userInitiated).async {
                            do {
                                let image = UIImage(data: data)
                                let handler = VNImageRequestHandler(cgImage: image!.cgImage!)
                                let imageClassificationRequest = VNCoreMLRequest(model: AddPlantView.createImageClassifier(), completionHandler: { request, error in
                                    guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                                        return
                                    }
                                    DispatchQueue.main.async {
                                        self.prediction = topResult.identifier
                                    }
                                })
                                try handler.perform([imageClassificationRequest])
                            } catch {
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                
                Section {
                    Button("Show Photo") {

                    }
                    if let selectedPhotoData, let image = UIImage(data: selectedPhotoData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipped()
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

