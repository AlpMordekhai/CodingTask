//
//  DataRetrieval.swift
//  CodingTask_Futurice
//
//  Created by Alberto Lopez on 13/03/16.
//  Copyright © 2016 AlbertoLopez. All rights reserved.
//

import Foundation
import MBProgressHUD
import Alamofire


let webServiceURL =  "http://jsonplaceholder.typicode.com"

// MARK: - webServiceDelegates
/**
Returns the list of users in form of a [UserStruct], .
*/
protocol UserListDataSource
{
     func getUserList(controller:DataRetrievalModule, usersArray:[UserStructs])
}

/**
 Receives a selected user ID and returns the data from that profile as well as all the photo albums
 */
protocol UserInfoDataSource
{
    func getUserProfile(controller:DataRetrievalModule, userProfile: UserStructs?)
    func getUserAlbums(controller:DataRetrievalModule, userAlbums: [PhotoAlbum]?)
}



class DataRetrievalModule
{
    var userListDelegate:UserListDataSource? = nil
    var userInfoDelegate:UserInfoDataSource? = nil

    /**
     Retrieves and parses the user list into structs.
    */
    func getUserList ()
    {
            Alamofire.request(.GET, String(webServiceURL + "/users/"))
                .responseJSON { response in
                    if let JSON = response.result.value
                    {
                        if let data = JSON as? NSMutableArray
                        {
                            var userArray:[UserStructs] = [UserStructs()]
                            userArray.removeAll()
                            let count = data.count
                            for index in 0..<count
                            {
                                if let userDict = data[index] as? NSDictionary
                                {
                                    var newUser : UserStructs = UserStructs.init()
                                    if let var1 = userDict["id"] as? Int
                                    {
                                        newUser.userId = var1
                                    }
                                    if let var2 = userDict["name"] as? String
                                    {
                                        newUser.nameTag = var2
                                    }
                                    if let var3 = userDict["username"] as? String
                                    {
                                        newUser.userName = var3
                                    }
                                    userArray.append(newUser)
                                }

                            }
                            if (self.userListDelegate != nil)
                            {
                                self.userListDelegate!.getUserList(self, usersArray:userArray)
                            }

                        }
                    }
        }
    }
    
    /**
     Gets a user ID and parses the profile info, returns it so the interface can be updated.
     After that, it calls getUserAlbums, which receives the userStruct and retrieves the list of albums
     It then calls getUserAlbumPics which receives the albums, gets all the pics of the web service and filters them into the original structs, in order to preserve eficiency it only traverses the photos array once, iterating through the ID's based on the principle that the web service sends the photos and albums ordered by ID
     */

