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
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var photosPickerItemData: Data?
    @State private var imagePredictor = ImagePredictor()
    
    let speciesOptions = ["African Violet", "Calathea", "Dracaena", "Ivy", "Pothos", "Snake Plant", "Spider Plant"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Nickname", text: $nickName)
                        .autocapitalization(.words)
                    TextField("Description", text: $info)
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
                    PlantImage(species: species, sign: sign)
                }
                
                Section {
                    PhotosPicker(selection: $photosPickerItem) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Pick Photo")
                        }
                    }
                    Button("Predict Species") {
                        // Get photo data to be converted to image
                        guard let data = photosPickerItemData else {
                            return
                        }
                        // Run the image classification request on a background thread
                        recognizeImage(from: data)
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
                .onChange(of: photosPickerItem) { selectedPhotosPickerItem in
                    guard let selectedPhotosPickerItem else {
                        return
                    }
                    Task {
                        await updatePhotosPickerItem(with: selectedPhotosPickerItem)
                    }
                }
            }
        }
    }
    
    private func updatePhotosPickerItem(with item: PhotosPickerItem) async {
        photosPickerItem = item
        if let photoData = try? await item.loadTransferable(type: Data.self) {
            photosPickerItemData = photoData
        }
    }
    
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
    
    func recognizeImage(from data: Data) {
        do {
            let image = UIImage(data: data)
            let handler = VNImageRequestHandler(cgImage: image!.cgImage!)
            let imageClassificationRequest = VNCoreMLRequest(model: AddPlantView.createImageClassifier(), completionHandler: { request, error in
                guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                    return
                }
                DispatchQueue.main.async {
                    self.prediction = topResult.identifier
                    species = topResult.identifier
                }
            })
            try handler.perform([imageClassificationRequest])
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

struct AddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlantView()
    }
}

