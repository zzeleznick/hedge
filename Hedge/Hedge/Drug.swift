//
//  Drug.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/25/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit


class StrList:  CustomStringConvertible {
    var members: [String]!
    init(members: [String]) {
        self.members = members
    }
    var description: String {
        return self.members.joined(separator: ", ")
    }
    
}

class Rx: CustomStringConvertible {
    var name: String = "Lipitor"
    var fillDate: String = "Unknown"
    var daysSupply: String = "0"
    
    init(name: String?, fillDate: String?, daysSupply: String? ) {
        if let myname = name {
            self.name = myname
        }
        if let fillDate = fillDate {
            self.fillDate = fillDate
        }
        if let daysSupply = daysSupply {
            self.daysSupply = daysSupply
        }
    }
    var description: String {
        return "RX:(name: \(name), fillDate: \(fillDate)) "
    }
}


class Drug: CustomStringConvertible {
    var name: String!
    var sideEffects: StrList!
    var relatedDrugs: StrList!
    
    init(name:String,
         sideEffects: [String], relatedDrugs: [String]) {
        self.name = name
        self.sideEffects = StrList(members: sideEffects)
        self.relatedDrugs = StrList(members: relatedDrugs)
    }
    lazy var dict: [String:String] = {
        [unowned self] in
        let out = ["Name": self.name!,
            "Side Effects": "\(self.sideEffects!)",
            "Related Drugs": "\(self.relatedDrugs!)",
        ]
        return out }()
    
    var description: String {
        let out =  "Drug{(\(self.name)}"
        return out
    }
}
