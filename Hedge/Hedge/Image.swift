//
//  Image.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/25/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

class CenterScaleToFitImageView: UIImageView {
    override var bounds: CGRect {
        didSet {
            adjustContentMode()
        }
    }
    
    override var image: UIImage? {
        didSet {
            adjustContentMode()
        }
    }
    
    func adjustContentMode() {
        guard let image = image else {
            return
        }
        if image.size.width > bounds.size.width ||
            image.size.height > bounds.size.height {
            contentMode = .scaleAspectFit
        } else {
            contentMode = .scaleAspectFill
        }
    }
}
