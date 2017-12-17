//
//  FirstViewController.swift
//  Podcast
//
//  Created by Admin on 12/12/2017.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//

import UIKit

class PodcastTableCell:  UITableViewCell {
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var podcastLabel: UILabel!
}


class PodcastListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var podcastTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = podcastTableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath) as! PodcastTableCell
        
        cell.textLabel?.text = "Röv"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = podcastTableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath)
        performSegue(withIdentifier: "episodeSegue", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "episodeSegue"{
            //Probably send podcast with it?
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

