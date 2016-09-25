//
//  EditViewController.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/24/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import Foundation

class EditViewController: ViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    
    var textData: [String] = [""]
    let fields = ["RxId", "Patient", "Dr", "Date",
                  "RxInfo", "ActiveIngredient",
                  "DrugIN", "Refills", "Instructions"]
    
    let placeholder = "0000"
    var container = UIView()
    var containerTop: CGFloat = 100

    var rxLabel = UILabel()
    var rxEntry = UITextField()
    var dinLabel = UILabel()
    var dinEntry = UITextField()
    var confirmButton = UIButton()
   
    var meds: [Rx] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit"
        print(textData)
        let tap = UITapGestureRecognizer(target: self, action: #selector(slideDown))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        placeLabels()
        parseTextData(textData)
    }
    
    func placeLabels() {
        view.addUIElement(container, frame: CGRect(x:0, y:containerTop, width:w, height: h-150)) { element in
            guard element is UIView else { return }
        }
        container.addUIElement(UILabel(), text: "Please confirm the information.", frame: CGRect(x:30, y:0, width:w-60, height: 40)) { element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            label.font = UIFont(name: label.font.fontName, size: 20)
            label.numberOfLines = 2
        }
        container.addUIElement(rxLabel, text: "Rx:", frame: CGRect(x:30, y:100, width:60, height: 50)) { element in
                guard let label = element as? UILabel else { return }
                label.font = UIFont(name: label.font.fontName, size: 20)
        }
        container.addUIElement(dinLabel, text: "DIN:", frame: CGRect(x:30, y:200, width:60, height: 50)) { element in
            guard let label = element as? UILabel else { return }
            label.font = UIFont(name: label.font.fontName, size: 20)
        }
        container.addUIElement(rxEntry, text: "0000", frame: CGRect(x:100, y:100, width:w-140, height: 50)) { element in
            guard let field = element as? UITextField else { return }
            field.textColor = UIColor.lightGray
            self.view.addBorder(field)
            field.delegate = self
        }
        container.addUIElement(dinEntry, text: "0000", frame: CGRect(x:100, y:200, width:w-140, height: 50)) { element in
            guard let field = element as? UITextField else { return }
            field.textColor = UIColor.lightGray
            self.view.addBorder(field)
            field.delegate = self
        }
        container.addUIElement(confirmButton, text: "Confirm", frame: CGRect(x: w * 0.25, y: 400, width: w * 0.5, height: 50))  { element in
            guard let button = element as? UIButton else { return }
            button.backgroundColor = UIColor.orange
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(confirmPressed), for: .touchUpInside)
        }
    }
    func confirmPressed(_ sender: UIButton) {
        let dest = HomeViewController() //DrugViewController()
        dest.meds = self.meds
        navigationController?.pushViewController(dest, animated: true)
    }
    
    func findRX(lines: [String]) -> String {
        for line in lines {
            if line.uppercased().contains("RX:") {
                let str = line.uppercased().replacingOccurrences(of: "RX:", with: "")
                print("RX line: \(str)")
                return str
            }
        }
        return ""
    }
    func findDIN(lines: [String]) -> String {
        for line in lines {
            if line.uppercased().contains("DIN:") {
                let str = line.uppercased().replacingOccurrences(of: "DIN:", with: "")
                print("DIN line: \(str)")
                return str
            }
        }
        return ""
    }
    func parseTextData(_ lines: [String]) {
        let rawRx = findRX(lines: lines)
        rxEntry.text = rawRx.digits
        let rawDIN = findDIN(lines: lines)
        dinEntry.text = rawDIN.digits
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        container.frame =  CGRect(x: 0, y: 80, width: w, height: h-150)
        if let text = rxEntry.text {
            if !text.isEmpty {
                rxEntry.textColor = UIColor.black
            }
        }
        if let text = dinEntry.text {
            if !text.isEmpty {
                dinEntry.textColor = UIColor.black
            }
        }
    }
    func slideDown() {
        print("Ended Editing")
        container.frame =  CGRect(x: 0, y: 100, width: w, height: h-150)
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        slideDown()
        return true
    }

    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        slideDown()
        textField.resignFirstResponder()
    }

}
