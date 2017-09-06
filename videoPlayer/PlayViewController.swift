//
//  PlayViewController.swift
//  videoPlayer
//
//  Created by 蘇冠禎 on 2017/9/6.
//  Copyright © 2017年 蘇冠禎. All rights reserved.
//

import UIKit
import AVFoundation
import Cartography

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

        playerItem.removeObserver(self, forKeyPath: "status")
    }
    
    // MARK: Set Up

    func setUpPlayerView() {

        myPlayerView = MyPlayerView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))

        myPlayerView.backgroundColor = UIColor(red: 8.0/255.0, green: 21.0/255.0, blue: 35.0/255.0, alpha: 1.0)

        self.view.addSubview(myPlayerView)

        constrain(myPlayerView) { view in

            guard let superview = view.superview
                else { return }

            view.height  == superview.height

            view.width   == superview.width

            view.right   == superview.right

            view.bottom  == superview.bottom
        }
    }

    func setUpSearchBar() {

        searchBar = UISearchBar(frame: CGRect(x: 8, y: 20, width: screenSize.width-16, height: 30))

        searchBar.searchBarStyle = UISearchBarStyle.prominent

        searchBar.placeholder = "Enter URL of video"

        searchBar.barTintColor = UIColor(red: 8.0/255.0, green: 21.0/255.0, blue: 35.0/255.0, alpha: 1.0)

        searchBar.sizeToFit()

        searchBar.isTranslucent = true

        searchBar.backgroundImage = UIImage()

        searchBar.delegate = self

        self.view.addSubview(searchBar)
    }

    // Hide Search Bar when iPhone is in Landscape mode

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        if UIDevice.current.orientation.isLandscape {

            searchBar.isHidden = true

        } else {

            searchBar.isHidden = false
        }
    }

    func setUpButton() {

        playButton = UIButton(frame: CGRect(x: 20, y: screenSize.height-31, width: 50, height: 19))

        playButton.setTitle("Play", for: .normal)

        playButton.setTitleColor(UIColor.white, for: .normal)

        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        playButton.addTarget(self, action: #selector(self.playButtonClicked(sender:)), for: .touchUpInside)

        self.view.addSubview(playButton)

        muteButton = UIButton(frame: CGRect(x: screenSize.width-75, y: screenSize.height-31, width: 60, height: 19))

        muteButton.setTitle("Mute", for: .normal)

        muteButton.setTitleColor(UIColor.white, for: .normal)

        muteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        muteButton.addTarget(self, action: #selector(self.muteButtonClicked(sender:)), for: .touchUpInside)

        self.view.addSubview(muteButton)

        constrain(playButton) { view in

            guard let superview = view.superview
                else { return }

            view.left == superview.left + 20

            view.bottom == superview.bottom - 12
        }

        constrain(muteButton) { view in

            guard let superview = view.superview
                else { return }

            view.right == superview.right - 16

            view.bottom == superview.bottom - 12
        }

    }

    // MARK: button clicked

    @objc func playButtonClicked(sender: UIButton!) {

        if !isPlaying {

            self.avplayer.play()

            isPlaying = true

            playButton.setTitle("Pause", for: .normal)

            return
        }

        self.avplayer.pause()

        isPlaying = false

        playButton.setTitle("Play", for: .normal)

    }

    @objc func muteButtonClicked(sender: UIButton!) {

        if !avplayer.isMuted {

            avplayer.isMuted = true

            muteButton.setTitle("Unmute", for: .normal)

            return
        }

        avplayer.isMuted = false

        muteButton.setTitle("Mute", for: .normal)

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

        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)

        self.avplayer = AVPlayer(playerItem: playerItem)

        playerLayer = AVPlayerLayer(player: avplayer)

        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect

        playerLayer.contentsScale = UIScreen.main.scale

        self.myPlayerView.playerLayer = self.playerLayer

        self.myPlayerView.layer.insertSublayer(playerLayer, at: 0)
    }

    // MARK: KVO

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        guard let playerItem = object as? AVPlayerItem else { return }

        if keyPath == "status" {

            if playerItem.status == AVPlayerItemStatus.readyToPlay {

                self.avplayer.play()

                isPlaying = true

                playButton.setTitle("Pause", for: .normal)

            } else {

                let alertController = UIAlertController(title: "Video fails to play", message: "", preferredStyle: .alert)

                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                alertController.addAction(defaultAction)

                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
