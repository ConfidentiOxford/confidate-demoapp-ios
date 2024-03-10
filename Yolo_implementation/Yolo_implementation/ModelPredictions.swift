//
//  ModelPredictions.swift
//  Yolo_implementation
//
//  Created by Галим Усаев on 10.03.2024.
//

import Foundation
import CoreML
import Vision
import UIKit

struct ModelPredictions {
    static var model: YOLOv3? = loadModel()
    
    static func loadModel() -> YOLOv3? {
            do {
                let configuration = MLModelConfiguration()
                let modelURL = Bundle.main.url(forResource: "YOLOv3", withExtension: "mlmodelc")!
                return try YOLOv3(contentsOf: modelURL, configuration: configuration)
            } catch {
                print("Ошибка загрузки модели: \(error)")
                return nil
            }
        }
    
    static func performImageClassification(image: UIImage) -> [String] {
            guard let pixelBuffer = processImage(image),
                  let model = loadModel() else {
                print("Ошибка: не удалось подготовить данные для классификации.")
                return []
            }
            return predict(with: pixelBuffer, model: model)
        }
    // Массив с названиями классов вашей модели
    static let classLabels: [String] = [
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
    static func parsePredictions(_ output: YOLOv3Output) -> [String] {
    
        var predictedClasses = Set<String>()
        let confidenceThreshold: Double = 0.4
        let numberOfBoxes = output.confidence.count / classLabels.count
        let excludedClasses: Set<String> = [
                    "traffic light", "fire hydrant",  "person","stop sign", "parking meter", "bench", "bottle",
                    "cup", "fork", "knife", "spoon", "bowl", "banana", "apple", "sandwich", "orange", "broccoli",
                    "carrot", "hot dog", "pizza",  "chair", "sofa", "pottedplant", "bed", "diningtable",
                    "toilet",
                    "toaster", "sink", "refrigerator",  "clock", "vase", "scissors", "hair drier", "toothbrush"
                ]
        for boxIndex in 0..<numberOfBoxes {
            let classIndex = boxIndex * classLabels.count
            let classConfidences = (0..<classLabels.count).map { output.confidence[classIndex + $0].doubleValue }
            if let maxConfidence = classConfidences.max(), maxConfidence > confidenceThreshold {
                let maxIndex = classConfidences.firstIndex(of: maxConfidence)!
                let className = classLabels[maxIndex]
                if !excludedClasses.contains(className) {
                                    predictedClasses.insert(className)
                                }
               
            }
        }
        return Array(predictedClasses)
    }
    
    static func processImage(_ image: UIImage) -> CVPixelBuffer? {
            let size = CGSize(width: 416, height: 416)
            UIGraphicsBeginImageContextWithOptions(size, true, 2.0)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return resizedImage.toCVPixelBuffer()
        }
    
    static func predict(with pixelBuffer: CVPixelBuffer, model: YOLOv3) -> [String] {
            do {
                let input = YOLOv3Input(image: pixelBuffer)
                let output = try model.prediction(input: input)
                return parsePredictions(output)
            } catch {
                print("Ошибка предсказания: \(error)")
                return []
            }
        }
  
}

// Расширение для UIImage, чтобы помочь в преобразовании его в CVPixelBuffer
extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
             kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(self.size.width),
                                         Int(self.size.height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)
        
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData,
                                width: Int(self.size.width),
                                height: Int(self.size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        guard let drawingContext = context else {
            return nil
        }
        
        drawingContext.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}



