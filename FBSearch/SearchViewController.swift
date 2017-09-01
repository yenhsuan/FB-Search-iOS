//
//  UserViewController.swift
//  FBSearch
//
//  Created by Terry Chen on 4/11/17.
//  Copyright © 2017 Terry Chen. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire
import AlamofireImage
import CoreLocation

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate {
    

    @IBOutlet weak var UserNavBtn: UIBarButtonItem!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var BtnNext: UIButton!
    @IBOutlet weak var BtnPrevious: UIButton!
    
    let numOfRows:Int=10;
    
    let locationManager = CLLocationManager()
    
    
    var fav:Bool = false;
    var keyword:String="wait for input"
    let urlPrefix:String="http://terrycs571-env.us-west-2.elasticbeanstalk.com/hw8.php?"

    var json:JSON = []
    
    
    let typeString:[String]=["user","page","event","place","group"]
    var TableCell:[String] = ["UserTableViewCell","PageTableViewCell","EventTableViewCell","PlaceTableViewCell","GroupTableViewCell"]

    var typeIdx:Int = 0
    
    var nameAry:[String]=[];
    var imgAry:[String]=[];
    var idAry:[String]=[];
    
    var nameAryDisplay:[String]=[];
    var imgAryDisplay:[String]=[];
    var idAryDisplay:[String]=[];
    var idxForDisplay:Int=0;
    
    var FbIDSelected:String = ""
    var FbPICSelected:String=""
    var FbNAMESelected:String=""
    
    var lat:Double = 34.0
    var lng:Double = -118.0
    
    
    func getJSONData() {
        
        //Fetching JSON Data
        
        var urlString:String = urlPrefix + "q=" + keyword + "&type=" + typeString[typeIdx]
        
        if typeIdx == 3 {
            urlString = urlString + "&lat=" + String(self.lat) + "&lng=" + String(self.lng)
            print(urlString)
        }
        
        
        
        //print("url="+urlString)
        
        if fav == false {
            Alamofire.request(urlString).responseJSON { response in
                //print(response.request!)  // original URL request
                //print(response.response!) // HTTP URL response
                //print(response.data!)     // server data
                //print(response.result)   // result of response serialization
                //print(response.result.value!)
                
                if response.result.value != nil {
                    let jsonObj = JSON(response.result.value!)
                    
                    for i in 0..<jsonObj["data"].count {
                        
                        self.nameAry.append(jsonObj["data"][i]["name"].stringValue)
                        self.idAry.append(jsonObj["data"][i]["id"].stringValue)
                        self.imgAry.append(jsonObj["data"][i]["picture"]["data"]["url"].stringValue)
                        
                    }
                }
                // Initializing Displaying
                
                var end:Int=self.numOfRows
                if self.nameAry.count<end {
                    end=self.nameAry.count
                }
                
                for i in 0..<end {
                    //print(i)
                    self.nameAryDisplay.append(self.nameAry[i])
                    self.idAryDisplay.append(self.idAry[i])
                    self.imgAryDisplay.append(self.imgAry[i])
                }
                
                self.BtnPrevious.isEnabled=false
                
                if self.nameAry.count>self.numOfRows {
                    self.BtnNext.isEnabled=true
                }
                else {
                    self.BtnNext.isEnabled=false
                }
                
                DispatchQueue.main.async{
                    self.table.reloadData()
                }
                
                if self.idAry.count == 0 {
                    
                    let notFoundLabel: UILabel     = UILabel()
                    notFoundLabel.text          = "No data found"
                    notFoundLabel.textAlignment = .center
                    self.table.backgroundView  = notFoundLabel
                }
                

                SwiftSpinner.hide()
            }
        }
        else {
            self.idxForDisplay = 0
            reloadUDF()        }

    }
    
    func reloadUDF() {
        
        
        var favIdAry:[String]=UserDefaults.standard.object(forKey: "fav_id") as! [String]
        var favTypeAry:[String]=UserDefaults.standard.object(forKey: "fav_type") as! [String]
        var favNameAry:[String]=UserDefaults.standard.object(forKey: "fav_name") as! [String]
        var favPicAry:[String]=UserDefaults.standard.object(forKey: "fav_pic") as! [String]
        // self.idxForDisplay = 0
        self.nameAry=[]
        self.imgAry=[]
        self.idAry=[]
        self.nameAryDisplay=[]
        self.idAryDisplay=[]
        self.imgAryDisplay=[]
        
        for i in 0..<favTypeAry.count {
            if favTypeAry[i] == typeString[typeIdx] {
                self.nameAry.append(favNameAry[i])
                self.imgAry.append(favPicAry[i])
                self.idAry.append(favIdAry[i])
                
            }
        }
        
        if self.idxForDisplay >= self.idAry.count {
            
            self.idxForDisplay = self.idxForDisplay-10
            if self.idxForDisplay < 0 {
                self.idxForDisplay = 0
            }
        }
        
        
        
        var end:Int=self.idxForDisplay + self.numOfRows
        
        
        
        
        if self.nameAry.count<end {
            end=self.nameAry.count
        }
        //print(end)
        for i in self.idxForDisplay..<end {
            //print(self.nameAry[i])
            self.nameAryDisplay.append(self.nameAry[i])
            self.idAryDisplay.append(self.idAry[i])
            self.imgAryDisplay.append(self.imgAry[i])
        }
        
        self.BtnPrevious.isEnabled=false
        if self.idxForDisplay-10 >= 0 {
            self.BtnPrevious.isEnabled=true
        }
        
        self.BtnNext.isEnabled=true
        
        if  self.idxForDisplay+10 >= self.idAry.count {
            self.BtnNext.isEnabled=false
        }
        
        self.table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.table.tableFooterView = UIView(frame: .zero)        
        
        if revealViewController() != nil {
            UserNavBtn.target = self.revealViewController()
            UserNavBtn.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> (Void) -> Void)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        else {
            print("Error in connecting SWR")
        }
        
        
        if fav == false {
            SwiftSpinner.show("Loading Data...")
        }
        
        
        if fav {
            self.navigationItem.title="Favorites"
        }
        else {
            self.navigationItem.title="Search Reasults"
        }
        
        
        getJSONData()
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dc_tab=segue.destination as! DetailUITabBarController
        
        dc_tab.QueryType=self.typeString[typeIdx]
        dc_tab.FbId=self.FbIDSelected
        dc_tab.Name=self.FbNAMESelected
        dc_tab.PicUrl=self.FbPICSelected

        let dc = segue.destination.childViewControllers[0] as! AlbumsViewController
        
        let dc2 = segue.destination.childViewControllers[1] as! PostsViewController
        
        dc.QueryType =  self.typeString[typeIdx]
        dc.FbId = self.FbIDSelected
        
        dc2.QueryType =  self.typeString[typeIdx]
        dc2.FbId = self.FbIDSelected
        

    }
    
    func setKeyword(key:String) {
        keyword=key
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.idAryDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell[typeIdx]) as! SearchTableViewCell
        cell.LabelName.text!=self.nameAryDisplay[indexPath.row]
        
        Alamofire.request( self.imgAryDisplay[indexPath.row]).responseData { response in
            if let data = response.result.value {
                cell.ImgIcon.image = (UIImage(data: data)!)
            }
        }
        
        
        let favIdAry:[String]=UserDefaults.standard.object(forKey: "fav_id") as! [String]
        if favIdAry.index(of: idAryDisplay[indexPath.row]) != nil {
            
            cell.favicon.image = UIImage(named: "filled.png")
        }
        else {
            cell.favicon.image = UIImage(named: "empty.png")
        }
        
        //cell.favicon.isEnabled=false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.FbIDSelected = idAryDisplay[indexPath.row]
        self.FbPICSelected = imgAryDisplay[indexPath.row]
        self.FbNAMESelected = nameAryDisplay[indexPath.row]
        
        
        //print(self.FbIDSelected)
        
        self.performSegue(withIdentifier: "SearchDetail"+String(typeIdx), sender: self)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if revealViewController() != nil {
            UserNavBtn.target = self.revealViewController()
            UserNavBtn.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> (Void) -> Void)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        if fav {
            reloadUDF()
        }
        self.table.reloadData()
    }
    
    
    @IBAction func PreviousClick(_ sender: Any) {
        nameAryDisplay = []
        idAryDisplay = []
        imgAryDisplay = []
        
        self.idxForDisplay-=self.numOfRows
        
        if self.idxForDisplay == 0 {
            self.BtnPrevious.isEnabled=false
        }
        
        self.BtnNext.isEnabled=true
        
        for i in self.idxForDisplay..<self.idxForDisplay+self.numOfRows {
            nameAryDisplay.append(nameAry[i])
            idAryDisplay.append(idAry[i])
            imgAryDisplay.append(imgAry[i])
        }
        
        DispatchQueue.main.async{
            self.table.reloadData()
        }
        
        
    }
    
    
    @IBAction func NextClick(_ sender: Any) {
        nameAryDisplay = []
        idAryDisplay = []
        imgAryDisplay = []
        
        self.idxForDisplay+=self.numOfRows
        
        if self.idxForDisplay+self.numOfRows >= self.idAry.count {
            self.BtnNext.isEnabled=false
        }
        
        self.BtnPrevious.isEnabled=true
        
        var end:Int=self.idxForDisplay+self.numOfRows
        if self.nameAry.count<end {
            end=self.nameAry.count
        }
        
        
        for i in self.idxForDisplay..<end {
            nameAryDisplay.append(nameAry[i])
            idAryDisplay.append(idAry[i])
            imgAryDisplay.append(imgAry[i])
        }
        
        DispatchQueue.main.async{
            self.table.reloadData()
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
