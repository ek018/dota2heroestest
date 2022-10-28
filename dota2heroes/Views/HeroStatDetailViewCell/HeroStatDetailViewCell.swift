//
//  HeroStatDetailViewCell.swift
//  dota2heroes
//
//  Created by Eko Prasetiyo on 22/10/22.
//

import UIKit

class HeroStatDetailViewCell: UITableViewCell {

    @IBOutlet weak var heroBaseStatImage: UIImageView!
    @IBOutlet weak var heroBaseTitleLabel: UILabel!
    @IBOutlet weak var heroBaseDataSubtitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
