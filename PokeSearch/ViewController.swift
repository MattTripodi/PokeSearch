//
//  ViewController.swift
//  PokeSearch
//
//  Created by Matt Tripodi on 7/15/17.
//  Copyright © 2017 Matthew Tripodi. All rights reserved.
//

import UIKit
import GeoFire
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	
	// IBOutlets 
	@IBOutlet weak var mapView: MKMapView!
	
	let locationManager = CLLocationManager()
	var mapHasCenteredOnce = false
	var geoFire: GeoFire!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		mapView.delegate = self
		mapView.userTrackingMode = MKUserTrackingMode.follow
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		locationAuthStatus()
	}
	
	func locationAuthStatus() {
		// To get the users location only when the app is being used, otherwise the app would drain the users battery
		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
			mapView.showsUserLocation = true
		} else {
			locationManager.requestWhenInUseAuthorization()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		
		if status == .authorizedWhenInUse {
			mapView.showsUserLocation = true
		}
	}
	
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
		
		mapView.setRegion(coordinateRegion, animated: true)
	}
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		
		if let loc = userLocation.location {
			
			if !mapHasCenteredOnce {
				centerMapOnLocation(location: loc)
				mapHasCenteredOnce = true
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		var annotaionView: MKAnnotationView?
		
		if annotation.isKind(of: MKUserLocation.self) {
			annotaionView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
			annotaionView?.image = UIImage(named: "ash")
		}
		
		return annotaionView
	}
	
	// IBActions 
	@IBAction func spotRandomPokemon(_ sender: Any) {
	}
	


}



















