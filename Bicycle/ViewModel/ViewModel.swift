//
//  ViewModel.swift
//  Bicycle
//
//  Created by chalie on 4/4/22.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

class ViewModel {
    
    let disposeBag = DisposeBag()
    
    private let model = Model()
    
    private let startCoord = PublishSubject<[CLLocationDegrees]>()
    var startCoordinate: Observable<[CLLocationDegrees]> {
        return startCoord
    }
    
    private let endCoord = PublishSubject<[CLLocationDegrees]>()
    var endCoordinate: Observable<[CLLocationDegrees]> {
        return endCoord
    }
    
    //Get Coordinate from String Address
    func getCoordinate(address: String, separate: String) {
        var longitude: CLLocationDegrees!
        var latitude: CLLocationDegrees!
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { [weak self]
            marks, error in
            if let mark = marks?.first?.location?.coordinate {
                longitude = mark.longitude
                latitude = mark.latitude
                
                if separate == "Start" {
                    self!.startCoord.onNext([longitude, latitude])
                } else if separate == "End" {
                    self!.endCoord.onNext([longitude, latitude])
                }
            } else {
                print("Geocode Error:\(error.customMirror)")
            }
        }
    }
}//End Of The Class


