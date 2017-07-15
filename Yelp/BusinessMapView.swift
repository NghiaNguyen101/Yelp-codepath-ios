//
//  BusinessMapView.swift
//  Yelp
//
//  Created by Nghia Nguyen on 7/15/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

//@objc protocol BusinessMapViewDelegate {
//    func detailsRequestForBusiness(business: Business)
//}

class BusinessMapView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var isCloseLabel: UILabel!
    
//    weak var delegate: BusinessMapViewDelegate?
    var business: Business! {
        didSet {
            nameLabel.text = business.name!
            if let url = business.imageURL {
                ratingImageView.setImageWith(url)
            } else {
                ratingImageView.image = #imageLiteral(resourceName: "Pixel")
            }
            reviewLabel.text = "\(business.reviewCount!) reviews"
            moneyLabel.text = "$$"
            isCloseLabel.text = business.isClose! ? "Close" : "Open"
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
