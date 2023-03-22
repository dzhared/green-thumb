//
//  ImageClassifier.swift
//  Green Thumb
//
//  Created by Jared on 3/16/23.
//

import CoreML
import PhotosUI
import SwiftUI
import Vision

class ImagePredictor {
    static func createImageClassifier() -> VNCoreMLModel {
        // Use default model configuration
        let defaultConfig = MLModelConfiguration()
        
        // Create instance of image classifier's wrapper class
        let imageClassifierWrapper = try? GreenThumbML(configuration: defaultConfig)
        
        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }
        
        // Get underlying model instance
        let imageClassifierModel = imageClassifier.model
        
        // Create a Vision instance using image classifier's model instance
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }
        
        return imageClassifierVisionModel
    }
    
    static let imageClassifier = createImageClassifier()
    
    struct Prediction {
        // Name of the object the classifier recognizes in an image
        let classification: String
    }
    
    // The function signature the caller must provide as a completion handler
    typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void
    
    // Dictionary of prediction handler functions
    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()
    
    // Generate new request instance using Image Predictor's image classifier model
    private func createImageClassificationRequest() -> VNImageBasedRequest {
        // Create an image classification request with an image classifier model
        let imageClassificationRequest = VNCoreMLRequest(model: ImagePredictor.imageClassifier, completionHandler: visionRequestHandler)
        
        imageClassificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        return imageClassificationRequest
    }
    
    // Generates an image classification prediction for a photo
    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws {
        
        guard let photoImage = photo.cgImage else {
            fatalError("Photo doesn't have underlying CGImage.")
        }
        
        let imageClassificationRequest = createImageClassificationRequest()
        predictionHandlers[imageClassificationRequest] = completionHandler
        
        let handler = VNImageRequestHandler(cgImage: photoImage)
        let requests: [VNRequest] = [imageClassificationRequest]
        
        // Start image classification request
        try handler.perform(requests)
    }
    
    func visionRequestHandler(_ request: VNRequest, error: Error?) {
        // Remove caller's handler from the dictionary and keep a reference to it
        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
            fatalError("Every request must have a prediction handler.")
        }
        
        // Start with `nil` value in case there's a problem.
        var predictions: [Prediction]? = nil
        
        // Call client's completion handler after method returns
        defer {
            // Send predictions back to client
            predictionHandler(predictions)
        }
        
        // Check for errors first
        if let error = error {
            print("Vision image classification error:\n\(error.localizedDescription)")
            return
        }
        
        // Check results aren't `nil`
        if request.results == nil {
            print("Vision request had no results.")
            return
        }
        
        // Cast request's results as `VNClassificationObservation` array.
        guard let observations = request.results as? [VNClassificationObservation] else {
            // Image classifier only produces classification observations
            // This guard let statement can probably be removed
            print("VNRequest produced the wrong type: \(type(of: request.results)).")
            return
        }
        
        // Create a prediction array from the observations
        predictions = observations.map { observation in
            // Convert each observation into an `ImagePredictor.Prediction` instance
            Prediction(classification: observation.identifier)
        }
    }
}


