//
//  BusinessCell.swift
//  Yelp
//
//  Created by Nghia Nguyen on 7/13/17.
//  Copyright (c) 2017 Timothy Lee, Nghia Nguyen. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    static let identifier = "BusinessCell"
    
    @IBOutlet weak var isCloseLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business: Business! {
        didSet {
            if let url = business.imageURL {
                thumbImageView.setImageWith(url)
            }
            if let url = business.ratingImageURL {
                ratingImageView.setImageWith(url)
            }
            nameLabel.text = business.name
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
            distanceLabel.text = business.distance
            isCloseLabel.text = business.isClose! ? "Close" : "Open"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
