//
//  NoDataView.swift
//  BrittsImperial
//
//  Created by Khuss on 20/07/24.
//

import Foundation
import UIKit

class CustomView: UIView {
    
    private let imageView: UIImageView
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
    
    func configure(with image: UIImage?) {
        if let image = image {
            imageView.image = image
        } else {
            imageView.image = UIImage(named: "No-Data-Found-Image") // Ensure you have a placeholder image named "no_data_found"
        }
    }
}

//extension UITableView {
//
//    private struct AssociatedKeys {
//        static var noDataView: CustomView?
//    }
//
//    private var noDataView: CustomView? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.noDataView) as? CustomView
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.noDataView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    func showNoDataView(withImage image: UIImage?) {
//        if noDataView == nil {
//            noDataView = CustomView()
//            self.addSubview(noDataView!)
//        }
//        noDataView?.configure(with: image)
//        updateNoDataViewPosition()
//        noDataView?.isHidden = false
//    }
//
//    func hideNoDataView() {
//        noDataView?.isHidden = true
//    }
//
//    func reloadDataWithEmptyCheck() {
//        self.reloadData()
//        let isEmpty = self.numberOfSections == 0 || (self.numberOfSections > 0 && self.numberOfRows(inSection: 0) == 0)
//        if isEmpty {
//            showNoDataView(withImage: UIImage(named: "No-Data-Found-Image"))
//        } else {
//            hideNoDataView()
//        }
//    }
//    
//    // Update the position of noDataView to ensure it's centered
//    private func updateNoDataViewPosition() {
//        if let noDataView = noDataView {
//            noDataView.frame.size = CGSize(width: 300, height: 200)
//            noDataView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
//        }
//    }
//    
//    // Override layoutSubviews to update the position of noDataView when layout changes
//    override open func layoutSubviews() {
//        super.layoutSubviews()
//        updateNoDataViewPosition()
//    }
//}


//extension UITableView {
//
//    private struct AssociatedKeys {
//        static var noDataView: CustomView?
//    }
//
//    private var noDataView: CustomView? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.noDataView) as? CustomView
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.noDataView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    func showNoDataView(withImage image: UIImage?) {
//        if noDataView == nil {
//            noDataView = CustomView()
//            noDataView?.center = self.center
//            self.addSubview(noDataView!)
//        }
//        noDataView?.configure(with: image)
//        noDataView?.isHidden = false
//    }
//
//    func hideNoDataView() {
//        noDataView?.isHidden = true
//    }
//
//    func reloadDataWithEmptyCheck() {
//        self.reloadData()
//        let isEmpty = self.numberOfSections == 0 || (self.numberOfSections > 0 && self.numberOfRows(inSection: 0) == 0)
//        if isEmpty {
//            showNoDataView(withImage: UIImage(named: "No-Data-Found-Image")) // You can pass nil or a specific image if needed
//        } else {
//            hideNoDataView()
//        }
//    }
//}
