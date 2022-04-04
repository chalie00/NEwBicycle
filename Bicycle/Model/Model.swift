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

protocol ModelProtocol {
    func getPinData(address: String?) -> MKPointAnnotation
}

class Model {
    
    let startPin: MKPointAnnotation?
    let endPin: MKPointAnnotation?
    
    init(start: MKPointAnnotation, end: MKPointAnnotation) {
        self.startPin = start
        self.endPin = end
    }
}
