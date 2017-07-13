//
//  FilterViewController.swift
//  Yelp
//
//  Created by Nghia Nguyen on 7/13/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    @objc optional func filterViewController(filterViewController: FilterViewController, didUpdateFilter filters: [String: AnyObject])
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var categories: [[String:String]]!
    var switchStates =  [Int:Bool]()
    
    weak var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categories = yelpCategories()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        var filters = [String: AnyObject]()
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        
        delegate?.filterViewController?(filterViewController: self, didUpdateFilter: filters)
    }
    
    // MARK: - Tableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        
        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
        
        return cell
    }
    
    // MARK: - SwithCell delegate
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        print("Filter for click event")
        switchStates[indexPath.row] = value
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func yelpCategories() -> [[String:String]] {
        return [["name": "Shoe Stores", "code": "shoes"],
                ["name": "Sports Wear", "code": "sportswear"],
                ["name": "Dance Wear", "code": "dancewear"],
                ["name": "Surf Shop", "code": "surfshop"],
                ["name": "Swimwear", "code": "swimwear"],
                ["name": "Traditional Clothing", "code": "tradclothing"],
                ["name": "Used, Vintage & Consignment", "code": "vintage"],
                ["name": "Women's Clothing", "code": "womenscloth"],
                ["name": "Fireworks", "code": "fireworks"],
                ["name": "Fitness/Exercise Equipment", "code": "fitnessequipment"],
                ["name": "Flea Markets", "code": "fleamarkets"],
                ["name": "Flowers & Gifts", "code": "flowers"],
                ["name": "Cards & Stationery", "code": "stationery"],
                ["name": "Florists", "code": "florists"],
                ["name": "Gift Shops", "code": "giftshops"],
                ["name": "Gold Buyers", "code": "goldbuyers"],
                ["name": "Guns & Ammo", "code": "guns_and_ammo"],
                ["name": "Head Shops", "code": "headshops"],
                ["name": "High Fidelity Audio Equipment", "code": "hifi"],
                ["name": "Hobby Shops", "code": "hobbyshops"],
                ["name": "Home & Garden", "code": "homeandgarden"],
                ["name": "Appliances", "code": "appliances"],
                ["name": "Candle Stores", "code": "candlestores"],
                ["name": "Christmas Trees", "code": "christmastrees"],
                ["name": "Furniture Stores", "code": "furniture"],
                ["name": "Grilling Equipment", "code": "grillingequipment"],
                ["name": "Hardware Stores", "code": "hardware"],
                ["name": "Holiday Decorations", "code": "holidaydecorations"],
                ["name": "Home Decor", "code": "homedecor"],
                ["name": "Hot Tub & Pool", "code": "hottubandpool"],
                ["name": "Kitchen & Bath", "code": "kitchenandbath"],
                ["name": "Mattresses", "code": "mattresses"],
                ["name": "Nurseries & Gardening", "code": "gardening"],
                ["name": "Hydroponics", "code": "hydroponics"],
                ["name": "Outdoor Furniture Stores", "code": "outdoorfurniture"],
                ["name": "Paint Stores", "code": "paintstores"],
                ["name": "Playsets", "code": "playsets"],
                ["name": "Pumpkin Patches", "code": "pumpkinpatches"],
                ["name": "Rugs", "code": "rugs"],
                ["name": "Tableware", "code": "tableware"],
                ["name": "Horse Equipment Shops", "code": "horsequipment"],
                ["name": "Jewelry", "code": "jewelry"],
                ["name": "Knitting Supplies", "code": "knittingsupplies"]]
    }

}
