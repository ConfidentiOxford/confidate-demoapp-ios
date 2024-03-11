//
//  SignUpViewModel.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//
import UIKit
import PhotosUI
import CoreML

final class SetUpViewModel {
    private struct Consts {
        static let confidenceeThreshold = 0.7
    }
    
    private var userInfo: UserInfo?
    
    /// Selected images for AI Fill
    private var selectedImages: [UIImage] = []
    
    weak var view: SetUpViewController?
    
    /// AI Fill Tapped event
    @objc func autoFillTapped() {
        print("[SetUpViewModel] AI Fill tappeed")
        // 1. Create image picker from gallery
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 10
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        // 2. Show image picker on UI
        view?.show(picker)
    }
    
    func nextTapped() {
        guard let info = userInfo else { return }
        let vc = MVVMBuilder.privatarVC(userInfo: info)
        view?.present(vc)
    }
    
    @objc func finishTapped(genderText: String, animalText: String, hobbieText: String) {
        // Save profile inifo
        userInfo = UserInfo(gender: genderText, animal: animalText, hobbie: hobbieText)
        // TODO: - Verify models prediction
        //
        var approved: Bool = true
        if approved {
            view?.approveFields()
        } else {
            view?.unapproveFields()
        }
        view?.showNext()
    }
    
    private func imagesPicked() {
        print("[SetUpViewModel] Images picked (\(selectedImages.count) files)")
        let model = model_cat_dog_rgb()
        let det = EntityDetector()
        let hobbie = try? det.detect(images: selectedImages)
        if let hobbie = hobbie {
            DispatchQueue.main.async {
                self.view?.setHobbieTextField(text: hobbie)
            }
        }
        for image in selectedImages {
            guard let resizedImage = image.resizeImage(targetSize: CGSize(width: 28, height: 28)),
                  let pixelBuffer = resizedImage.pixelBuffer else { continue }
            let input = model_cat_dog_rgbInput(input_2: pixelBuffer)
            let prediction = try? model.prediction(input: input).Identity
            DispatchQueue.main.async {
                if prediction?["cat"] ?? 0 > 0.7 {
                    self.autofill(with: "dog")
                }
                self.view?.stopAnimating()
            }
        }
    }
    
    private func autofill(with text: String) {
        view?.setAnimalTextField(text: text)
    }
}

// MARK: - Handle user did finish picking images
extension SetUpViewModel: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        view?.startAnimating()
        picker.dismiss(animated: true, completion: nil)
        results.forEach {
            if $0.itemProvider.canLoadObject(ofClass: UIImage.self) {
                // Async API
                $0.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self else { return }
                    guard let image = image as? UIImage else { return }
                    // append images to array
                    self.selectedImages.append(image)
                    if self.selectedImages.count == results.count {
                        self.imagesPicked()
                    }
                }
            }
        }
    }
}
