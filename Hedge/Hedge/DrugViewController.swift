//
//  DrugViewController.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/24/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//


import UIKit

class DrugViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    var container = UIView()
    var bodyContainer = UIView()
    var myTable = UITableView()
    
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    
    var titleText = "Drug Name"
    var subtitleText = "Humana Member"
    
    let Bob = Drug(name:"Lipitor", sideEffects: ["Tiredness, Confusion, Diarrhea"], relatedDrugs: ["Generic Atorvastatin"])
    
    var bobKeys: [String]!
    
    typealias CellType = KVCell
    fileprivate struct Main {
        static let CellIdentifier = "cell"
        static let CellClass = CellType.self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = titleText
        placeElements()
        myTable.rowHeight = 60.0
        myTable.register(Main.CellClass, forCellReuseIdentifier: Main.CellIdentifier)
        myTable.delegate = self
        myTable.dataSource = self
        bobKeys = [String](Bob.dict.keys)
    }
    
    func placeElements() {
        view.addUIElement(container, frame: CGRect(x:0, y:50, width:w, height: 180)) { element in
            guard element is UIView else { return }
        }
        let image = UIImage(named: "pill-icon.png")
        let imageFrame = UIImageView(image: image)
        imageFrame.contentMode = .scaleAspectFill
        container.addUIElement(imageFrame, frame: CGRect(x:w/6.0, y:20, width:w * (1.0-2.0/6.0), height: 180-20))
        
        let tableFrame = CGRect(x: 0, y: 230, width: w, height: h-230)
        view.addUIElement(myTable, frame: tableFrame)
        
        view.addUIElement(bodyContainer, frame: CGRect(x:0, y:230, width:w, height: h-230)) { element in
            guard element is UIView else { return }
        }
        /*
        bodyContainer.addUIElement(titleLabel, text: titleText, frame: CGRect(x:25, y:20, width:w-50, height: 50)) { element in
            guard let label = element as? UILabel else { return }
            label.font = UIFont(name: label.font.fontName, size: 22)
        }
        bodyContainer.addUIElement(subtitleLabel, text: subtitleText, frame: CGRect(x:25, y:100, width:w-50, height: 50)) { element in
            guard let label = element as? UILabel else { return }
            label.font = UIFont(name: label.font.fontName, size: 18)
        }*/
        
    }
    override func viewDidAppear(_ animated: Bool) {
        myTable.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Bob.dict.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idx = indexPath.row
        let cell = myTable.dequeueReusableCell(withIdentifier: Main.CellIdentifier, for: indexPath) as! CellType
        
        let key = bobKeys[idx]
        cell.keyLabel.text = key.capitalized
        if let value = Bob.dict[key] {
            cell.valueLabel.text = "\(value)"
        }
        cell.setBounds()
        cell.selectionStyle = .none
        return cell
    }
}
