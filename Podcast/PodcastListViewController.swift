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

class PodcastListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    var podcastList = [Podcast]()
    var currentElement = ""
    //var tmpPodcast = Podcast()
    
    @IBOutlet var podcastTableView: UITableView!
    
    @IBAction func addPodcastButton(_ sender: Any) {
        let alert = UIAlertController(title: "New Podcast", message: "Please enter a valid RSS feed", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) -> Void in
            let textField = alert.textFields![0]
            let rssFeed = textField.text!
            if rssFeed.isEmpty{
                print("Empty")
                self.present(alert, animated: true, completion: nil)
            } else{
                self.newPodcast(rssFeed: rssFeed)
            }
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
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return podcastList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = podcastTableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath)
        
        cell.textLabel?.text = podcastList[indexPath.row].title
        cell.detailTextLabel?.text = "Latest update: \(podcastList[indexPath.row].latestPublishDate!)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = podcastTableView.cellForRow(at: indexPath)
        //Send RSSUrl to Episode View Controller and let that handle parsing that data. Speeds up runtime.
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "episodeSegue", sender: cell)
        
    }
    
    func fetchData(url: String){
        let podcastParser = PodcastParser()
        
        podcastParser.parseFeed(url: url) { (tmpPodcast) in
            let podcast = tmpPodcast
            self.podcastList.append(podcast)
            print(podcast)
            
            OperationQueue.main.addOperation {
                self.podcastTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    func newPodcast(rssFeed: String){
        fetchData(url: rssFeed)
        for element in podcastList{
            print(element.rssFeed!)
            print(element)
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
        
        for podcast in podcastList{
            fetchData(url: podcast.rssFeed!)
        }
        
        podcastTableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

