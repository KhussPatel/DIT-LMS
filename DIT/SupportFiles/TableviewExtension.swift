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
