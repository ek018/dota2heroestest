//
//  HeroTypeDetail.swift
//  dota2heroes
//
//  Created by Eko Prasetiyo on 26/10/22.
//

import UIKit

class HeroTypeDetail: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    private func _commonInit() {
        _ = fromNib(nibName: "HeroTypeDetail")
    }
    
}
