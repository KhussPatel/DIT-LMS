//
//  WallPostDetailsVC.swift
//  BrittsImperial
//
//  Created by Khuss on 06/07/24.
//

import UIKit

class WallPostDetailsVC: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {

    var arrWallPost = [WallPostList]()
    
    var fileList = [URL]()
    
    @IBOutlet weak var vwPager: FSPagerView!{
        didSet {
            self.vwPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vwPager.dataSource = self
        vwPager.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func btnBACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return fileList.count
    }
        
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.isHighlighted = false
        
        let uurl = fileList[index]
        cell.imageView?.sd_setImage(with: uurl, placeholderImage: UIImage(named: "img_placeholder"))
        return cell
    }
}
