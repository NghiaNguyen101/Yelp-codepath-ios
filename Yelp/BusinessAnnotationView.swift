//
//  BussinessAnnotationView.swift
//  Yelp
//
//  Created by Nghia Nguyen on 7/15/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BussinessAnnotationView: MKAnnotationView {
    
    weak var businessMapView: BusinessMapView?

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.image = #imageLiteral(resourceName: "dropPin")

    }
    
    override var annotation: MKAnnotation? {
        willSet { businessMapView?.removeFromSuperview() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // This is important: Don't show default callout
        self.image = #imageLiteral(resourceName: "dropPin")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        print("I am in selected")
        if selected {
            self.businessMapView?.removeFromSuperview()
            if let newCustomCalloutView = loadBusinessMapView() {
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.businessMapView = newCustomCalloutView
                
                // animate presentation
                if animated {
                    self.businessMapView!.alpha = 0.0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.businessMapView!.alpha = 0.85
                    })
                }
            }
        }
        else {
            if businessMapView != nil {
                if animated {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.businessMapView!.alpha = 0.0
                    }, completion: { (success) in
                        self.businessMapView!.removeFromSuperview()
                    })
                } else { self.businessMapView!.removeFromSuperview() } // just remove it.
            }
        }
    }
    
    
    func loadBusinessMapView() -> BusinessMapView? {
        if let views = Bundle.main.loadNibNamed("BusinessMapView", owner: self, options: nil) as? [BusinessMapView], views.count > 0 {
            let businessMapView = views.first!
            if let businessAnnotation = annotation as? BusinessAnnotation {
                businessMapView.business = businessAnnotation.business
            }
            return businessMapView
        }
    
        print("wtf")
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.businessMapView?.removeFromSuperview()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
