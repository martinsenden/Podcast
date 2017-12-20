//
//  EpisodeParser.swift
//  Podcast
//
//  Created by Martin Sendén on 2017-12-20.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//



import Foundation

class EpisodeParser: NSObject, XMLParserDelegate {

    var episodeList = [Episode]()
    var parserCompletionHandler: (([Episode]) -> Void)?
    var currentElement = ""
    var insideItem = false
    var title = "" {
        didSet{
            title = title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    var pubDate = "" {
        didSet{
            pubDate = pubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //Might wanna make this look nice? Right now it has 01:06:21 GMT in it
        }
    }
    var audioUrl = "" {
        didSet{
            audioUrl = audioUrl.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    var duration = "" {
        didSet{
            duration = duration.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parseFeed(url: String, completionHandler: (([Episode]) -> Void)?){
        self.parserCompletionHandler = completionHandler
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
        if currentElement == "item"{
            title = ""
            pubDate = ""
            audioUrl = ""
            duration = ""
            insideItem = true
        }
        if currentElement == "enclosure"{
            for string in attributeDict{
                if string.key == "url"{
                    audioUrl += string.value
                    print("Audio URL: \(audioUrl)")
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if insideItem {
            switch currentElement{
                case "title":
                    title += string
                    print("Title \(title)")
                case "pubDate":
                    pubDate += string
                    print("pubDate \(pubDate)")
                case "itunes:duration":
                    duration += string
                    print("Duration \(duration)")
                default:
                    break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            let episode = Episode(title: title, publishingDate: pubDate, duration: duration, audioURL: audioUrl)
            episodeList.append(episode)
            print(episode)
            print("Added item")
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        insideItem = false
        parserCompletionHandler!(episodeList)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
    
    
}
