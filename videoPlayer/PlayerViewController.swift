//
//  PlayerViewController.swift
//  videoPlayer
//
//  Created by 蘇冠禎 on 2017/9/6.
//  Copyright © 2017年 蘇冠禎. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")
        
        self.player = AVPlayer(url: url!)
    }



}
