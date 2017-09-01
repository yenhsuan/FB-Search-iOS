//
//  SearchUITabBarController.swift
//  FBSearch
//
//  Created by Terry Chen on 4/14/17.
//  Copyright © 2017 Terry Chen. All rights reserved.
//

import UIKit

class SearchUITabBarController: UITabBarController {
    var TypeSelect:Int = 0;
    var keyword:String = ""
    
    var ControllerId:[String] = ["UserViewController","PageViewController","EventViewController","PlaceViewController","GroupViewController"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let mainStoryboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
        var IDIndex:Int = 0
        
        if item == (self.tabBar.items!)[0] {
            IDIndex = 0
        }
        else if item == (self.tabBar.items!)[1] {
            IDIndex = 1
        }
        
        let desController = mainStoryboard.instantiateViewController(withIdentifier:ControllerId[IDIndex]) as! SearchViewController
        
        desController.typeIdx = IDIndex
        desController.setKeyword(key:keyword)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
