//
//  TableviewExtension.swift
//  BrittsImperial
//
//  Created by Khuss on 29/06/24.
//

import Foundation
import UIKit

//public class DynamicSizeTableView: UITableView
//{
//    override public func layoutSubviews() {
//        super.layoutSubviews()
//        if bounds.size != intrinsicContentSize {
//            invalidateIntrinsicContentSize()
//        }
//    }
//
//    public override func reloadData() {
//        super.reloadData()
//    }
//
//    override public var intrinsicContentSize: CGSize {
//        return contentSize
//    }
//}


//public class SelfSizingTableView: UITableView {
//    var maxHeight = CGFloat.infinity
//
//    public override var contentSize: CGSize {
//        didSet {
//            invalidateIntrinsicContentSize()
//            setNeedsLayout()
//        }
//    }
//
//    public override var intrinsicContentSize: CGSize {
//        let height = min(maxHeight, contentSize.height)
//        return CGSize(width: contentSize.width, height: height)
//    }
//}

import UIKit

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

public class SelfSizingTableView: UITableView {

    var maxHeight = CGFloat.infinity

    public override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    public override var intrinsicContentSize: CGSize {
        let height = min(maxHeight, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}
