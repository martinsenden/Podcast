//
//  Podcast.swift
//  Podcast
//
//  Created by Martin Sendén on 2017-12-18.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//

import Foundation

struct Podcast {
    var title: String?
    var latestPublishDate: String?
    var imageUrl: String?
    var summary: String?
    var rssFeed: String?
    
    init(){
    
    }
    init(rssFeed: String){
        self.rssFeed = rssFeed
    }
}
