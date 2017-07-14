//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterViewControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet var searchBarButtonDisplay: UIBarButtonItem!
    @IBOutlet var filterButton: UIBarButtonItem!
    @IBOutlet var cancelSearchButton: UIBarButtonItem!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet weak var extendedNavBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraintToView: NSLayoutConstraint!
    
    var businesses: [Business]!
    let searchBar = UISearchBar()
    var searchText = "Thai"
    var categories : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupTableView()
        setupNavBar()
        setupSearchBar()
       
        searchItems(q: "Thai", categories: nil)
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView(frame: .zero)
        topConstraintToView.constant = 0
    }
    
    func setupNavBar() {
        searchButton.tintColor = .white
        filterButton.tintColor = .white
        cancelSearchButton.tintColor = .white
        searchBarButtonDisplay.tintColor = .white
        
        navigationItem.rightBarButtonItems = [searchBarButtonDisplay]
        
        navigationController!.navigationBar.isTranslucent = false
        navigationController!.navigationBar.shadowImage = #imageLiteral(resourceName: "TransparentPixel")
        // "Pixel" is a solid white 1x1 image.
        navigationController!.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "red"), for: .default)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        navigationController!.navigationBar.titleTextAttributes = (titleDict as! [String : Any])
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.setBackgroundImage(#imageLiteral(resourceName: "red"), for: .any, barMetrics: .default)
        
        extendedNavBarView.addSubview(searchBar)
        searchBar.sizeToFit()
        extendedNavBarView.isHidden = true
    }
    
    // MARK: - Tableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses != nil ? businesses.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessCell.identifier, for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filterViewController = navigationController.topViewController as! FilterViewController
        
        filterViewController.categoriesCode = self.categories
        filterViewController.delegate = self
    }
    
    func filterViewController(filterViewController: FilterViewController, didUpdateFilter filters: [String : AnyObject]) {
        
        categories = filters["categories"] as? [String]
        searchItems(q: searchText, categories: categories)
    }
    
    func searchItems(q: String, categories: [String]?) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Loading..."
        
        Business.searchWithTerm(term: q, sort: nil, categories: categories, deals: nil) {
            (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // MARK: - Searchbar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
           searchButton.isEnabled =  searchText != ""
        } else {
            searchButton.isEnabled = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchButton.isEnabled = searchText != ""
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let q = searchBar.text, q != "" {
            searchText = q
            searchItems(q: searchText, categories: categories)
        }
        hideSearchBar()
    }
    
    
    @IBAction func cancelSearchButtonTap(_ sender: Any) {
        hideSearchBar()
    }
    
    @IBAction func searchBarButtonDisplayTap(_ sender: Any) {
        showSearchBar()
    }
    
    @IBAction func searchButtonTap(_ sender: Any) {
        if let q = searchBar.text, q != "" {
            searchText = q
            searchItems(q: searchText, categories: categories)
        }
        hideSearchBar()
    }
    
    func showSearchBar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.extendedNavBarView.isHidden = false
            self.topConstraintToView.constant = 52
            self.navigationItem.leftBarButtonItems = [self.cancelSearchButton]
            self.navigationItem.rightBarButtonItems = [self.searchButton]
        })
        
        searchBar.becomeFirstResponder()
    }
    
    func hideSearchBar() {
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.topConstraintToView.constant = 0
            self.navigationItem.titleView = nil
            self.navigationItem.leftBarButtonItems = [self.filterButton]
            self.navigationItem.rightBarButtonItems = [self.searchBarButtonDisplay]
            self.extendedNavBarView.isHidden = true
            self.navigationItem.title = self.searchText == "" ? "Yelp" : self.searchText
        })
    }
}
