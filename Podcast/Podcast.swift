//
//  Podcast.swift
//  Podcast
//
//  Created by Martin Sendén on 2017-12-18.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//

import Foundation
import XMLMapper

class Podcast: XMLMappable{
    var title: String?
    var latestPublishDate: String?
    var imageUrl: String?
    var episodeList = [Episode]()
    var summary: String?
    
    required init(map: XMLMap) {
        
    }
    
    var nodeName: String!
    
    func mapping(map: XMLMap) {
        title <- map["title"]
        latestPublishDate <- map["pubDate"]
        imageUrl <- map["image.url"]
        summary <- map["description"]
    }
    
    
}