    func getUserProfile (userId: Int)
        {
            let newURL = webServiceURL + "/users/" + String(userId)
            Alamofire.request(.GET, newURL)
                .responseJSON { response in
                    if let JSON = response.result.value
                    {
                        if let userDict = JSON as? NSDictionary
                        {
                            var newUser : UserStructs = UserStructs.init()
                          
                            if let var1 = userDict["id"] as? Int
                            {
                                newUser.userId = var1
                            }
                            if let var2 = userDict["name"] as? String
                            {
                                newUser.nameTag = var2
                            }
                            if let var3 = userDict["username"] as? String
                            {
                                newUser.userName = var3
                            }
                            if let var4 = userDict["email"] as? String
                            {
                                newUser.email = var4
                            }
                            if let var5 = userDict["phone"] as? String
                            {
                                newUser.phone = var5
                            }
                            if let var6 = userDict["website"] as? String
                            {
                                newUser.website = var6
                            }
                            if let compDict = userDict["company"] as? NSDictionary
                            {
                                if let var1 = compDict["name"] as? String
                                {
                                    newUser.company = var1
                                }
                            }
                            if (self.userInfoDelegate != nil) {
                                self.userInfoDelegate!.getUserProfile(self, userProfile: newUser)
                                self.getUserAlbums(newUser)
                            }

                        }
                    }
                    else{
                        if (self.userInfoDelegate != nil) {
                            self.userInfoDelegate!.getUserProfile(self, userProfile: nil)
                        }
                    }
            }
        }
    func getUserAlbums (userInfo: UserStructs)
    {
        let newURL = webServiceURL + "/users/" + String(userInfo.userId!) + "/albums"
        Alamofire.request(.GET, newURL)
            .responseJSON { response in
                
                if let JSON = response.result.value
                {
                    if let albumArray = JSON as? NSMutableArray
                    {
                        var finalAlbumArray:[PhotoAlbum] = [PhotoAlbum()]
                        finalAlbumArray.removeAll()
                        
                        for album in albumArray
                        {
                            if let albumDict = album as? NSDictionary
                            {
                                var photoAlb:PhotoAlbum = PhotoAlbum()
                                
                                if let var1 = albumDict["id"] as? Int
                                {
                                    photoAlb.albumId = var1
                                }
                                if let var2 = albumDict["title"] as? String
                                {
                                    photoAlb.albumTitle = var2
                                }
                                finalAlbumArray.append(photoAlb)
                            }
                        }
                        if finalAlbumArray.count>0
                        {
                            if (self.userInfoDelegate != nil)
                            {
                                //self.userInfoDelegate!.getUserAlbums(self, userAlbums: finalAlbumArray)
                                self.getUserAlbumPics(finalAlbumArray)
                                
                            }
                        }
                        else
                        {
                            if (self.userInfoDelegate != nil)
                            {
                                self.userInfoDelegate!.getUserAlbums(self, userAlbums: nil)
                            }
                        }
                        
                    }
                    else
                    {
                        if (self.userInfoDelegate != nil)
                        {
                            self.userInfoDelegate!.getUserAlbums(self, userAlbums: nil)
                        }
                    }
                }
        }
    }
    func getUserAlbumPics (albumArray: [PhotoAlbum])
    {
        var localAlbumArray: [PhotoAlbum] = albumArray
        
        //assuming they're sorted
        var userAlbumIDs : [Int] = [Int]()
        userAlbumIDs.removeAll()
        
        //optimize
        for albums in localAlbumArray
        {
            userAlbumIDs.append(albums.albumId)
        }
        
        let newURL = webServiceURL + "/photos/"
        Alamofire.request(.GET, newURL)
            .responseJSON { response in
                
                if let JSON = response.result.value
                {
                    if let rawPhotoArray = JSON as? NSMutableArray
                    {
                        var photoArray:[Photos] = [Photos()]
                        photoArray.removeAll()
                        
                        var iteratorAlbumId = 0
                        
                        for singlePhoto in rawPhotoArray
                        {
                            
                            if let albumDict = singlePhoto as? NSDictionary
                            {
                                //by assuming the indexes and the items are sorted, we reduce the sorting cost
                                if let albumID = albumDict["albumId"] as? Int
                                {
                                    if userAlbumIDs.contains(albumID)
                                    {
                                        if albumID > userAlbumIDs[iteratorAlbumId]
                                        {
                                            localAlbumArray[iteratorAlbumId].photoAlbums = photoArray
                                            iteratorAlbumId++
                                            photoArray.removeAll()
                                        }
                                        
                                        var newPhoto:Photos = Photos()
                                        
                                        if let var1 = albumDict["id"] as? Int
                                        {
                                            newPhoto.photoId = var1
                                        }
                                        if let var2 = albumDict["title"] as? String
                                        {
                                            newPhoto.photoTitle = var2
                                        }
                                        if let var3 = albumDict["url"] as? String
                                        {
                                            newPhoto.url = var3
                                        }
                                        photoArray.append(newPhoto)
                                    }
                                }
                                
                                //finalAlbumArray.append(photoAlb)
                            }
                        }
                        localAlbumArray[iteratorAlbumId].photoAlbums = photoArray //add last element
                        self.userInfoDelegate!.getUserAlbums(self, userAlbums: localAlbumArray)
                        
                    }
                    else
                    {
                        self.userInfoDelegate!.getUserAlbums(self, userAlbums: nil)
                    }
                }
        }
        
    }
    

    


}

