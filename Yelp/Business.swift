//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Modified by Nghia Nguyen on 07/14/17
//  Copyright (c) 2017 Timothy Lee, Nghia Nguyen. All rights reserved.
//

import UIKit
import MapKit

class Business: NSObject {
    let name: String?
    let address: String?
    let fullAddress: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let reviewCount: NSNumber?
    let ll: [String: Double]?
    let isClose: Bool? // permanent close or not, can't get wroking hours
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        var ll : [String:Double] = [:]
        var fullAddress = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let coordinate = location!["coordinate"] as? NSDictionary
            if coordinate != nil {
                ll["latitude"] = (coordinate!["latitude"] as! Double)
                ll["longitude"] = (coordinate!["longitude"] as! Double)
            }
            
            let displayAddress = location!["display_address"] as? NSArray
            if displayAddress != nil {
                fullAddress = (displayAddress?.componentsJoined(by: ", "))!
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        self.address = address
        self.ll = ll
        self.fullAddress = fullAddress
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        if let isClose = dictionary["is_closed"] as? Bool {
            self.isClose = isClose
        } else {
            print("I was never inside")
            self.isClose = true
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    func toString() -> String {
        return "name: \(name!)\naddress: \(address!)\nfullAddress: \(fullAddress!)\nll: \(ll!)\nisClose: \(isClose!)"
    }
    
    func getLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(ll!["latitude"]!, ll!["longitude"]!)
    }
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, offset: Int?, limit: Int?, completion: @escaping ([Business]?, Error?) -> Void) -> Void {
        _ = YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, offset: offset, limit: limit, completion: completion)
    }
}
