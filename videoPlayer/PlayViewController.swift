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

    var myPlayerView = MyPlayerView()
    
    var searchBar: UISearchBar = UISearchBar()
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var playerItem:AVPlayerItem!
    var avplayer:AVPlayer!
    var playerLayer:AVPlayerLayer!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPlayerView()
        
        setUpSearchBar()

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
        
        searchBar.sizeToFit()
        
        searchBar.isTranslucent = true
        
        searchBar.backgroundImage = UIImage()
        
        searchBar.delegate = self
        
        self.view.addSubview(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if let videoUrl = searchBar.text,
            let videoURL = URL(string: videoUrl) {
            
            playVideo(url: videoURL)
        }
    }
    
    // MARK: AVPlayer
    
    func playVideo(url: URL) {

//        guard let url = URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")
//            else { fatalError("连接错误") }
        
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
            // 缓冲进度 暂时不处理
            print("later")
        } else if keyPath == "status"{
            // 监听状态改变
            if playerItem.status == AVPlayerItemStatus.readyToPlay{
                // 只有在这个状态下才能播放
                self.avplayer.play()
            } else {
                print("加载异常")
            }
        }
    }

}
