
















import AppKit

func resizeImage(at url: URL, to targetSize: CGSize, outputURL: URL) {
    guard let image = NSImage(contentsOf: url) else {
        print("Image not found!")
        return
    }
    
    let newSize = targetSize
    let newImage = NSImage(size: newSize)
    
    newImage.lockFocus()
    guard let context = NSGraphicsContext.current?.cgContext else {
        print("Failed to get current graphics context")
        newImage.unlockFocus()
        return
    }
    
    context.interpolationQuality = .high
    image.draw(in: CGRect(origin: .zero, size: newSize), from: CGRect(origin: .zero, size: image.size), operation: .copy, fraction: 1.0)
    newImage.unlockFocus()
    
    guard let tiffData = newImage.tiffRepresentation,
          let bitmapImage = NSBitmapImageRep(data: tiffData),
          let data = bitmapImage.representation(using: .png, properties: [:]) else {
        print("Failed to create image representation")
        return
    }
    
    do {
        try data.write(to: outputURL)
        print("Resized image was saved to \(outputURL.path)")
    } catch {
        print("Failed to write image: \(error)")
    }
}

let inputPath = "/Users/galimusaev/Desktop/OxfordHack/good_quality_photo/vitalik.jpeg"
let outputPath = "/Users/galimusaev/Desktop/OxfordHack/good_quality_photo/vitalik_resized.jpeg"
let inputURL = URL(fileURLWithPath: inputPath)
let outputURL = URL(fileURLWithPath: outputPath)

resizeImage(at: inputURL, to: CGSize(width: 28, height: 28), outputURL: outputURL)


