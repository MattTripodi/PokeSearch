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
import FirebaseDatabase

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	
	// IBOutlets 
	@IBOutlet weak var mapView: MKMapView!
	
	let locationManager = CLLocationManager()
	var mapHasCenteredOnce = false
	var geoFire: GeoFire!
	var geoFireRef: DatabaseReference!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		mapView.delegate = self
		mapView.userTrackingMode = MKUserTrackingMode.follow
		
		geoFireRef = Database.database().reference()
		geoFire = GeoFire(firebaseRef: geoFireRef)
		
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
		
		let annoIdentifier = "Pokemon"
		var annotaionView: MKAnnotationView?
		
		if annotation.isKind(of: MKUserLocation.self) {
			annotaionView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
			annotaionView?.image = UIImage(named: "ash")
		} else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
			annotaionView = deqAnno
			annotaionView?.annotation = annotation
		} else {
			let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
			av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
			annotaionView = av
		}
		
		if let annotationView = annotaionView, let anno = annotation as? PokeAnnotation {
			
			annotaionView?.canShowCallout = true
			annotationView.image = UIImage(named: "\(anno.pokemonNumber)")
			let btn = UIButton()
			btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
			btn.setImage(UIImage(named: "map"), for: .normal)
			annotationView.rightCalloutAccessoryView = btn
		}
		
		return annotaionView
	}
	
	func createSighting(forLocation location: CLLocation, withPokemon pokeId: Int) {
		
		geoFire.setLocation(location, forKey: "\(pokeId)")
	}
	
	func showSightingsOnMap(location: CLLocation) {
		let circleQuery = geoFire!.query(at: location, withRadius: 2.5)
		
		_ = circleQuery?.observe(GFEventType.keyEntered, with: { (
			key, location) in
			
			if let key = key, let location = location {
				let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
				self.mapView.addAnnotation(anno)
			}
		})
	}
	
	func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
		
		let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
		
		showSightingsOnMap(location: loc)
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		
		if let anno = view.annotation as? PokeAnnotation {
			
			var place: MKPlacemark!
			if #available(iOS 10.0, *) {
				place = MKPlacemark(coordinate: anno.coordinate)
			} else {
				place = MKPlacemark(coordinate: anno.coordinate, addressDictionary: nil)
			}
			let destination = MKMapItem(placemark: place)
			destination.name = "Pokemon Sighting"
			let regionDistance: CLLocationDistance = 1000
			let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
			
			let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey:  NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
			
			MKMapItem.openMaps(with: [destination], launchOptions: options)
		}
	}
	
	// IBActions
	@IBAction func spotRandomPokemon(_ sender: Any) {
		
		let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
		
		let rand = arc4random_uniform(151) + 1
		createSighting(forLocation: loc, withPokemon: Int(rand))
	}
	
}



















