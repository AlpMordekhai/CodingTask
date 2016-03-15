//
//  UserProfileViewController.swift
//  CodingTask_Futurice
//
//  Created by Alberto Lopez on 14/03/16.
//  Copyright © 2016 AlbertoLopez. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SDWebImage
import MWPhotoBrowser

class UserProfileViewController: UIViewController, UserInfoDataSource, UICollectionViewDataSource, UICollectionViewDelegate, MWPhotoBrowserDelegate {

    
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    var userId : Int!
    var userInfoInterface = DataRetrievalModule() //Necessary for the web service connection
    var userAlbums:[PhotoAlbum]?
    
    
    // MARK: - webServiceDelegates
    /**
    Updates the view's labels, cover photo and collection view with the web service info.
    */
    func getUserAlbums(controller:DataRetrievalModule, userAlbums: [PhotoAlbum]?)
    {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        if userAlbums != nil
        {
            self.userAlbums = userAlbums
            self.albumCollectionView.reloadData()
            self.imgCover.sd_setImageWithURL(NSURL.init(string: userAlbums![0].photoAlbums![0].url))
        }
    }
    func getUserProfile(controller:DataRetrievalModule, userProfile: UserStructs?)
    {
        if(userProfile != nil){
            self.lblUsername.text = userProfile?.userName
            self.lblCompany.text = userProfile?.company
            self.lblName.text = userProfile?.nameTag
            self.lblEmail.text = userProfile?.email
            self.lblWebsite.text = userProfile?.website
            self.lblPhone.text = userProfile?.phone
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        userInfoInterface.userInfoDelegate = self
        userInfoInterface.getUserProfile(userId)
        
    }
    @IBAction func showPosts(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Wait", message: "This feature is yet to be implemented. Thanks for your prefernece. Try the gallery.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Thanks!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Album CollectionView delegates and datasource
    func numberOfSectionsInCollectionView(collectionView:
        UICollectionView) -> Int {
            return 1
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 0.0
        UIView.animateWithDuration(1.0, animations: {cell.alpha = 1.0})
    }
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
            if(self.userAlbums != nil)
            {
                return self.userAlbums!.count
            }
            return 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("profileAlbumCell",
        forIndexPath: indexPath) as! profileAlbumCollectionViewCell
        cell.imgBackground.sd_setImageWithURL(NSURL.init(string: userAlbums![indexPath.row].photoAlbums![0].url))
        cell.lblTitle.text = self.userAlbums![indexPath.row].albumTitle
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.presentGallery()
    }
    
    // MARK: - MWPHotobrowser datasource
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        
        let indexPaths : NSArray = self.albumCollectionView!.indexPathsForSelectedItems()!
        let indexPath : NSIndexPath = indexPaths[0] as! NSIndexPath
        return UInt(self.userAlbums![indexPath.row].photoAlbums!.count)
    }
    func photoBrowser(photoBrowser: MWPhotoBrowser!, thumbPhotoAtIndex index: UInt) -> MWPhotoProtocol! {
        let indexPaths : NSArray = self.albumCollectionView!.indexPathsForSelectedItems()!
        let indexPath : NSIndexPath = indexPaths[0] as! NSIndexPath
        let rawPhoto = self.userAlbums![indexPath.row].photoAlbums![Int(index)]
        let newPhoto = MWPhoto(URL: NSURL(string: rawPhoto.url))
        newPhoto.caption = rawPhoto.photoTitle
        return newPhoto

    }
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
      
        let indexPaths : NSArray = self.albumCollectionView!.indexPathsForSelectedItems()!
        let indexPath : NSIndexPath = indexPaths[0] as! NSIndexPath
        let rawPhoto = self.userAlbums![indexPath.row].photoAlbums![Int(index)]
        let newPhoto = MWPhoto(URL: NSURL(string: rawPhoto.url))
        newPhoto.caption = rawPhoto.photoTitle
        return newPhoto
    }
    func presentGallery ()
    {
        let browser = MWPhotoBrowser(delegate: self)
        browser.displayActionButton = true
        browser.displayNavArrows = true
        browser.displaySelectionButtons = false
        browser.zoomPhotosToFill = true
        browser.alwaysShowControls = false
        browser.enableGrid = true
        browser.startOnGrid = true
        self.navigationController?.pushViewController(browser, animated: true)
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
