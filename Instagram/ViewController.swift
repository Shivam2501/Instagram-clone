//
//  ViewController.swift
//  Instagram
//
//  Created by Shivam Bharuka on 1/28/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var photos: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 400;
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Do any additional setup after loading the view, typically from a nib.
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.photos = responseDictionary["data"] as? [NSDictionary]
                            
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PrototypeCell", forIndexPath: indexPath) as! PrototypeCellTableViewCell
        let photo = photos![indexPath.row]
        
        if let photoPath = photo.valueForKeyPath("images.standard_resolution.url") as? String {
            let photoUrl = NSURL(string: photoPath)
            cell.postImage.setImageWithURL(photoUrl!)
        }
        
        
        if let userName = photo.valueForKeyPath("user.username") as? String {
            cell.username.text =  userName
            cell.captionName.text = userName
        } else  {
            cell.username.text = "Anonymous"
            cell.captionName.text = "Anonymous"
        }
        
        if let caption = photo.valueForKeyPath("caption.text") as? String {
            cell.captionText.text =  caption
        } else  {
            cell.captionText.text = " "
        }
        
        if let likes = photo.valueForKeyPath("likes.count") as?  Int{
            cell.likes.text = "\(likes) likes"
        } else  {
            cell.likes.text = "0"
        }
        
        if let userProfileImage = photo.valueForKeyPath("user.profile_picture") as? String {
            let userProfileImageURL = NSURL(string: userProfileImage)
          
            cell.adminImage.setImageWithURL(userProfileImageURL!)
            cell.adminImage.layer.cornerRadius = cell.adminImage.frame.size.width / 2;
            cell.adminImage.clipsToBounds = true
            cell.adminImage.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
            cell.adminImage.layer.borderWidth = 1;
        }
        
        return cell
    }
    
    var flag = false
    
    func loadmoredata(){
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.photos = responseDictionary["data"] as? [NSDictionary]
                            self.flag = false
                            self.tableView.reloadData()
                            
                    }
                }
        });
        task.resume()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(!flag){
            let contentHeight = scrollView.contentSize.height
            let contentOffset = contentHeight - tableView.bounds.size.height
            if(scrollView.contentOffset.y > contentOffset && tableView.dragging){
                flag = true
                
                loadmoredata()
            }
            
        }
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadmoredata()
        refreshControl.endRefreshing()	
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let photos = photos{
             print("row \(photos.count)")
            return photos.count
        }else{
            return 0
        }
    }

}

