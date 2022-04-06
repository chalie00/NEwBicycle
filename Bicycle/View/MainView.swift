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

class MainView: UIViewController {

    //Outlet
    
    @IBOutlet weak var startTxtFld: UITextField!
    @IBOutlet weak var endTxtFld: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTxtFld.delegate = self
        endTxtFld.delegate = self
        
        searchBtnPressed()
        
    }
    
    
    //Search Button
    func searchBtnPressed() {
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
