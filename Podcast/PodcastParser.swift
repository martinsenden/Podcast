//
//  XMLParser.swift
//  Podcast
//
//  Created by Martin Sendén on 2017-12-19.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//

import UIKit

class PodcastParser: NSObject, XMLParserDelegate {

    var parserCompletionHandler: ((Podcast) -> Void)?
    var tmpPodcast = Podcast()
    var currentElement = ""
    var insideItem = false
    var titleSet = false
    var title = "" {
        didSet{
            title = title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    var pubDate = "" {
        didSet{
            pubDate = pubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    var imageUrl = "" {
        didSet{
            imageUrl = imageUrl.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    var summary = "" {
        didSet{
            summary = summary.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    
    func parseFeed(url: String, completionHandler: ((Podcast) -> Void)?){
        self.parserCompletionHandler = completionHandler
        tmpPodcast.rssFeed = url
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "channel"{
            print("Inside channel")
            title = ""
            pubDate = ""
            imageUrl = ""
            summary = ""
        }
        
        if currentElement == "item"{
            insideItem = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if insideItem == false{
            switch currentElement {
                case "title" where titleSet == false:
                        title += string
                        titleSet = true
                case "pubDate" where pubDate.isEmpty, "lastBuildDate" where pubDate.isEmpty:
                        print("Pubdate: \(string)")
                        pubDate += string
                case "url":
                        print("Image Url: \(string)")
                        imageUrl += string
                case "itunes:summary":
                        print("Summary: \(string)")
                        summary += string
                default:
                        break
            }
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "channel" {
            print("Setting variables")
            tmpPodcast.title = title
            tmpPodcast.imageUrl = imageUrl
            tmpPodcast.latestPublishDate = pubDate
            tmpPodcast.summary = summary
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        insideItem = false
        print("Ending document")
        parserCompletionHandler!(tmpPodcast)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
