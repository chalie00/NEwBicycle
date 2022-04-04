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
    
    
    private lazy var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTxtFld.delegate = self
        endTxtFld.delegate = self
        
        
    }
    
    
    //Serarch Button
    func serarchBtnPressed() {
        searchBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                print("Search Button Pressed")
                
            })
            .disposed(by: disposeBag)
    }
    
    
    
    

}//End Of The Class

extension MainView: UITextFieldDelegate {
    
}
