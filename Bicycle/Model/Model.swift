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
    
    
}//End Of The Class

