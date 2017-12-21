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
    var playButton: UIButton?
    var playbackSlider: UISlider?
   
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let url = URL(string: "http://traffic.libsyn.com/heatrocks/Jay_Smooth_on_Run_DMCs__Raising_Hell_.mp3?dest-id=576777")
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        let playerLayer=AVPlayerLayer(player: player!)
        playerLayer.frame=CGRect(x:0, y:0, width:10, height:50)
        self.view.layer.addSublayer(playerLayer)
        
        playButton = UIButton(type: UIButtonType.system) as UIButton
        let xPosition:CGFloat = 130
        let yPosition:CGFloat = 480
        let buttonWidth:CGFloat = 150
        let buttonHeight:CGFloat = 45
        
        playButton!.frame = CGRect(x: xPosition, y: yPosition, width: buttonWidth, height: buttonHeight)
        playButton!.backgroundColor = UIColor.white
        playButton!.setTitle("Play", for: UIControlState.normal)
        playButton!.tintColor = UIColor.blue
        playButton!.addTarget(self, action: #selector(PlayViewController.playButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(playButton!)
        
        playbackSlider = UISlider(frame:CGRect(x: 50, y: 450, width: 300, height: 20))
        playbackSlider!.minimumValue = 0
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        playbackSlider!.maximumValue = Float(seconds)
        playbackSlider!.isContinuous = false
        playbackSlider!.tintColor = UIColor.blue
        
        playbackSlider?.addTarget(self, action: #selector(PlayViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        playbackSlider!.addTarget(self, action: "playbackSliderValueChanged:", for: .valueChanged)
        
        self.view.addSubview(playbackSlider!)
        
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.playbackSlider!.value = Float ( time );
            }
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
            playButton!.setTitle("Play", for: UIControlState.normal)
            playButton!.setImage(UIImage(named: "icons8-play-filled-50.png"), for: UIControlState.normal)
            } else {
            player!.pause()
            playButton!.setTitle("Pause", for: UIControlState.normal)
            playButton!.setImage(UIImage(named: "icons8-pause-filled-50.png"), for: UIControlState.normal)
        }
    }
    
}
