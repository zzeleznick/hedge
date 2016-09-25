//
//  ScanViewController.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/24/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ScanViewController: ViewController, UINavigationControllerDelegate {
    
    var activityIndicator:UIActivityIndicatorView!
    
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    // var resultView = UITextView()
    var scanButton = UIButton()
    
    var textData: [String] = [""] {
        willSet(newValue) {
            scanButton.setTitle("Re-Scan", for: UIControlState())
        }
    }
    
    var meds: [Rx] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Scan Rx"
        // resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(proceed))
        navigationItem.setRightBarButton(addButton, animated: true)
        let skipButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(skip))
        navigationItem.setLeftBarButton((skipButton), animated: true)
    }
    
    func parseMeds(_ medList: [String: Any]) {
        for (key, value) in medList {
            if let med = value as? [String: String] {
                let name = med["name"]
                let dateOfFill = med["dateOfFill"]
                let daysSupply = med["daysSupply"]
                let rx = Rx(name: name, fillDate: dateOfFill, daysSupply: daysSupply)
                if self.meds.count < 4 {
                    self.meds.append(rx)
                }
            }
        }
        print(self.meds)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Helper.get { result in
            print("Parsed JSON!")
            print(result)
            self.parseMeds(result)
        }
        super.viewDidAppear(animated)
    }
    func skip() {
        let dest = HomeViewController()
        dest.meds = self.meds
        navigationController?.pushViewController(dest, animated: true)
    }
    
    func proceed() {
        let dest = EditViewController()
        dest.textData = textData
        dest.meds = self.meds
        navigationController?.pushViewController(dest, animated: true)
    }

    func scanPressed(_ sender: AnyObject) {
        print("Scan Pressed")
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo", message: nil, preferredStyle: .actionSheet)
        
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
        
        let libraryButton = UIAlertAction(title: "Choose Existing", style: .default) { (alert) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
 
        let cancelButton = UIAlertAction(title: "Cancel",  style: .cancel) {
            (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)

        present(imagePickerActionSheet, animated: true, completion: nil)
    }
    
    func makeButtons() {
        // MARK: Adds buttons
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 560)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        let currentText = "Scan to begin"
        displayContainer.addUIElement(resultLabel, text: currentText, frame: CGRect(x: 10, y: 50, width: w-20, height: 500)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 20)
            label.textAlignment = NSTextAlignment.center
        }
        
        let textContainer = UIView()
        view.addUIElement(textContainer, frame: CGRect(x: 0, y: 560, width: w, height: h-560)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.white
        }
        
        textContainer.addUIElement(scanButton, text: "Scan", frame: CGRect(x: w * 0.25, y: 30, width: w * 0.5, height: 50))  { element in
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
        let tesseract = G8Tesseract()
        tesseract.language = "eng"
        tesseract.engineMode = .cubeOnly //.tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 80.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        let trimmed = tesseract.recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
        // let spaced = trimmed.replacingOccurrences(of: ",", with: ",\n")
        resultLabel.text = trimmed
        resultLabel.textAlignment = .natural
        removeActivityIndicator()
        textData = trimmed.trimmedLines
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
