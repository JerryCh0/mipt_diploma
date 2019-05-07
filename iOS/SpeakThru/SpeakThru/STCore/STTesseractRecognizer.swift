//
//  STTesseractRecognizer.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 06/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Vision
import TesseractOCR
import AVFoundation
import UIKit

final class STTesseractRecognizer: Recognizer {
    
    func recognize(from image: UIImage) {
        vision.makeRequest(image: image)
    }
    
    private lazy var vision: STVision = {
        let vis = STVision()
        vis.delegate = self
        return vis
    }()
    private lazy var box: BoxService = {
        let bx = BoxService()
        bx.delegate = self
        return bx
    }()
    private lazy var tesseract = G8Tesseract(language: "eng")!
    
    weak var coreRecognizer: STRecognizer?
}

extension STTesseractRecognizer: STVisionDelegate {
    func service(_ version: STVision, didDetect image: UIImage, results: [VNTextObservation]) {
        box.handle(image: image, results: results)
    }
}

extension STTesseractRecognizer: BoxServiceDelegate {
    func boxService(_ service: BoxService, didDetect images: [UIImage], on image: UIImage) {
        parse(photo: image, images: images)
    }
    
    private func parse(photo: UIImage, images: [UIImage]) {
        let tesseract = G8Tesseract(language: "eng")!
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .singleLine
        
        var result = ""
        
        for image in images {
            tesseract.image = image.g8_blackAndWhite()
            if tesseract.recognize() {
                result += " " + tesseract.recognizedText
            }
        }
        
        coreRecognizer?.onRecognized(from: photo, text: result, lang: "en")
    }
}

protocol BoxServiceDelegate: class {
    func boxService(_ service: BoxService, didDetect images: [UIImage], on image: UIImage)
}

final class BoxService {
    
    weak var delegate: BoxServiceDelegate?
    
    func handle(image: UIImage, results: [VNTextObservation]) {
        
        var images: [UIImage] = []
        let results = results.filter({ $0.confidence > 0.9 })
        
        results.forEach { result in
            do {
                var transform = CGAffineTransform.identity
                transform = transform.scaledBy(x: image.size.width, y: -image.size.height)
                transform = transform.translatedBy(x: 0, y: -1)
                let rect = result.boundingBox.applying(transform)
                
                let scaleUp: CGFloat = 0.2
                let biggerRect = rect.insetBy(
                    dx: -rect.size.width * scaleUp,
                    dy: -rect.size.height * scaleUp
                )
                
                if let croppedImage = crop(image: image, rect: biggerRect) {
                    images.append(croppedImage)
                }
            }
        }
        
        delegate?.boxService(self, didDetect: images, on: image)
    }
    
    private func crop(image: UIImage, rect: CGRect) -> UIImage? {
        guard let cropped = image.cgImage?.cropping(to: rect) else {
            return nil
        }
        
        return UIImage(cgImage: cropped, scale: image.scale, orientation: image.imageOrientation)
    }
}


protocol STVisionDelegate: class {
    func service(_ version: STVision, didDetect image: UIImage, results: [VNTextObservation])
}

final class STVision {
    
    weak var delegate: STVisionDelegate?
    
    func makeRequest(image: UIImage) {
        guard let cgImage = image.cgImage else {
            assertionFailure()
            return
        }
        
        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: inferOrientation(image: image),
            options: [VNImageOption: Any]()
        )
        
        let request = VNDetectTextRectanglesRequest(completionHandler: { [weak self] request, error in
            DispatchQueue.main.async {
                self?.handle(image: image, request: request, error: error)
            }
        })
        
        request.reportCharacterBoxes = true
        
        do {
            try handler.perform([request])
        } catch {
            print(error as Any)
        }
    }
    
    private func handle(image: UIImage, request: VNRequest, error: Error?) {
        guard
            let results = request.results as? [VNTextObservation]
            else {
                return
        }
        
        delegate?.service(self, didDetect: image, results: results)
    }
    
    private func inferOrientation(image: UIImage) -> CGImagePropertyOrientation {
        switch image.imageOrientation {
        case .up:
            return CGImagePropertyOrientation.up
        case .upMirrored:
            return CGImagePropertyOrientation.upMirrored
        case .down:
            return CGImagePropertyOrientation.down
        case .downMirrored:
            return CGImagePropertyOrientation.downMirrored
        case .left:
            return CGImagePropertyOrientation.left
        case .leftMirrored:
            return CGImagePropertyOrientation.leftMirrored
        case .right:
            return CGImagePropertyOrientation.right
        case .rightMirrored:
            return CGImagePropertyOrientation.rightMirrored
        }
    }
}
