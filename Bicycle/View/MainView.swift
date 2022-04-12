//
//  ViewController.swift
//  Bicycle
//
//  Created by chalie on 4/4/22.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

class MainView: UIViewController, MKMapViewDelegate {
    
    //Outlet
    
    @IBOutlet weak var startTxtFld: UITextField!
    @IBOutlet weak var endTxtFld: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    var locManager: CLLocationManager = CLLocationManager()
    var start2D = CLLocationCoordinate2D()
    var end2D = CLLocationCoordinate2D()
    var polyLine: MKPolyline!
    //    var startCoordinate = PublishSubject<[CLLocationDegrees]>()
    //    var endCoordinate: [CLLocationDegrees] = []
    var startPin = MKPointAnnotation()
    var endPin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        mapView.delegate = self
        startTxtFld.delegate = self
        endTxtFld.delegate = self
        
        txtFldObservable()
        subscribeForCoordinate()
        
        callTheCurrentLocation()
        
    }
    
    //Start_End TxtFld Observable
    func txtFldObservable() {
        mapView.userTrackingMode = .none
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        
        startTxtFld.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(2), scheduler: scheduler)
            .subscribe(onNext: { [weak self] txt in
                self!.viewModel.getCoordinate(address: txt, separate: "Start")
            }).disposed(by: disposeBag)
        
        endTxtFld.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(2), scheduler: scheduler)
            .subscribe(onNext: {
                [weak self] txt in
                self!.viewModel.getCoordinate(address: txt, separate: "End")
            }).disposed(by: disposeBag)
    }
    
    //Subscribe Coordinate Of The Model
    func subscribeForCoordinate() {
        viewModel.startCoordinate.asObservable().subscribe { [self]
            coordinate in
            let lon = coordinate.element?[0]
            let lat = coordinate.element?[1]
            
            if lon != nil && lat != nil {
                print("Set Start")
                self.setThePin(lon: lon!, lat: lat!, separete: "Start")
                start2D = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
            }
        }.disposed(by: disposeBag)
        viewModel.endCoordinate.asObservable().subscribe { [self]
            coordinate in
            let lon = coordinate.element?[0]
            let lat = coordinate.element?[1]
            if lon != nil && lat != nil {
                print("Set End")
                self.setThePin(lon: lon!, lat: lat!, separete: "End")
                end2D = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
            }
        }.disposed(by: disposeBag)
        if (startPin != nil) && (endPin != nil) {
            drawPath(start: start2D, end: end2D)
        }
    }
    
    //Set the Pin
    func setThePin(lon: CLLocationDegrees, lat: CLLocationDegrees, separete: String) {
        print("Set Pin")
        //        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lon, lat)
        //        var region: MKCoordinateRegion = mapView.region
        ////        region.center = location
        //        region.span.latitudeDelta = 0.5
        //        region.span.longitudeDelta = 0.5
        //        mapView.setRegion(region, animated: true)
        //        let annotation = MKPointAnnotation()
        //        annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        //        self.mapView.addAnnotation(annotation)
        
        if separete == "Start" {
            let coordinate = CLLocationCoordinate2DMake(lat, lon)
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            startPin = pin
            self.mapView.addAnnotation(pin)
        } else if separete == "End" {
            let coordinate = CLLocationCoordinate2DMake(lat, lon)
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            endPin = pin
            self.mapView.addAnnotation(pin)
        }
    }
    
    func drawPath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let source = MKPlacemark(coordinate:start )
        let destination = MKPlacemark(coordinate: end)
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: source)
        directionRequest.destination = MKMapItem(placemark: destination)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [self]
            response, error in
            guard let directionResponse = response else {
                if let error = error {
                    print("Direction Error:\(error)")
                }
                return
            }
            let route = directionResponse.routes[0]
            print("Route:\(route)")
            if (self.polyLine != nil) {
                mapView.removeOverlay(self.polyLine)
            }
            self.polyLine = route.polyline
            mapView.addOverlay(self.polyLine)
            
            let rect = route.polyline.boundingMapRect
            mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            print("Ploy Line")
        }
        
    }
    
    //ACtion
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        callSearch()
    }
    
    
    
    //Current Location
    func callTheCurrentLocation() {
        print("callTheCurrent")
        locManager.requestWhenInUseAuthorization()
        let status = locManager.authorizationStatus
        switch status {
        case .notDetermined:
            print("Please Set the Auth")
        case .restricted:
            print("Please Set the Auth")
        case .denied:
            print("Please Set the Auth")
        case .authorizedAlways:
            locManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locManager.startUpdatingLocation()
        case .authorized:
            locManager.startUpdatingLocation()
        @unknown default:
            print("Error")
        }
        
    }
    
    //Search Button
    func callSearch() {
        print("pressed")
        searchBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                print("Search Button Pressed")
                self!.viewModel.getCoordinate(address: self!.startTxtFld.text!, separate: "Start")
            })
            .disposed(by: disposeBag)
    }
    
    
    
    
    
}//End Of The Class

extension MainView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.startTxtFld.isFirstResponder || self.endTxtFld.isFirstResponder) {
            self.startTxtFld.resignFirstResponder()
            self.endTxtFld.resignFirstResponder()
        }
    }
    
}

extension MainView: CLLocationManagerDelegate {
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            mapView.userTrackingMode = .follow
        }
    
}
