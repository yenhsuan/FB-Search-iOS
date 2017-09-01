//
//  ViewController.swift
//  FBSearch
//
//  Created by Terry Chen on 4/10/17.
//  Copyright © 2017 Terry Chen. All rights reserved.
//

import UIKit
import FacebookShare
import CoreLocation
import EasyToast

class ViewController: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate {

    @IBOutlet weak var searchbar: UITextField!
    @IBOutlet weak var NavBtn: UIBarButtonItem!
    
    var lat:Double = 0.0
    var lng:Double = 0.0
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
        

        // Do any additional setup after loading the view, typically from a nib.
//        NavBtn.target=revealViewController()
//        NavBtn.action=#selector(SWRevealViewController.revealToggle(_:))
        if revealViewController() != nil {
            NavBtn.target = self.revealViewController()
            NavBtn.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> (Void) -> Void) // Swift 3 fix
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if UserDefaults.standard.object(forKey: "fav_name") == nil {
            
            let tmp:[String] = []
            UserDefaults.standard.set(tmp, forKey: "fav_id")
            UserDefaults.standard.set(tmp, forKey: "fav_type")
            UserDefaults.standard.set(tmp, forKey: "fav_name")
            UserDefaults.standard.set(tmp, forKey: "fav_pic")
        }
        
        
        self.title="FBSearch"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.lat = locValue.latitude
        self.lng = locValue.longitude
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        let tabBarController = segue.destination as! UITabBarController
//        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
//        let vc = navigationController.viewControllers[0] as! UserViewController
//        vc.setKeyword(key:searchbar.text!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SearchBtn(_ sender: Any) {
       //self.performSegue(withIdentifier: "results", sender: self)
        
        if searchbar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" {
            let mainStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier:"tabs_page") as! UITabBarController
            
            for i in 0..<5 {
                let navigationController = desController.viewControllers![i] as! UINavigationController
                let vc = navigationController.viewControllers[0] as! SearchViewController
                vc.typeIdx = i
                vc.setKeyword(key:(searchbar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!)
                vc.lat = self.lat
                vc.lng = self.lng
            }
            
            revealViewController().setFront(desController, animated:true)
        }
        else {
            self.view.showToast("Enter a valid query!", position: .bottom, popTime: 2, dismissOnTap: false)
        }
        searchbar.resignFirstResponder()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchbar.resignFirstResponder()
        return false
    }
    
    
    
    @IBAction func ClrBtn(_ sender: Any) {
        
        searchbar.text=""
    }
    
    
    
}

