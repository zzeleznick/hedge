//
//  DrugViewController.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/24/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//


import UIKit

class DrugViewController: ViewController {
    
    var container = UIView()
    var bodyContainer = UIView()
    var heading = UILabel()
    var subheading = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        placeElements()
    }
    func placeElements() {
        view.addUIElement(container, frame: CGRect(x:0, y:80, width:w, height: 200)) { element in
            guard element is UIView else { return }
        }
        
        view.addUIElement(bodyContainer, frame: CGRect(x:0, y:280, width:w, height: h-220)) { element in
            guard element is UIView else { return }
        }
        container.addUIElement(heading, text: "Robert D. Smith", frame: CGRect(x:25, y:0, width:w-50, height: 50)) { element in
            guard let label = element as? UILabel else { return }
            label.font = UIFont(name: label.font.fontName, size: 22)
        }
        container.addUIElement(subheading, text: "Humana Member", frame: CGRect(x:25, y:80, width:w-50, height: 50)) { element in
            guard let label = element as? UILabel else { return }
            label.font = UIFont(name: label.font.fontName, size: 18)
        }
        bodyContainer.addUIElement(UILabel(), text: "Pills here", frame: CGRect(x:25, y:0, width:w-50, height: 50)) { element in
            guard let label = element as? UILabel else { return }
            label.font = UIFont(name: label.font.fontName, size: 22)
            label.textColor = UIColor.darkGray
        }
        
    }
}
