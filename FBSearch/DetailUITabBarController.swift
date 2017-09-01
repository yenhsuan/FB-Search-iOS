//
//  DetailUITabBarController.swift
//  FBSearch
//
//  Created by Terry Chen on 4/16/17.
//  Copyright © 2017 Terry Chen. All rights reserved.
//

import UIKit
import FacebookShare
import FacebookLogin
import FacebookCore
import EasyToast


class DetailUITabBarController: UITabBarController {
    
    var FbId:String=""
    var QueryType:String=""
    var Name:String=""
    var PicUrl:String=""
    
    
    @IBAction func opt(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action:UIAlertAction) in
        

            var content = LinkShareContent(url: URL(string:self.PicUrl)!)
            content.title = self.Name
            content.description = "FB Search for CSCI571"
            content.imageURL = URL(string: self.PicUrl)!
            
            do {
                let dialog = ShareDialog(content: content)
                
                dialog.mode = .feedBrowser
                dialog.presentingViewController = self
                dialog.completion = { result in
                    
                    print(result)
                    
                    switch result {
                    case .success:
                        self.view.showToast("Shared!", position: .bottom, popTime: 2, dismissOnTap: false)
                    case .failed:
                        self.view.showToast("Failed!", position: .bottom, popTime: 2, dismissOnTap: false)
                    case .cancelled:
                        self.view.showToast("Canceled!", position: .bottom, popTime: 2, dismissOnTap: false)
                    }
                }
                
                try dialog.show()
            } catch {}
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in }
        var favorAction:UIAlertAction
        
        
        
        var favIdAry:[String]=UserDefaults.standard.object(forKey: "fav_id") as! [String]
        var favTypeAry:[String]=UserDefaults.standard.object(forKey: "fav_type") as! [String]
        var favNameAry:[String]=UserDefaults.standard.object(forKey: "fav_name") as! [String]
        var favPicAry:[String]=UserDefaults.standard.object(forKey: "fav_pic") as! [String]
        


        
        if let idx = favIdAry.index(of: FbId) {
            
            favorAction = UIAlertAction(title: "Remove from favrotites", style: .default) { (action:UIAlertAction!) in
                
                favIdAry.remove(at: idx)
                favTypeAry.remove(at: idx)
                favNameAry.remove(at: idx)
                favPicAry.remove(at: idx)

                
                UserDefaults.standard.set(favIdAry, forKey: "fav_id")
                UserDefaults.standard.set(favTypeAry, forKey: "fav_type")
                UserDefaults.standard.set(favNameAry, forKey: "fav_name")
                UserDefaults.standard.set(favPicAry, forKey: "fav_pic")
                
                self.view.showToast("Remove from favrotites!", position: .bottom, popTime: 2, dismissOnTap: false)
            }
        }
        else {
            
            favorAction = UIAlertAction(title: "Add to favrotites", style: .default) { (action:UIAlertAction!) in
             
                favIdAry.append(self.FbId)
                favTypeAry.append(self.QueryType)
                favNameAry.append(self.Name)
                favPicAry.append(self.PicUrl)
                
                
                UserDefaults.standard.set(favIdAry, forKey: "fav_id")
                UserDefaults.standard.set(favTypeAry, forKey: "fav_type")
                UserDefaults.standard.set(favNameAry, forKey: "fav_name")
                UserDefaults.standard.set(favPicAry, forKey: "fav_pic")
                self.view.showToast("Add to favrotites!", position: .bottom, popTime: 2, dismissOnTap: false)
            }
        }
    
        
        
        //alert
        alertController.addAction(favorAction)
        alertController.addAction(shareAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
