//
//  DrugCell.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/25/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class DrugCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let rightLabel = UILabel()
    let myImage = UIImage(named: "pill-icon-sm.png")
    let myImageView = UIImageView()
    var myButton: UIButton!
    
    func setBounds() {
        let w = frame.size.width
        let h = frame.size.height
        titleLabel.frame = CGRect(x: 60, y: 10, width: 200, height: 20)
        subtitleLabel.frame = CGRect(x: 60, y: 30, width: 200, height: 20)
        rightLabel.frame = CGRect(x: 260, y: 30, width: w-260, height: 20)
        myImageView.frame = CGRect(x: 18, y: 22, width: 22.5, height: 15)
        myButton.frame =  CGRect(x: w-40, y: h/2-9, width: 18, height: 18)
        
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.textColor = UIColor(white: 0.25, alpha: 1.0)
        titleLabel.font = UIFont(name: Theme.fontBoldName, size: Theme.titleSize)
        subtitleLabel.textColor = UIColor.darkGray
        subtitleLabel.font = UIFont(name: Theme.lightFont, size: Theme.subtitleSize)
        rightLabel.textColor = UIColor.darkGray
        rightLabel.font = UIFont(name: Theme.lightFont, size: Theme.subtitleSize)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(rightLabel)
        
        myImageView.image = myImage
        contentView.addSubview(myImageView)
        
        myButton = UIButton(type: .infoLight)
        contentView.addSubview(myButton)
        
        self.setBounds()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
