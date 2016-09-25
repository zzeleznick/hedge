//
//  ScanViewController.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/24/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    
    var activityIndicator:UIActivityIndicatorView!
    
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Scan Rx"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    func scanPressed(_ sender: AnyObject) {
        print("Scan Pressed")
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo", message: nil, preferredStyle: .actionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo", style: .default) {
                (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // 4
        let libraryButton = UIAlertAction(title: "Choose Existing", style: .default) { (alert) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        // 5
        let cancelButton = UIAlertAction(title: "Cancel",  style: .cancel) {
            (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        // 6
        present(imagePickerActionSheet, animated: true, completion: nil)
    }
    
    func makeButtons() {
        // MARK: Adds buttons
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 350)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        let currentText = "Scan to begin"
        displayContainer.addUIElement(resultLabel, text: currentText, frame: CGRect(x: 70, y: 70, width: w-70, height: 280)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 30)
            label.textAlignment = NSTextAlignment.center
        }
        
        let textContainer = UIView()
        view.addUIElement(textContainer, frame: CGRect(x: 0, y: 350, width: w, height: h-350)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.white
        }
        
        textContainer.addUIElement(UIButton(), text: "Scan", frame: CGRect(x: w * 0.25, y: 50, width: w * 0.5, height: 60))  { element in
            guard let button = element as? UIButton else { return }
            button.backgroundColor = UIColor.orange
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(scanPressed), for: .touchUpInside)
        }
    }
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor:CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x:0, y:0, width: scaledSize.width, height:scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    // Activity Indicator methods
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    func performImageRecognition(image: UIImage) {
        // 1
        let tesseract = G8Tesseract()
        // 2
        tesseract.language = "eng"
        // 3
        tesseract.engineMode = .tesseractCubeCombined
        // 4
        tesseract.pageSegmentationMode = .auto
        // 5
        tesseract.maximumRecognitionTime = 80.0
        // 6
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        // 7
        resultLabel.text = tesseract.recognizedText
        // textView.isEditable = true
        // 8
        removeActivityIndicator()
    }
}


extension ScanViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let scaledImage = scaleImage(image: selectedPhoto, maxDimension: 640)
            addActivityIndicator()
            dismiss(animated: true, completion: { self.performImageRecognition(image: scaledImage!)
            })
        }
    }

}
