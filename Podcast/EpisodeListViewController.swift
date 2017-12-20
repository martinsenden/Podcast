//
//  EpisodeListViewController.swift
//  Podcast
//
//  Created by Martin Sendén on 2017-12-17.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//

import UIKit

class EpisodeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rssFeed: String = ""
    var episodeList = [Episode]()
    
    
    @IBOutlet weak var episodeListTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = episodeListTableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) 
        
        cell.textLabel!.text = episodeList[indexPath.row].title
        cell.detailTextLabel!.text = "Length: \(episodeList[indexPath.row].duration)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Send to play function
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func fetchData(url: String){
        let episodeParser = EpisodeParser()
        
        episodeParser.parseFeed(url: url) { (tmpEpisodeList) in
            self.episodeList = tmpEpisodeList
            
            OperationQueue.main.addOperation {
                self.episodeListTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(url: rssFeed)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
