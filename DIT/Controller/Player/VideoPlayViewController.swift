//
//  VideoPlayViewController.swift
//  BMPlayer
//
//  Created by BrikerMan on 16/4/28.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import BMPlayer
import AVFoundation
import NVActivityIndicatorView

func delay(_ seconds: Double, completion:@escaping ()->()) {
  let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
  
  DispatchQueue.main.asyncAfter(deadline: popTime) {
    completion()
  }
}

class VideoPlayViewController: UIViewController {
  
      @IBOutlet weak var vwPlayer: UIView!
  
  var player: BMPlayer!
  
    var videoUrl = ""
    var videoName = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPlayerManager()
    preparePlayer()
    setupPlayerResource()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(applicationDidEnterBackground),
                                           name: UIApplication.didEnterBackgroundNotification,
                                           object: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(applicationWillEnterForeground),
                                           name: UIApplication.willEnterForegroundNotification,
                                           object: nil)
  }
  
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
  @objc func applicationWillEnterForeground() {
    
  }
  
  @objc func applicationDidEnterBackground() {
    player.pause(allowAutoPlay: false)
  }
  
  /**
   prepare playerView
   */
  func preparePlayer() {
      var controller: BMPlayerControlView? = nil
      
      controller = BMPlayerCustomControlView()
      
      
      player = BMPlayer(customControlView: controller)
      //view.addSubview(player)
      vwPlayer.addSubview(player)
      
      player.snp.makeConstraints { (make) in
          make.top.equalTo(view.snp.top)
          make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
    }
    
    player.delegate = self
    player.backBlock = { [unowned self] (isFullScreen) in
      if isFullScreen {
        return
      } else {
        let _ = self.navigationController?.popViewController(animated: true)
      }
    }
  
  }
  
  
  func setupPlayerResource() {
      
      let url = URL(string: "https://www.youtube.com/watch?v=1iR7Vp8FjVQ")!
      
     
      
      let asset = BMPlayerResource(name: "Video Name Here",
                                   definitions: [BMPlayerResourceDefinition(url: url, definition: "480p")],
                                   cover: nil)
  }
  
  // 设置播放器单例，修改属性
  func setupPlayerManager() {
    resetPlayerManager()
        
      BMPlayerConf.topBarShowInCase = .none
   
    
  }
  
 
  
  func resetPlayerManager() {
    BMPlayerConf.allowLog = false
    BMPlayerConf.shouldAutoPlay = true
    BMPlayerConf.tintColor = UIColor.white
    BMPlayerConf.topBarShowInCase = .always
    BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
    // If use the slide to back, remember to call this method
    // 使用手势返回的时候，调用下面方法
    player.pause(allowAutoPlay: true)
  }
  
  
  
  deinit {
    // If use the slide to back, remember to call this method
    // 使用手势返回的时候，调用下面方法手动销毁
    player.prepareToDealloc()
    print("VideoPlayViewController Deinit")
  }
  
}

// MARK:- BMPlayerDelegate example
extension VideoPlayViewController: BMPlayerDelegate {
  // Call when player orinet changed
  func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
    player.snp.remakeConstraints { (make) in
      make.top.equalTo(view.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      if isFullscreen {
        make.bottom.equalTo(view.snp.bottom)
      } else {
        make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
      }
    }
  }
  
  // Call back when playing state changed, use to detect is playing or not
  func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
    print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
  }
  
  // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
  func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
    print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
  }
  
  // Call back when play time change
  func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
    //        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
  }
  
  // Call back when the video loaded duration changed
  func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
    //        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
  }
}
