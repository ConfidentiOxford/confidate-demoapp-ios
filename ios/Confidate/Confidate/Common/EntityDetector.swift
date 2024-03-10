import Foundation
import UIKit
import CoreML


class EntityDetector {

    private let ENTITIES: [String] = [
        "person", "bicycle", "car", "motorbike", "aeroplane", "bus", "train", "truck", "boat", "traffic light",
        "fire hydrant", "stop sign", "parking meter", "bench", "bird", "cat", "dog", "horse", "sheep", "cow",
        "elephant", "bear", "zebra", "giraffe", "backpack", "umbrella", "handbag", "tie", "suitcase", "frisbee",
        "skis", "snowboard", "sports ball", "kite", "baseball bat", "baseball glove", "skateboard", "surfboard",
        "tennis racket", "bottle", "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana", "apple",
        "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake", "chair", "sofa",
        "pottedplant", "bed", "diningtable", "toilet", "tvmonitor", "laptop", "mouse", "remote", "keyboard",
        "cell phone", "microwave", "oven", "toaster", "sink", "refrigerator", "book", "clock", "vase", "scissors",
        "teddy bear", "hair drier", "toothbrush"
    ]
    private let ENTITIES_TO_REMOVE: Set<String> = [
        "chair", "sofa", "pottedplant", "bed", "diningtable", "toilet",
        "tvmonitor", "laptop", "mouse", "remote", "keyboard",
        "cell phone", "microwave", "oven", "toaster", "sink", "refrigerator",
        "book", "clock", "vase", "scissors", "teddy bear", "hair drier", "toothbrush",
        "cat", "dog", "person"
    ]
    
    private let model: YOLOv3
    private let imageProcessor: ImageProcessor
    init(){
        model = YOLOv3()
        imageProcessor = ImageProcessor()
    }
    
    func detect(images: [UIImage]) throws-> String {
        do {
            var entities: [[String]] = []
            for image in images {
                let imageEntities = try detectEntitiesImage(image: image, threshold: 0.8)
                entities.append(imageEntities)
            }
            let mergedEntities = mergeEntities(entities: entities)
            return mergedEntities.joined(separator: " ")
        } catch {
            print("Error predicting: \(error)")
            return ""
        }
    }
    
    private func mergeEntities(entities: [[String]]) -> [String] {
        let mergedEntities: [String] = Set(entities.flatMap { $0 }).sorted()
        return mergedEntities
    }

    private func detectEntitiesImage(image: UIImage, threshold: Double) throws -> [String] {
        do {
            let resizedImage = ImageProcessor.resize(
                image: image,
                size: CGSize(width: 416, height: 416)
            )
            let pixelBuffer = ImageProcessor.toCVPixelBuffer(image: resizedImage)
            let output = try performPrediction(pixelBuffer: try pixelBuffer!
            )
            let predictions = parsePrediction(prediction: output)
            return predictions
        } catch {
            print("Error predicting: \(error)")
            return [""]
        }
    }
    
    private func performPrediction(pixelBuffer: CVPixelBuffer) throws -> YOLOv3Output {
        let input = YOLOv3Input(image: pixelBuffer)
        return try model.prediction(input: input)
    }
    
    private func parsePrediction(prediction: YOLOv3Output) -> [String] {
        var predictedClasses = Set<String>()
        let confidenceThreshold: Double = 0.4
        let numberOfBoxes = prediction.confidence.count / ENTITIES.count
        for boxIndex in 0..<numberOfBoxes {
           let classIndex = boxIndex * ENTITIES.count
           let classConfidences = (0..<ENTITIES.count).map { prediction.confidence[classIndex + $0].doubleValue }
           if let maxConfidence = classConfidences.max(), maxConfidence > confidenceThreshold {
               let maxIndex = classConfidences.firstIndex(of: maxConfidence)!
               let className = ENTITIES[maxIndex]
               if !ENTITIES_TO_REMOVE.contains(className) {
                   predictedClasses.insert(className)
               }
              
           }
        }
        return Array(predictedClasses)
    }
}
