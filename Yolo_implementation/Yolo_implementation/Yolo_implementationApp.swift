//
//  Yolo_implementationApp.swift
//  Yolo_implementation
//
//  Created by Галим Усаев on 09.03.2024.
//

import SwiftUI

@main
struct Yolo_implementationApp: App {
    init() {
        // Проверяем путь к модели при инициализации приложения для отладки
        if let modelURL = Bundle.main.url(forResource: "YOLOv3", withExtension: "mlmodelc") {
            print("Модель найдена по пути: \(modelURL.path)")
        } else {
            print("Не удалось найти модель в пакете приложения.")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
