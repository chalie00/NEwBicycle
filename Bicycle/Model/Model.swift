//
//  Model.swift
//  Bicycle
//
//  Created by chalie on 4/4/22.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

class Model {
    
    private let startPin = PublishSubject<MKPointAnnotation>()
    var startPinObs: Observable<MKPointAnnotation> {
        return startPin
    }
    
    private let endPin = PublishSubject<MKPointAnnotation>()
    var endPinObs: Observable<MKPointAnnotation> {
        return endPin
    }
    
    private let startCoordinate = PublishSubject<CLLocationCoordinate2D>()
    var startCoorObs: Observable<CLLocationCoordinate2D> {
        return startCoordinate
    }
    
    private let endCoordinate = PublishSubject<CLLocationCoordinate2D>()
    var endCoorObs: Observable<CLLocationCoordinate2D> {
        return endCoordinate
    }
    
    //Generate Annotation
    func generateAnnotation(lon: CLLocationDegrees, lat: CLLocationDegrees, separate: String) {
        let annotation = MKPointAnnotation()
        
        if separate == "Start" {
            annotation.coordinate = CLLocationCoordinate2D(latitude: lon, longitude: lat)
            startPin.onNext(annotation)
            print(startPinObs)
        }
    }
    
    
}//End Of The Class

