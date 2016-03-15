//
//  UsersAlbumsPhotosModel.swift
//  CodingTask_Futurice
//
//  Created by Alberto Lopez on 15/03/16.
//  Copyright © 2016 AlbertoLopez. All rights reserved.
//

import Foundation


// MARK: - Structs used
/**
*/

struct Photos{
    var photoTitle : String = ""
    var url : String = ""
    var photoId : Int!
    init() {
    }
    
}
struct PhotoAlbum {
    var albumTitle : String = ""
    var albumId : Int!
    var photoAlbums : [Photos]?
    init() {
    }
    
}

struct UserStructs {
    var nameTag : String = ""
    var userName : String = ""
    var email : String = ""
    var address : String = ""
    var phone : String = ""
    var website : String = ""
    var company : String = ""
    var userId : Int!
    var photoAlbums : [PhotoAlbum]?
    
    init() {
    }
    
}

