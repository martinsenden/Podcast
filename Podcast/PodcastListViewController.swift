//
//  FirstViewController.swift
//  Podcast
//
//  Created by Admin on 12/12/2017.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//

import UIKit

class PodcastListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var podcastTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = podcastTableView.dequeueReusableCell(withIdentifier: "PodcastCell")
        
        cell?.textLabel?.text = "Röv"
        return cell!
        
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

