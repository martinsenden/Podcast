//
//  Episode.swift
//  Podcast
//
//  Created by Martin Sendén on 2017-12-18.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//

import Foundation
import XMLMapper

class Episode: XMLMappable{
    var title: String?
    var publishingDate: Date?
    var duration: String?
    var audioURL: String?
    
    required init(map: XMLMap) {
        
    }
    
    var nodeName: String!
    
     func mapping(map: XMLMap) {
        title <- map["item.title"]
        publishingDate <- map["item.pubDate"]
        duration <- map["itunes:duration"]
        audioURL <- map["enclosure.url"]
    }
    
    
}
