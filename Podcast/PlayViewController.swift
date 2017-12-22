//
//  PlayViewController.swift
//  Podcast
//
//  Created by Admin on 19/12/2017.
//  Copyright © 2017 at.fhooe.mcm. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController{
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var rssFeed: String? = "null"
    var imageUrl: String = "null"
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBAction func timeChanged(_ sender: UISlider) {
        playbackSliderValueChanged(sender)
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        playButtonTapped(sender)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func sliderVolumeChanged(_ sender: UISlider) {
        let currentValue = Float(sender.value)
        player?.volume = currentValue
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        downloadImage(url: imageUrl)
        let url = URL(string: rssFeed!)
        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame=CGRect(x:0, y:0, width:10, height:50)
        self.view.layer.addSublayer(playerLayer)
        
        
        playButton!.setImage(UIImage(named: "icons8-play-filled-50.png"), for: UIControlState.normal)
        playButton!.setTitle("Play", for: UIControlState.normal)
        playButton!.tintColor = UIColor.blue
        
        timeSlider!.minimumValue = 0
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        timeSlider!.maximumValue = Float(seconds)
        timeSlider!.isContinuous = false
        timeSlider!.tintColor = UIColor.blue
        
        
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.timeSlider!.value = Float ( time );
            }
        }
    }
    
    func downloadImage(url: String){
        let url = URL(string: url)
        if let data = try? Data(contentsOf: url!) {
            imageView.image = UIImage(data: data)
        }
        else {
            
        }
    }

    @objc
    func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @objc
    func playButtonTapped(_ sender:UIButton)
    {
        if player?.rate == 0
        {
            player!.play()
            playButton!.setTitle("Pause", for: UIControlState.normal)
            playButton!.setImage(UIImage(named: "icons8-pause-filled-50.png"), for: UIControlState.normal)
            } else {
            player!.pause()
            playButton!.setTitle("Play", for: UIControlState.normal)
            playButton!.setImage(UIImage(named: "icons8-play-filled-50.png"), for: UIControlState.normal)
        }
    }
    
}
