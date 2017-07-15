//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Modified by Nghia Nguyen on 07/14/17
//  Copyright (c) 2017 Timothy Lee, Nghia Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, FilterViewControllerDelegate{
    
    @IBOutlet var mapBarButton: UIBarButtonItem!
    @IBOutlet var searchBarButtonDisplay: UIBarButtonItem!
    @IBOutlet var filterButton: UIBarButtonItem!
    @IBOutlet var cancelSearchButton: UIBarButtonItem!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet weak var extendedNavBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraintToView: NSLayoutConstraint!
    
    lazy var mapViewController: MapViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.addViewControllerAsChildViewController(childViewController: vc)
        vc.view.isHidden = true
        return vc
    }()
    
    var businesses: [Business]!
    let searchBar = UISearchBar()
    var currentSearchText = "Thai"
    var categories : [String]?
    let limit = 15
    var offset = 0
    var isLoadMoreData = false
    
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
        mapBarButton.tintColor = .white
        
        navigationItem.leftBarButtonItems = [filterButton]
        navigationItem.rightBarButtonItems = [searchBarButtonDisplay, mapBarButton]
        
        navigationController!.navigationBar.isTranslucent = false
        navigationController!.navigationBar.shadowImage = #imageLiteral(resourceName: "TransparentPixel")
        // "Pixel" is a solid white 1x1 image.
        navigationController!.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "red"), for: .default)
        
    
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        navigationController!.navigationBar.titleTextAttributes = (titleDict as! [String : Any])
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.text = currentSearchText
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
        if segue.identifier != "filterSegue" {
            let vc = segue.destination as! MapViewController
            vc.businesses = self.businesses
            return
        }
        let navigationController = segue.destination as! UINavigationController
        let filterViewController = navigationController.topViewController as! FilterViewController
        
        filterViewController.categoriesCode = self.categories
        filterViewController.delegate = self
    }
    
    func filterViewController(filterViewController: FilterViewController, didUpdateFilter filters: [String : AnyObject]) {
        
        categories = filters["categories"] as? [String]
        offset = 0
        searchItems(q: searchBar.text!, categories: categories)
    }
    
    func searchItems(q: String, categories: [String]?) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Loading..."
        print("offset: \(offset), limit: \(limit)")
        if currentSearchText != searchBar.text! {
            offset = 0
            currentSearchText = searchBar.text!
        } 
        Business.searchWithTerm(term: currentSearchText, sort: nil, categories: categories, deals: nil, offset: offset, limit: limit) {
            (businesses: [Business]?, error: Error?) -> Void in
            if (error != nil) {
                print("Error load data form yelp!")
            } else if let more = businesses {
                print(more.first?.toString() ?? "no business")
                print(more.first?.toString() ?? "empty more")
                if self.businesses == nil || self.offset == 0 {
                    self.businesses = more
                } else {
                    self.businesses.append(contentsOf: more)
                }
                self.mapViewController.businesses = self.businesses
                self.tableView.reloadData()
                self.offset += self.limit
            } else {
                print("Business passed back is nil")
            }
            
            self.isLoadMoreData = false
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
        mapViewController.searchBar.text = searchText
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchItems(q: searchBar.text!, categories: categories)
        hideSearchBar()
    }
    
    
    @IBAction func cancelSearchButtonTap(_ sender: Any) {
        hideSearchBar()
    }
    
    @IBAction func searchBarButtonDisplayTap(_ sender: Any) {
        showSearchBar()
    }
    
    @IBAction func searchButtonTap(_ sender: Any) {
        searchItems(q: searchBar.text!, categories: categories)
        hideSearchBar()
    }
    
    @IBAction func mapBarButtonTap(_ sender: Any) {
        if mapViewController.view.isHidden {
            mapViewController.view.isHidden = false
            mapBarButton.title = "List"
        } else {
            mapViewController.view.isHidden = true
            mapBarButton.title = "Map"
        }
        
    }
    func showSearchBar() {
        UIView.animate(withDuration: 0.3, animations: {
            if self.mapViewController.view.isHidden {
                self.extendedNavBarView.isHidden = false
                self.topConstraintToView.constant = 52
                self.searchBar.becomeFirstResponder()
            } else {
                self.mapViewController.extendedNavBarView.isHidden = false
                self.mapViewController.mapViewTopConstraint.constant = 44
                self.mapViewController.searchBar.becomeFirstResponder()
            }
            self.navigationItem.leftBarButtonItems = [self.cancelSearchButton]
            self.navigationItem.rightBarButtonItems = [self.searchButton]
        })
        
        
    }
    
    func hideSearchBar() {
        searchBar.resignFirstResponder()
        mapViewController.searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            if self.mapViewController.view.isHidden {
                self.topConstraintToView.constant = 0
                self.extendedNavBarView.isHidden = true
            } else {
                self.mapViewController.mapViewTopConstraint.constant = 0
                self.mapViewController.extendedNavBarView.isHidden = true
            }
            self.navigationItem.titleView = nil
            self.navigationItem.leftBarButtonItems = [self.filterButton]
            self.navigationItem.rightBarButtonItems = [self.searchBarButtonDisplay, self.mapBarButton]
            
            self.navigationItem.title = self.currentSearchText == "" ? "Yelp" : self.currentSearchText
        })
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isLoadMoreData { // already loading
            return
        }
        // load more data
        // Calculate the position of one screen length before the bottom of the results
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
            isLoadMoreData = true
            searchItems(q: searchBar.text!, categories: categories)
        }
    }
    
    // MARK: - Child view controller
    
    func addViewControllerAsChildViewController(childViewController: UIViewController) {
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParentViewController: self)
    }
}
