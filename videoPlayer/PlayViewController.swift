//
//  PlayViewController.swift
//  videoPlayer
//
//  Created by 蘇冠禎 on 2017/9/6.
//  Copyright © 2017年 蘇冠禎. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: Property
    
    var searchBar: UISearchBar = UISearchBar()
    
    let screenSize: CGRect = UIScreen.main.bounds

    var myPlayerView = MyPlayerView()
    
    var playerItem: AVPlayerItem = AVPlayerItem(url: URL(string: "forInitialSetting")!)
    
    var avplayer: AVPlayer = AVPlayer()
    
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    
    var playButton: UIButton = UIButton()
    
    var muteButton: UIButton = UIButton()
    
    var isPlaying: Bool = false
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPlayerView()
        
        setUpSearchBar()
        
        setUpButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    deinit {
        
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        
        playerItem.removeObserver(self, forKeyPath: "status")
    }
    
    // MARK: Set Up

    func setUpPlayerView() {
        
        myPlayerView = MyPlayerView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        myPlayerView.backgroundColor = UIColor.black
        
        self.view.addSubview(myPlayerView)
    }
    
    func setUpSearchBar() {
        
        searchBar = UISearchBar(frame: CGRect(x: 8, y: 20, width: screenSize.width-16, height: 30))
        
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        
        searchBar.placeholder = "Enter URL of video"
        
        searchBar.barTintColor = UIColor.black
        
        searchBar.sizeToFit()
        
        searchBar.isTranslucent = true
        
        searchBar.backgroundImage = UIImage()
        
        searchBar.delegate = self
        
        self.view.addSubview(searchBar)
    }
    
    func setUpButton() {
        
        playButton = UIButton(frame: CGRect(x: 20, y: screenSize.height-31, width: 33, height: 19))
        
        playButton.setTitle("Play", for: .normal)
        
        playButton.setTitleColor(UIColor.white, for: .normal)
        
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        playButton.addTarget(self, action: #selector(self.playButtonClicked(sender:)), for: .touchUpInside)
        
        self.view.addSubview(playButton)
        
        muteButton = UIButton(frame: CGRect(x: screenSize.width-55, y: screenSize.height-31, width: 39, height: 19))
        
        muteButton.setTitle("Mute", for: .normal)
        
        muteButton.setTitleColor(UIColor.white, for: .normal)
        
        muteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        muteButton.addTarget(self, action: #selector(self.muteButtonClicked(sender:)), for: .touchUpInside)
        
        self.view.addSubview(muteButton)
        
    }
    
    // MARK: button clicked
    
    @objc func playButtonClicked(sender: UIButton!) {
        
        if !isPlaying {
            
            self.avplayer.play()
            
            isPlaying = true
            
            return
        }
        
        self.avplayer.pause()
        
        isPlaying = false
        
    }
    
    @objc func muteButtonClicked(sender: UIButton!) {
        
        if !avplayer.isMuted {
            
            avplayer.isMuted = true
            
            return
        }

        avplayer.isMuted = false
        
    }
    
    // MARK: Search Bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if let videoUrl = searchBar.text,
            let videoURL = URL(string: videoUrl) {
            
            playVideo(url: videoURL)
        }
    }
    
    // MARK: AVPlayer
    
    func playVideo(url: URL) {
        
        playerItem = AVPlayerItem(url: url)
        // 监听缓冲进度改变
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        // 监听状态改变
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        // 将视频资源赋值给视频播放对象
        self.avplayer = AVPlayer(playerItem: playerItem)
        // 初始化视频显示layer
        playerLayer = AVPlayerLayer(player: avplayer)
        // 设置显示模式
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        // 赋值给自定义的View
        self.myPlayerView.playerLayer = self.playerLayer
        // 位置放在最底下
        self.myPlayerView.layer.insertSublayer(playerLayer, at: 0)

    }
    
    // MARK: KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let playerItem = object as? AVPlayerItem else { return }
        
        if keyPath == "loadedTimeRanges"{

            print("緩衝中...")
        
        } else if keyPath == "status" {

            if playerItem.status == AVPlayerItemStatus.readyToPlay {
                
                self.avplayer.play()
                
                isPlaying = true
            
            } else {
                print("加载异常")
            }
        }
    }

}
