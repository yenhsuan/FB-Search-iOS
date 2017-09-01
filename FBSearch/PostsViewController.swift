//
//  PostsViewController.swift
//  FBSearch
//
//  Created by Terry Chen on 4/15/17.
//  Copyright © 2017 Terry Chen. All rights imereserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire
import AlamofireImage

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    var FbId:String=""
    var QueryType:String=""
    
    let urlPrefix:String="http://terrycs571-env.us-west-2.elasticbeanstalk.com/hw8.php?"
    
    var PicUrl:String = ""
    var MsgAry:[String] = []
    var TimeAry:[String] = []
    
    var Pic1:UIImageView=UIImageView()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        table.estimatedRowHeight = 70
        table.rowHeight = UITableViewAutomaticDimension
        SwiftSpinner.show("Loading Data...")
        self.table.tableFooterView = UIView(frame: .zero)
        getJSONData()

    }

    func getJSONData() {
        
        var type:String = "fid"
        if QueryType == "event" {
            type = "eid"
        }
        
        let urlString:String = self.urlPrefix + type + "=" + self.FbId

        
        Alamofire.request(urlString).responseJSON { response in
            
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)   // result of response serialization
            //print(response.result.value!)
        
            if (response.result.value != nil) {
                let jsonObj = JSON(response.result.value!)
                
                self.PicUrl = jsonObj["picture"].stringValue
                
                if jsonObj["posts"].exists() {
                    
                    for i in 0..<jsonObj["posts"].count {
                        
                        self.MsgAry.append(jsonObj["posts"][i]["message"].stringValue)
                        
                        let myFormatter = DateFormatter()
                        myFormatter.dateFormat = "yyyy-MM-dd h"
                        
                        
                        let str:String = jsonObj["posts"][i]["time"]["date"].stringValue
                        
                        let index = str.index(str.startIndex, offsetBy: 19)
                        
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
                        let date = dateFormatter.date(from: str.substring(to: index))
                        
                        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
                        let goodDate = dateFormatter.string(from: date!)
                        
                        
                        self.TimeAry.append(goodDate)
                    }
                    
                }
                
                Alamofire.request( self.PicUrl).responseData { response in
                    if let data = response.result.value {
                        self.Pic1.image = (UIImage(data: data)!)
                        self.table.reloadData()
                    }
                }
            }
            
            if self.MsgAry.count == 0 {
                
                let notFoundLabel: UILabel     = UILabel()
                notFoundLabel.text          = "No data found"
                notFoundLabel.textAlignment = .center
                self.table.backgroundView  = notFoundLabel
            }

            self.table.reloadData()
            SwiftSpinner.hide()
            
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MsgAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"PostsTableViewCell" ) as! PostsTableViewCell
        cell.PostMsg.text=MsgAry[indexPath.row]
        cell.Time.text=TimeAry[indexPath.row]
        cell.Pic.image=self.Pic1.image
        return cell
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
