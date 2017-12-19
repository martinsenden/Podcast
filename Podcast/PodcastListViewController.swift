//
//  FirstViewController.swift
//  Podcast
//
//  Created by Admin on 12/12/2017.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//

import UIKit

//We have to store podcasts & episodes persistently with CoreData. According to assignment?

class PodcastListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var podcastTableView: UITableView!
    
    @IBAction func addPodcastButton(_ sender: Any) {
        
    }
    var podcastList = [Podcast]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = podcastTableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath)
        
        cell.textLabel?.text = "PodcastTitle"
        cell.detailTextLabel?.text = "ShortSummaryFromXML"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = podcastTableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath)
        performSegue(withIdentifier: "episodeSegue", sender: cell)
    }
    
    func newPodcast(rssFeed: String){
        //Create new podcast and parse all values (Separate function?)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "episodeSegue"{
            //Send which podcast with it
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

