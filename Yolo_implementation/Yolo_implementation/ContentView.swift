/
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
    
    var body: some View {
        VStack {
            image?.resizable().scaledToFit() // Отображение выбранного изображения
            
            Button("Take image") {
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
            // Теперь мы не передаем model в PhotoPicker
            PhotoPicker(uiImage: $uiImage, image: $image, predictions: $predictions, isPresented: $isImagePickerDisplay)
        }
    }
    
    // PhotoPicker для выбора изображения
    struct PhotoPicker: UIViewControllerRepresentable {
        
        @Binding var uiImage: UIImage?
        @Binding var image: Image?
        @Binding var predictions: [String]
        @Binding var isPresented: Bool
        
        func makeUIViewController(context: Context) -> some UIViewController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            // Нет необходимости обновлять UIImagePickerController
        }
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(photoPicker: self)
        }
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            let photoPicker: PhotoPicker
            init(photoPicker: PhotoPicker) {
                self.photoPicker = photoPicker
            }
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    photoPicker.uiImage = uiImage
                    photoPicker.image = Image(uiImage: uiImage)
                    
                    
                    if ModelPredictions.processImage(uiImage) != nil {
                        self.photoPicker.predictions = ModelPredictions.performImageClassification(image: uiImage) 
                    } else {
                        print("Ошибка: не удалось преобразовать изображение в CVPixelBuffer.")
                    }
                }
                photoPicker.isPresented = false
            }
        }
    }
}
