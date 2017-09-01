//
//  AlbumsViewController.swift
//  FBSearch
//
//  Created by Terry Chen on 4/14/17.
//  Copyright © 2017 Terry Chen. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire
import AlamofireImage


class AlbumsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var FbId:String=""
    var QueryType:String=""
    
    let urlPrefix:String="http://terrycs571-env.us-west-2.elasticbeanstalk.com/hw8.php?"
    
    @IBOutlet weak var table: UITableView!
    
    var testAry:[String] = ["row1","row2"]
    var dataAry:[String] = ["data1","data2"]
    var selectedIndex:Int = -1
    
    var AlbumNameAry:[String] = []
    var Photo1:[String] = []
    var Photo2:[String] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading Data...")
        self.table.tableFooterView = UIView(frame: .zero)   // Do any additional setup after loading the view.
        getJSONData()
    }
    
    
    func getJSONData() {
        
        var type:String = "fid"
        if QueryType == "event" {
            type = "eid"
        }
        
        let urlString:String = self.urlPrefix + type + "=" + self.FbId
        // print("url="+self.FbId)
        
        Alamofire.request(urlString).responseJSON { response in
            // print(response.request!)  // original URL request
            // print(response.response!) // HTTP URL response
            // print(response.data!)     // server data
            // print(response.result)   // result of response serialization
            // print(response.result.value!)
            
            if (response.result.value != nil) {
                let jsonObj = JSON(response.result.value!)
                
                if jsonObj["albums"].exists() {
                    
                    for i in 0..<jsonObj["albums"].count {
                        
                        self.AlbumNameAry.append(jsonObj["albums"][i]["name"].stringValue)
                        
                        if jsonObj["albums"][i]["photos"].count == 2 {
                            
                            self.Photo1.append(jsonObj["albums"][i]["photos"][0].stringValue)
                            self.Photo2.append(jsonObj["albums"][i]["photos"][1].stringValue)
                        }
                        else if jsonObj["albums"][i]["photos"].count == 1 {
                            self.Photo1.append(jsonObj["albums"][i]["photos"][0].stringValue)
                            self.Photo2.append("noPic")
                        }
                        else {
                            self.Photo1.append("noPic")
                            self.Photo2.append("noPic")
                        }
                    }
                    
                }

            }
            
            
            if self.AlbumNameAry.count == 0 {
                
                let notFoundLabel: UILabel     = UILabel()
                notFoundLabel.text          = "No data found"
                notFoundLabel.textAlignment = .center
                self.table.backgroundView  = notFoundLabel
            }
            
            
           
            self.table.reloadData()
            
            

            SwiftSpinner.hide()
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AlbumNameAry.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            selectedIndex = -1
        }
        else {
            selectedIndex = indexPath.row
        }

        self.table.beginUpdates()
        self.table.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        self.table.endUpdates()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"album_cell" ) as! AlbumTableViewCell
        
        cell.AlbumTitle.text!=self.AlbumNameAry[indexPath.row]
        
        if self.Photo1[indexPath.row] != "noPic" {
            Alamofire.request( self.Photo1[indexPath.row]).responseData { response in
                if let data = response.result.value {
                    cell.Pic1.image = (UIImage(data: data)!)
                }
            }
        }
        
        if self.Photo2[indexPath.row] != "noPic" {
            Alamofire.request( self.Photo2[indexPath.row]).responseData { response in
                if let data = response.result.value {
                    cell.Pic2.image = (UIImage(data: data)!)
                }
            }
        }
        
        
        

        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var h:Int = 450
        
        if Photo1[indexPath.row] == "noPic" && Photo2[indexPath.row] == "noPic" {
        
            h=40
        }
        else if Photo2[indexPath.row] == "noPic" {
            h = 250
        }
        
        
        if selectedIndex == indexPath.row {
            return CGFloat(h)
        } else {
            return 40
        }
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
