//
//  WallPostCell.swift
//  BrittsImperial
//
//  Created by Khuss on 26/06/24.
//

import UIKit
import SDWebImage


class WallPostCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var lblMoreImg: UILabel!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if img1 != nil{
            img1.contentMode = .scaleAspectFill
            img1.clipsToBounds = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if img1 != nil{
            img1.image = nil
        }
        
    }

    func configureOnlyImage(with image: UIImage?) {
        guard let image = image else { return }
        img1.image = image
        // Adjust the height of the image view based on the aspect ratio of the image
        let aspectRatio = image.size.height / image.size.width
        imageViewHeightConstraint.constant = img1.frame.width * aspectRatio
    }
    
    func config2Img(arrUrl:[URL]){
        //img2.sd_setImage(with: arrUrl[0]) { weak  (image, error, cacheType, url) in
            img2.sd_setImage(with: arrUrl[0], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
        
        img3.sd_setImage(with: arrUrl[1], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
        
    }
    
    func config3Img(arrUrl:[URL]){
        //img2.sd_setImage(with: arrUrl[0]) { weak  (image, error, cacheType, url) in
            img2.sd_setImage(with: arrUrl[0], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
        
        img3.sd_setImage(with: arrUrl[1], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
        
        img4.sd_setImage(with: arrUrl[2], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
    }
    
    
    func config4Img(arrUrl:[URL]){
        //img2.sd_setImage(with: arrUrl[0]) { weak  (image, error, cacheType, url) in
            img2.sd_setImage(with: arrUrl[0], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
        
        img3.sd_setImage(with: arrUrl[1], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
        
        img4.sd_setImage(with: arrUrl[2], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
        
        img5.sd_setImage(with: arrUrl[3], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
    }
    
    func config5Img(arrUrl:[URL], imgcount: Int){
        //img2.sd_setImage(with: arrUrl[0]) { weak  (image, error, cacheType, url) in
            img2.sd_setImage(with: arrUrl[0], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
        
        img3.sd_setImage(with: arrUrl[1], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
        
        img4.sd_setImage(with: arrUrl[2], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
        
        img5.sd_setImage(with: arrUrl[3], placeholderImage: UIImage(named: "img_placeholder"), options:.continueInBackground, completed: nil)
        
        lblMoreImg.text = "+\(imgcount)"
    }
    


}





import UIKit

class WallPostDocCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    var documentLinks: [URL] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupStackView()
    }
    
    private func setupStackView() {
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fill
        buttonStackView.alignment = .fill
        buttonStackView.spacing = 0
    }
    
    func configureDocs(with links: [URL]) {
        documentLinks = links
        
        // Remove all existing buttons and separators
        for subview in buttonStackView.arrangedSubviews {
            buttonStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Add buttons with separators
        for (index, link) in links.enumerated() {
            let button = createButton(for: link, at: index)
            buttonStackView.addArrangedSubview(button)
            
            if index < links.count - 1 {
                let separator = createSeparator()
                buttonStackView.addArrangedSubview(separator)
            }
        }
    }
    
    private func createButton(for link: URL, at index: Int) -> UIButton {
        let button = UIButton(type: .system)
        
        // Extract the filename from the URL
        if let filename = link.pathComponents.last {
            button.setTitle(filename, for: .normal)
        }

        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left // Set text alignment to left
        button.tag = index
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true // Set button height to 40
        
        return button
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .lightGray // Set the color of the separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1) // Set the height of the separator
        ])
        return separator
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let link = documentLinks[sender.tag]
        UIApplication.shared.open(link)
    }
}
