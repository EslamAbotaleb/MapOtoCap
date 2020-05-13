//
//  ViewController.swift
//  TaskOto
//
//  Created by Islam Abotaleb on 5/13/20.
//  Copyright © 2020 Islam Abotaleb. All rights reserved.
//


import UIKit
import MapKit



class ViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.delegate = self

            createRoutes()
    }


    private func createRoutes() {
        let sourceLocation = CLLocationCoordinate2D(latitude:30.035104 , longitude: 31.405642)
        let destinationLocation = CLLocationCoordinate2D(latitude:30.035225 , longitude: 31.412251)
        
        let sourcePin = PinModel(pinTitle: "cairo festival city", location: sourceLocation)
        let destinationPin = PinModel(pinTitle: "New Cairo", location: destinationLocation)
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("(error\(error)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
    }

    private func zoomToLastLocation(with coordinate:CLLocationCoordinate2D) {
          
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
          mapView.setRegion(region, animated: true)
      }
    private func beignLocationUpdates(locationManager: CLLocationManager) {
           mapView.showsUserLocation = true
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.startUpdatingLocation()
       }
}


// MARK LocationManager
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard  let latestLocation = locations.first else {
            return
        }
        
            zoomToLastLocation(with: latestLocation.coordinate)
          
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beignLocationUpdates(locationManager: manager)
        }
    }
}

//MARK:- MapKit  Annotation delegates
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
            
        }
        if let title = annotation.title, title == "cairo festival city" {
            annotationView?.image = UIImage(named: "bluemap")
        } else if let title = annotation.title, title == "New Cairo" {
            annotationView?.image = UIImage(named: "redmap")

        }
         annotationView?.canShowCallout = true
              
              return annotationView
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.black
        renderer.lineWidth = 4.0
        return renderer
    }
}
