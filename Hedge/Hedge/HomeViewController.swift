//
//  HomeViewController.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/24/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class HomeViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    var container = UIView()
    var bodyContainer = UIView()
    var heading = UILabel()
    var subheading = UILabel()
    
    var myTable = UITableView()
    
    var meds: [Rx] = []
    
    typealias CellType = DrugCell
    fileprivate struct Main {
        static let CellIdentifier = "cell"
        static let CellClass = CellType.self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        placeElements()
        myTable.rowHeight = 60.0
        myTable.register(Main.CellClass, forCellReuseIdentifier: Main.CellIdentifier)
        myTable.delegate = self
        myTable.dataSource = self
    }
    
    func placeElements() {
        view.addUIElement(container, frame: CGRect(x:0, y:50, width:w, height: 180)) { element in
            guard element is UIView else { return }
        }
        // let image = UIImage(named: "serene-sm.jpg")
        let image = UIImage(named: "canyon.jpg")
        let imageFrame = UIImageView(image: image)
        // imageFrame.blur()
        container.addUIElement(imageFrame, frame: CGRect(x:0, y:0, width:w, height: 180))
        
        let tableFrame = CGRect(x: 0, y: 230, width: w, height: h-230)
        view.addUIElement(myTable, frame: tableFrame)
        
        container.addUIElement(heading, text: "Good Morning!", frame: CGRect(x:25, y:80, width:w-50, height: 50)) { element in
            guard let label = element as? UILabel else { return }
            label.font = UIFont(name: label.font.fontName, size: 26)
            label.textColor = UIColor.white
            label.textAlignment = .center
        }
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        let convertedDate = dateFormatter.string(from: currentDate)
        container.addUIElement(subheading, text: convertedDate, frame: CGRect(x:25, y:120, width:w-50, height: 50)) { element in
            guard let label = element as? UILabel else { return }
            label.font = UIFont(name: Theme.lightFont, size: 14)
            label.textColor = UIColor.white
            label.textAlignment = .center
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = DrugViewController()
        let idx = indexPath.row
        let drugname = meds[idx].name
        dest.titleText = drugname //"Drug \(idx)"
        dest.Bob = Drug(name: drugname, sideEffects: ["Tiredness, Confusion, Diarrhea"], relatedDrugs: ["Generic Atorvastatin"])
        navigationController?.pushViewController(dest, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meds.count // 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idx = indexPath.row
        let cell = myTable.dequeueReusableCell(withIdentifier: Main.CellIdentifier, for: indexPath) as! CellType
        
        let name = meds[idx].name
        let loc = "Fill Date: \(meds[idx].fillDate)"
        // let name = "Drug \(idx)"
        // let loc = "subtitle"
        let right = "DS: \(meds[idx].daysSupply)"
        
        cell.titleLabel.text = name
        cell.subtitleLabel.text = loc
        cell.rightLabel.text = right
        cell.setBounds()
        cell.selectionStyle = .none
        return cell
    }
    
}
