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
    
    private let model = Model()
    
    private let startTxtSub = PublishSubject<String>()
    var startTxt: Observable<String> {
        return startTxtSub
    }
    
    private let endTxtSub = PublishSubject<String>()
    var endTxt: Observable<String> {
        return endTxtSub
    }
    
    //Get Coordinate from String Address
    func getCoordinate(address: String, separate: String) {
        let addressStr = address
        var longitude: CLLocationDegrees!
        var latitude: CLLocationDegrees!
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(addressStr) { [self]
            marks, error in
            if let mark = marks?.first?.location?.coordinate {
                longitude = mark.longitude
                latitude = mark.latitude
                print("lon: \(String(describing: longitude)) , lat: \(String(describing: latitude))")
                if separate == "Start" {
                    startTxtSub.onNext(address)
                }
            }
        }
    }
    
    
}//End Of The Class

