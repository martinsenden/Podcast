//
//  EpisodeListViewController.swift
//  Podcast
//
//  Created by Martin Sendén on 2017-12-17.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class EpisodeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var episodeListTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = episodeListTableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
        
        cell.textLabel!.text = "Fitta"
        return cell
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
