//
//  ContentView.swift
//  Yolo_implementation
//
//  Created by Галим Усаев on 09.03.2024.
//

import SwiftUI
import CoreML
import Vision

struct ContentView: View {
    @State private var uiImage: UIImage? = nil // Для работы с UIImage
    @State private var image: Image? = nil // Для отображения выбранного изображения
    @State private var isImagePickerDisplay = false
    @State private var predictions: [String] = [] // Список предсказаний для отображения в UI
    @State private var model: YOLOv3? // Держите модель как состояние вашего View

    var body: some View {
        VStack {
            image?.resizable().scaledToFit() // Отображение выбранного изображения
            
            Button("Выбрать изображение") {
                self.isImagePickerDisplay = true
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            
            // Отображение предсказаний
            ForEach(predictions, id: \.self) { prediction in
                Text(prediction)
            }
        }
        .padding()
        .sheet(isPresented: $isImagePickerDisplay) {
            PhotoPicker(uiImage: $uiImage, image: $image, predictions: $predictions, isPresented: $isImagePickerDisplay, model: $model)
        }
        .onAppear {
            print("ContentView появился.")
            loadModel()
        }
    }
    
    // Функция для загрузки модели
    func loadModel() {
        guard let modelURL = Bundle.main.url(forResource: "YOLOv3", withExtension: "mlmodelc") else {
            fatalError("Failed to load model from bundle.")
        }
        
        do {
            let configuration = MLModelConfiguration()
            model = try YOLOv3(contentsOf: modelURL, configuration: configuration)
            print("Модель успешно загружена.")
        } catch {
            print("Error loading model: \(error)")
        }
    }
}

// PhotoPicker для выбора изображения
struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var uiImage: UIImage?
    @Binding var image: Image?
    @Binding var predictions: [String]
    @Binding var isPresented: Bool
    @Binding var model: YOLOv3?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Нет необходимости обновлять UIImagePickerController
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self, model: $model)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let photoPicker: PhotoPicker
        var model: Binding<YOLOv3?>
        init(photoPicker: PhotoPicker, model: Binding<YOLOv3?>) {
            self.photoPicker = photoPicker
            self.model = model
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                photoPicker.uiImage = uiImage
                photoPicker.image = Image(uiImage: uiImage)
                processAndPredictImage(uiImage)
            }
            photoPicker.isPresented = false
        }
        
        
        func processAndPredictImage(_ uiImage: UIImage) {
                let resizedImage = uiImage.resized(to: CGSize(width: 416, height: 416))
                guard let pixelBuffer = resizedImage.toCVPixelBuffer() else {
                    DispatchQueue.main.async {
                        print("Ошибка: не удалось преобразовать изображение.")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        let output = try self.performPrediction(with: pixelBuffer)
                        let predictions = ModelPredictions.parsePredictions(output)
                        print(predictions)
                        self.photoPicker.predictions = ModelPredictions.parsePredictions(output)
                    } catch {
                        print("Ошибка предсказания: \(error)")
                    }
                }
            }
        
        func performPrediction(with pixelBuffer: CVPixelBuffer) throws -> YOLOv3Output {
                guard let model = self.photoPicker.model else {
                    fatalError("Модель не загружена.")
                }
                let input = YOLOv3Input(image: pixelBuffer)
                return try model.prediction(input: input)
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






























//
//import SwiftUI
//
//struct ContentView: View {
//    @State private var image: Image? = nil // Для отображения выбранного изображения
//    @State private var isImagePickerDisplay = false
//
//    var body: some View {
//        VStack {
//            image?.resizable().scaledToFit() // Отображение выбранного изображения
//
//            Button("Выбрать изображение") {
//                self.isImagePickerDisplay = true
//            }
//            .padding()
//            .foregroundColor(.white)
//            .background(Color.blue)
//            .cornerRadius(10)
//
//            // Здесь может быть дополнительный UI для отображения результатов распознавания
//        }
//        .padding()
//        .sheet(isPresented: $isImagePickerDisplay) {
//            PhotoPicker(image: self.$image, isPresented: self.$isImagePickerDisplay)
//        }
//    }
//}
//
//// PhotoPicker для выбора изображения
//struct PhotoPicker: UIViewControllerRepresentable {
//
//    @Binding var image: Image?
//    @Binding var isPresented: Bool
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(photoPicker: self)
//    }
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let photoPicker: PhotoPicker
//
//        init(photoPicker: PhotoPicker) {
//            self.photoPicker = photoPicker
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                photoPicker.image = Image(uiImage: uiImage)
//                // Здесь можно добавить код для преобразования UIImage в CVPixelBuffer и последующего прогнозирования с использованием YOLOv3
//            }
//            photoPicker.isPresented = false
//        }
//    }
//}


