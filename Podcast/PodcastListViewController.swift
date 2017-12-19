//
//  PodcastListViewController.swift
//  Podcast
//
//  Created by Admin on 12/12/2017.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//

import UIKit


//Should we store podcasts persistently with CoreData?
// - Addon if we have time

class PodcastListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var podcastTableView: UITableView!
    
    @IBAction func addPodcastButton(_ sender: Any) {
        let alert = UIAlertController(title: "New Podcast", message: "Please enter a RSS feed", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) -> Void in
            let textField = alert.textFields![0]
            let rssFeed = textField.text!
            self.newPodcast(rssFeed: rssFeed)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .no
            textField.placeholder = "RSS Feed.."
            textField.clearButtonMode = .whileEditing
            
        }
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        assert((alert.textFields![0].text != nil))
        present(alert, animated: true, completion: nil)
        
        
    }
    var podcastList = [Podcast]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return podcastList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = podcastTableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath)
        
        cell.textLabel?.text = podcastList[indexPath.row].rssFeed
        cell.detailTextLabel?.text = "ShortSummaryFromXML"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = podcastTableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath)
        performSegue(withIdentifier: "episodeSegue", sender: cell)
    }
    
    func parsePodcast(){
        // URLSession.dataTask probably? Might exist in XMLParser
    }
    
    func newPodcast(rssFeed: String){
        //Create new podcast and parse all values (Separate function?)
        var podcast = Podcast()
        podcast.rssFeed = rssFeed
        podcastList.append(podcast)
        for element in podcastList{
            print(element.rssFeed!)
        }
        podcastTableView.reloadData()
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

