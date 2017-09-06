//
//  MyPlayerView.swift
//  videoPlayer
//
//  Created by 蘇冠禎 on 2017/9/6.
//  Copyright © 2017年 蘇冠禎. All rights reserved.
//

import UIKit
import AVFoundation

class MyPlayerView: UIView {

    var playerLayer: AVPlayerLayer?

    override func layoutSubviews() {
        super.layoutSubviews()

        playerLayer?.frame = self.bounds
    }

}
