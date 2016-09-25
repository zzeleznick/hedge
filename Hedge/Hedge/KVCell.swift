//
//  KVCell.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/25/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

//
//  KVCell.swift
//  DLight
//
//  Created by Zach Zeleznick on 4/23/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class KVCell: UITableViewCell {
    
    let keyLabel = UILabel()
    let valueLabel = UILabel()
    
    func setBounds() {
        let w = frame.size.width
        let h = frame.size.height
        keyLabel.frame = CGRect(x: 10, y: 10, width: w, height: 5*h/12)
        valueLabel.frame = CGRect(x: 30, y: 10+5*h/12, width: w, height: 5*h/12)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        keyLabel.textColor = UIColor.black
        keyLabel.font = UIFont(name: Theme.fontBoldName, size: Theme.titleSize)
        
        valueLabel.textColor = UIColor(white: 0.25, alpha: 1.0)
        valueLabel.font = UIFont(name: Theme.fontName, size: Theme.titleSize)
        
        self.contentView.addSubview(keyLabel)
        contentView.addSubview(valueLabel)
        self.setBounds()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
