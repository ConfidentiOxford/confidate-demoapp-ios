//
//  ModelPredictions.swift
//  Yolo_implementation
//
//  Created by Галим Усаев on 10.03.2024.
//

import Foundation
import CoreML
import Vision

struct ModelPredictions {
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
        var results = [String]()
        let confidenceThreshold: Double = 0.4
        let numberOfBoxes = output.confidence.count / classLabels.count
        
        for boxIndex in 0..<numberOfBoxes {
            let classIndex = boxIndex * classLabels.count
            let classConfidences = (0..<classLabels.count).map { output.confidence[classIndex + $0].doubleValue }
            if let maxConfidence = classConfidences.max(), maxConfidence > confidenceThreshold {
                let maxIndex = classConfidences.firstIndex(of: maxConfidence)!
                let className = classLabels[maxIndex]
                
                let coordinatesIndex = boxIndex * 4
                let x = output.coordinates[coordinatesIndex].doubleValue
                let y = output.coordinates[coordinatesIndex + 1].doubleValue
                let width = output.coordinates[coordinatesIndex + 2].doubleValue
                let height = output.coordinates[coordinatesIndex + 3].doubleValue
                
                let resultString = "Класс: \(className), Вероятность: \(maxConfidence), [x: \(x), y: \(y), width: \(width), height: \(height)]"
                results.append(resultString)
            }
        }
        return results
    }
    
    
    // Замените это функцией, которая возвращает имя класса по индексу из вашего набора данных.
    static func className(forIndex index: Int) -> String {
        // Это место для вашей логики определения класса по индексу
        // Возможно, у вас есть специальный словарь или массив, который содержит соответствие между индексами и названиями классов.
        return "Некий класс" // Заглушка
    }
}
