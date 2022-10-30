//
//  HeroCustomCollectionCell.swift
//  dota2heroes
//
//  Created by Eko Prasetiyo on 27/10/22.
//

import UIKit
import Kingfisher


class HeroCustomCollectionCell: UICollectionViewCell {
    
    static let identifier = "HeroCustomCollectionCell"
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let heroNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Custom"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(heroImageView)
        contentView.addSubview(heroNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heroNameLabel.frame = CGRect(x: 5,
                                     y: contentView.frame.height-20,
                                     width: contentView.frame.width-10,
                                     height: 20)
        
        heroImageView.frame = CGRect(x: 5,
                                     y: 0,
                                     width: contentView.frame.width-10,
                                     height: contentView.frame.height-20)

    }
    
    public func configure(label: String, image: String) {
        let urlImage = "\(ApiServices.baseURL)\(image)"
        heroNameLabel.text = label
        heroImageView.kf.setImage(with: URL(string: urlImage))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        heroNameLabel.text = nil
    }
}
