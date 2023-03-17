//
//  ImagePredictorButton.swift
//  Green Thumb
//
//  Created by Jared on 3/16/23.
//

import SwiftUI
import PhotosUI

struct PhotosSelector: View {
    @State var imageSelection: [PhotosPickerItem] = []
    
    var body: some View {
        PhotosPicker(selection: $imageSelection, maxSelectionCount: 1) {
            Text("Select Photos")
        }
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Image.self) { result in
            DispatchQueue.main.async {
                guard [imageSelection] == self.imageSelection else { return }
                switch result {
                case .success(let image?):
                    print("Image loaded.")
                case .success(nil):
                    print("No image loaded.")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct PhotosSelector_Previews: PreviewProvider {
    static var previews: some View {
        PhotosSelector()
    }
}
