//
//  MapViewController.swift
//  Yelp
//
//  Created by Nghia Nguyen on 7/14/17.
//  Copyright (c) 2017 Timothy Lee, Nghia Nguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {


    @IBOutlet weak var extendedNavBarView: UIView!
    @IBOutlet weak var mapViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager!
    var businesses: [Business]! {
        didSet {
            addNotationForBussiness()
        }
    }
    let searchBar = UISearchBar()
    var parentBusinessViewController: BusinessesViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parentBusinessViewController = self.parent as! BusinessesViewController
        mapViewTopConstraint.constant = 0
        setupSearchBar()
        
        self.navigationController?.navigationBar.tintColor = .white
        mapView.delegate = self
        
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(location: centerLocation)
        
        // Ask for user to show the blue dot on map
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
//        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.setBackgroundImage(#imageLiteral(resourceName: "red"), for: .any, barMetrics: .default)
        extendedNavBarView.addSubview(searchBar)
        searchBar.sizeToFit()
        extendedNavBarView.isHidden = true
    }
    
    func goToLocation(location: CLLocation) {
//        let span = MKCoordinateSpanMake(70, 70)
//        let region = MKCoordinateRegionMake(location.coordinate, span)
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000)
        mapView.setRegion(mapView.regionThatFits(region), animated: false)
        
    }
    
    func addNotationForBussiness() {
        var annotations = [MKAnnotation]()
        for business in businesses {
           let annotation = BusinessAnnotation(business: business)
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        if annotations.count > 0 {
            mapView.selectedAnnotations = [annotations.first!]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Location Manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Add notation at a location
    // add an Annotation with a coordinate: CLLocationCoordinate2D
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    // add an annotation with an address: String
    func addAnnotationAtAddress(address: String, title: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate.coordinate
                    annotation.title = title
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }

    // MARK: - MapView Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "BusinessAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = BussinessAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView!.annotation = annotation
        }
        
        
        return annotationView
    }
    
    // MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parentBusinessViewController.searchButton.isEnabled = true
            parentBusinessViewController.searchBar.text = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        parentBusinessViewController.searchBarSearchButtonClicked(parentBusinessViewController.searchBar)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
