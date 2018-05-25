//
//  PickLocationViewController.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 5/19/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import UIKit
import MapKit
class PickLocationViewController: UIViewController, UISearchBarDelegate, UINavigationControllerDelegate {
    
    private var searchController:UISearchController!
    private var annotation:MKAnnotation!
    private var searchRequest:MKLocalSearchRequest!
    private var search:MKLocalSearch!
    private var searchResponse:MKLocalSearchResponse!
    private var error:NSError!
    private var pointAnnotation:MKPointAnnotation!
    private var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet var mapView: MKMapView!
    
    //display the search bar at the top of the map view
    @IBAction func showSearchBar(sender: UIBarButtonItem) {
        searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        //add long press gesture to allow user to manually select location
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(PickLocationViewController.action(_:)))
        uilgr.minimumPressDuration = 2.0
        
        mapView.addGestureRecognizer(uilgr)
        
    }
    
    //if the navigation controller is going back to the previous view, set the location value in the NewDiveController
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? NewDiveTableViewController {
            controller.location = pointAnnotation    // Here you pass the data back to your original view controller
        }
    }
    
    //on long touch, select a point
    func action(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.locationInView(mapView)
        let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        if pointAnnotation != nil {
            mapView.removeAnnotation(pointAnnotation)
        }
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
        
        //one point is selected, figure out place name through reverse geocoding
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary)
            
            // Location name
            var titleString = ""
            if let city = placeMark.addressDictionary!["City"] as? String {
                titleString += city
            }
            if let state = placeMark.addressDictionary!["State"] as? String {
                titleString += ", " + state
            }
            self.pointAnnotation.title = titleString
            
        })
        pointAnnotation = MKPointAnnotation()
        //add pin to map
        pointAnnotation.coordinate = newCoordinates
        mapView.addAnnotation(pointAnnotation)
    }
    //on search
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        
        //resign search bar focus
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        
        //remove any previous annotations from the map
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        //create a new search request object with the search term
        searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        search = MKLocalSearch(request: searchRequest)
        
        //launch search request using localsearch
        search.startWithCompletionHandler { (searchResponse, error) -> Void in
            
            //if there are no matches, tell the user
            
            if searchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //otherwise save the location coordinates and title
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: searchResponse!.boundingRegion.center.latitude, longitude:     searchResponse!.boundingRegion.center.longitude)
            
            
            //add a pin to the resulting location
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    
}
