//
//  NoticeBoardVC.swift
//  BrittsImperial
//
//  Created by Khuss on 25/06/24.
//

import UIKit
import SwiftLoader
import QuickLook
import SDWebImage

class NoticeBoardVC: UIViewController {

    @IBOutlet weak var tblNotice: UITableView!
    
    var arrNotices = [NoticeBoardList]()
    
    private var previewItems: [URL] = []
    private var previewIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblNotice.rowHeight = UITableView.automaticDimension
        tblNotice.estimatedRowHeight = 180
        getNoticeBoardListList()
    }
    
    @IBAction func btnBACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NoticeBoardVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeBoardCell") as! NoticeBoardCell
        let obj = arrNotices[indexPath.row]
        cell.setData(obj: obj)
        cell.onMoreTapped = { [weak self] attachment, sourceView in
            self?.presentMoreMenu(for: attachment, sourceView: sourceView)
        }
        cell.onImageTapped = { [weak self] urls, startIndex in
            self?.presentImagePreview(urls: urls, startIndex: startIndex)
        }
        
        return cell
    }
}

extension NoticeBoardVC{
    enum DownloadDestination {
        case documents
        case temporary
    }
    
    func downloadFile(from url: URL, destination: DownloadDestination, completion: @escaping (URL?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { tempLocalUrl, response, error in
            guard let tempLocalUrl = tempLocalUrl, error == nil else {
                completion(nil)
                return
            }

            let fileManager = FileManager.default
            do {
                let savedURL: URL
                switch destination {
                case .documents:
                    let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    savedURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
                case .temporary:
                    let tempDir = fileManager.temporaryDirectory
                    savedURL = tempDir.appendingPathComponent(url.lastPathComponent)
                }
                
                if fileManager.fileExists(atPath: savedURL.path) {
                    try fileManager.removeItem(at: savedURL)
                }
                
                try fileManager.moveItem(at: tempLocalUrl, to: savedURL)
                completion(savedURL)
            } catch {
                print("File saving error: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }
}

extension NoticeBoardVC{
    func presentMoreMenu(for attachment: NoticeBoardCell.Attachment, sourceView: UIView) {
        let sheet = UIAlertController(title: attachment.displayName, message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Open", style: .default, handler: { [weak self] _ in
            self?.downloadFile(from: attachment.url, destination: .temporary) { localURL in
                guard let self, let localURL else { return }
                DispatchQueue.main.async {
                    self.previewItems = [localURL]
                    self.previewIndex = 0
                    let vc = QLPreviewController()
                    vc.dataSource = self
                    vc.currentPreviewItemIndex = 0
                    self.present(vc, animated: true)
                }
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Download", style: .default, handler: { [weak self] _ in
            self?.downloadFile(from: attachment.url, destination: .documents) { savedURL in
                DispatchQueue.main.async {
                    if let savedURL {
                        Toast(text: "Saved: \(savedURL.lastPathComponent)").show()
                    } else {
                        Toast(text: "Download failed").show()
                    }
                }
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Share", style: .default, handler: { [weak self] _ in
            self?.downloadFile(from: attachment.url, destination: .temporary) { localURL in
                guard let self, let localURL else { return }
                DispatchQueue.main.async {
                    let activity = UIActivityViewController(activityItems: [localURL], applicationActivities: nil)
                    if let pop = activity.popoverPresentationController {
                        pop.sourceView = sourceView
                        pop.sourceRect = sourceView.bounds
                    }
                    self.present(activity, animated: true)
                }
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let pop = sheet.popoverPresentationController {
            pop.sourceView = sourceView
            pop.sourceRect = sourceView.bounds
        }
        present(sheet, animated: true)
    }
    
    func getNoticeBoardListList(){
        APIManagerHandler.shared.callSOAPAPI_dis_notice_for_student_for_app(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                do {
                    let responseModel = try JSONDecoder().decode(NoticeBoardModel.self, from: jsonData)
                    if let temp = responseModel.result{
                        self.arrNotices = temp
                    }
                    
                    self.tblNotice.reloadData()
                } catch {
                    print("Error decoding data: \(error)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getRequestXML() -> String{
        let stringParams : String = """
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Header>
            <AuthUser xmlns="http://tempuri.org/">
              <UserName>Admin</UserName>
              <Password>123</Password>
              <Token>College</Token>
            </AuthUser>
          </soap:Header>
          <soap:Body>
         <dis_notice_for_student_for_app xmlns="http://tempuri.org/">
        <course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
        <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
            </dis_notice_for_student_for_app>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}

extension NoticeBoardVC {
    private func presentImagePreview(urls: [URL], startIndex: Int) {
        guard !urls.isEmpty else { return }
        let vc = ImagePreviewVC(imageURLs: urls, startIndex: startIndex)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension NoticeBoardVC: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        previewItems.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        previewItems[index] as NSURL
    }
}

//MARK: ------ UITableViewCell ---------
class NoticeBoardCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnAttach: UIButton!
    @IBOutlet weak var vwAttach: UIView!
    @IBOutlet weak var vwAttachHeight: NSLayoutConstraint!
    @IBOutlet weak var contentStack: UIStackView!
    
    struct Attachment: Hashable {
        let url: URL
        let displayName: String
    }
    
    var onMoreTapped: ((Attachment, UIView) -> Void)?
    var onImageTapped: (([URL], Int) -> Void)?
    
    private var mediaCollectionView: UICollectionView?
    private var mediaHeightConstraint: NSLayoutConstraint?
    private var mediaURLs: [URL] = []
    
    private var filesStackView: UIStackView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        vwAttach.isHidden = true
        setupMediaCarouselIfNeeded()
        setupFilesStackIfNeeded()
    }

    func setData(obj:NoticeBoardList){
        lblTitle.text = obj.title ?? ""
        lblContent.text = obj.desc ?? ""
        
        lblName.text = obj.postBy ?? ""
        lblDate.text = obj.postDate ?? ""
        renderAttachments(fileList: obj.fileList)
    }
}

extension NoticeBoardCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func setupMediaCarouselIfNeeded() {
        guard mediaCollectionView == nil else { return }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = false
        cv.isScrollEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(NoticeMediaCell.self, forCellWithReuseIdentifier: NoticeMediaCell.reuseId)
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(cv)
        
        NSLayoutConstraint.activate([
            cv.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            cv.topAnchor.constraint(equalTo: container.topAnchor),
            cv.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        
        contentStack.insertArrangedSubview(container, at: min(1, contentStack.arrangedSubviews.count))
        let h = container.heightAnchor.constraint(equalToConstant: 0)
        h.isActive = true
        mediaHeightConstraint = h
        
        mediaCollectionView = cv
        container.isHidden = true
    }
    
    private func setupFilesStackIfNeeded() {
        guard filesStackView == nil else { return }
        
        vwAttach.subviews.forEach { $0.removeFromSuperview() }
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        
        vwAttach.backgroundColor = .clear
        vwAttach.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: vwAttach.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: vwAttach.trailingAnchor),
            stack.topAnchor.constraint(equalTo: vwAttach.topAnchor),
            stack.bottomAnchor.constraint(equalTo: vwAttach.bottomAnchor),
        ])
        
        filesStackView = stack
    }
    
    private func renderAttachments(fileList: String?) {
        let urls = Self.parseURLs(fileList)
        let (images, files) = Self.splitImagesAndFiles(urls)
        
        mediaURLs = images
        if let container = mediaCollectionView?.superview {
            if images.isEmpty {
                container.isHidden = true
                mediaHeightConstraint?.constant = 0
            } else {
                container.isHidden = false
                mediaHeightConstraint?.constant = (images.count == 1) ? 180 : 110
                mediaCollectionView?.reloadData()
            }
        }
        
        filesStackView?.arrangedSubviews.forEach { v in
            filesStackView?.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
        
        if files.isEmpty {
            vwAttach.isHidden = true
            vwAttachHeight.constant = 0
        } else {
            vwAttach.isHidden = false
            for (idx, url) in files.enumerated() {
                let row = FileRowView()
                row.translatesAutoresizingMaskIntoConstraints = false
                row.configure(title: url.lastPathComponent)
                row.onMore = { [weak self, weak row] in
                    guard let self, let row else { return }
                    self.onMoreTapped?(Attachment(url: url, displayName: url.lastPathComponent), row.moreButton)
                }
                filesStackView?.addArrangedSubview(row)
                
                if idx < files.count - 1 {
                    let sep = UIView()
                    sep.translatesAutoresizingMaskIntoConstraints = false
                    sep.backgroundColor = UIColor.separator
                    NSLayoutConstraint.activate([
                        sep.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
                    ])
                    filesStackView?.addArrangedSubview(sep)
                }
            }
            let rowHeight: CGFloat = 72
            vwAttachHeight.constant = CGFloat(files.count) * rowHeight + CGFloat(max(0, files.count - 1)) * (1 / UIScreen.main.scale)
        }
    }
    
    static func parseURLs(_ fileList: String?) -> [URL] {
        guard let fileList, !fileList.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return [] }
        return fileList
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap { URL(string: $0) }
    }
    
    static func splitImagesAndFiles(_ urls: [URL]) -> (images: [URL], files: [URL]) {
        let imageExts: Set<String> = ["jpg", "jpeg", "png", "webp", "gif", "heic"]
        var images: [URL] = []
        var files: [URL] = []
        
        for url in urls {
            let ext = url.pathExtension.lowercased()
            if imageExts.contains(ext) {
                images.append(url)
            } else {
                files.append(url)
            }
        }
        return (images, files)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let c = mediaURLs.count
        if c <= 2 { return c }
        return min(3, c)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeMediaCell.reuseId, for: indexPath) as! NoticeMediaCell
        let total = mediaURLs.count
        let item = indexPath.item
        let shouldShowPlus = (item == 2 && total > 3)
        cell.setURL(mediaURLs[item], plusCount: shouldShowPlus ? (total - 3) : nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = mediaURLs.count
        let spacing: CGFloat = 8
        
        if count == 1 {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }
        
        if count == 2 {
            let w = max(0, (collectionView.bounds.width - spacing) / 2)
            return CGSize(width: w, height: collectionView.bounds.height)
        }
        
        let totalSpacing = spacing * 2
        let w = max(0, (collectionView.bounds.width - totalSpacing) / 3)
        return CGSize(width: w, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onImageTapped?(mediaURLs, indexPath.item)
    }
}

final class NoticeMediaCell: UICollectionViewCell {
    static let reuseId = "NoticeMediaCell"
    private let imageView = UIImageView()
    private let overlayView = UIView()
    private let overlayLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        overlayView.isHidden = true
        
        overlayLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayLabel.textColor = .white
        overlayLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        overlayView.addSubview(overlayLabel)
        contentView.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            overlayLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            overlayLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
        ])
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setURL(_ url: URL, plusCount: Int?) {
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "img_placeholder"), options: [.continueInBackground], completed: nil)
        if let plusCount, plusCount > 0 {
            overlayLabel.text = "+\(plusCount)"
            overlayView.isHidden = false
        } else {
            overlayView.isHidden = true
            overlayLabel.text = nil
        }
    }
}

final class FileRowView: UIView {
    private let iconContainer = UIView()
    private let iconImage = UIImageView()
    private let extBadge = UILabel()
    
    private let titleLabel = UILabel()
    private let extLabel = UILabel()
    
    let moreButton = UIButton(type: .system)
    var onMore: (() -> Void)?
    
    private var badgeWidthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.backgroundColor = UIColor.secondarySystemBackground
        iconContainer.layer.cornerRadius = 10
        iconContainer.clipsToBounds = true
        
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.contentMode = .scaleAspectFit
        iconImage.tintColor = .secondaryLabel
        iconImage.image = UIImage(systemName: "doc.text") ?? UIImage(named: "attach-file")
        
        extBadge.translatesAutoresizingMaskIntoConstraints = false
        extBadge.textAlignment = .center
        extBadge.textColor = .white
        extBadge.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        extBadge.layer.cornerRadius = 4
        extBadge.clipsToBounds = true
        extBadge.text = ""
        extBadge.backgroundColor = .systemGray
        
        iconContainer.addSubview(iconImage)
        iconContainer.addSubview(extBadge)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        
        extLabel.translatesAutoresizingMaskIntoConstraints = false
        extLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        extLabel.textColor = .secondaryLabel
        extLabel.numberOfLines = 1
        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        if let img = UIImage(systemName: "ellipsis") {
            moreButton.setImage(img, for: .normal)
            moreButton.tintColor = .secondaryLabel
        } else {
            moreButton.setTitle("More", for: .normal)
        }
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        
        addSubview(iconContainer)
        addSubview(titleLabel)
        addSubview(extLabel)
        addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 72),
            
            iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 44),
            iconContainer.heightAnchor.constraint(equalToConstant: 44),
            
            iconImage.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImage.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: 22),
            iconImage.heightAnchor.constraint(equalToConstant: 22),
            
            extBadge.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor, constant: 4),
            extBadge.topAnchor.constraint(equalTo: iconContainer.topAnchor, constant: 4),
            extBadge.heightAnchor.constraint(equalToConstant: 16),
            
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 32),
            moreButton.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: iconContainer.topAnchor, constant: 4),
            
            extLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            extLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: -8),
            extLabel.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: -4),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
        
        let ext = (title as NSString).pathExtension.uppercased()
        extLabel.text = ext.isEmpty ? nil : ext
        extBadge.text = ext.isEmpty ? "" : ext
        
        extBadge.backgroundColor = Self.colorForExtension(ext.lowercased())
        iconImage.image = Self.symbolForExtension(ext.lowercased())
        
        badgeWidthConstraint?.isActive = false
        let badgeWidth = max(28, min(36, 8 + CGFloat(ext.count) * 7))
        let w = extBadge.widthAnchor.constraint(equalToConstant: badgeWidth)
        w.isActive = true
        badgeWidthConstraint = w
    }
    
    @objc private func moreTapped() {
        onMore?()
    }
    
    private static func symbolForExtension(_ ext: String) -> UIImage? {
        switch ext {
        case "pdf":
            return UIImage(systemName: "doc.richtext") ?? UIImage(systemName: "doc.text")
        case "doc", "docx", "rtf":
            return UIImage(systemName: "doc.text") ?? UIImage(systemName: "doc")
        case "xls", "xlsx", "csv":
            return UIImage(systemName: "tablecells") ?? UIImage(systemName: "tablecells.fill")
        case "ppt", "pptx":
            return UIImage(systemName: "rectangle.3.group") ?? UIImage(systemName: "rectangle.3.group.fill")
        case "zip", "rar", "7z":
            return UIImage(systemName: "doc.zipper") ?? UIImage(systemName: "archivebox")
        case "png", "jpg", "jpeg", "gif", "webp", "heic":
            return UIImage(systemName: "photo") ?? UIImage(systemName: "photo.fill")
        default:
            return UIImage(systemName: "doc") ?? UIImage(systemName: "doc.text")
        }
    }
    
    private static func colorForExtension(_ ext: String) -> UIColor {
        switch ext {
        case "pdf": return .systemRed
        case "doc", "docx", "rtf": return .systemBlue
        case "xls", "xlsx", "csv": return .systemGreen
        case "ppt", "pptx": return .systemOrange
        case "zip", "rar", "7z": return .systemPurple
        default: return .systemGray
        }
    }
}

final class ImagePreviewVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let imageURLs: [URL]
    private let startIndex: Int
    private var collectionView: UICollectionView!
    
    init(imageURLs: [URL], startIndex: Int) {
        self.imageURLs = imageURLs
        self.startIndex = max(0, min(startIndex, imageURLs.count - 1))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .black
        cv.dataSource = self
        cv.delegate = self
        cv.register(PreviewImageCell.self, forCellWithReuseIdentifier: PreviewImageCell.reuseId)
        view.addSubview(cv)
        NSLayoutConstraint.activate([
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cv.topAnchor.constraint(equalTo: view.topAnchor),
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        collectionView = cv
        
        let close = UIButton(type: .system)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.tintColor = .white
        close.setImage(UIImage(systemName: "xmark"), for: .normal)
        close.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        close.layer.cornerRadius = 16
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(close)
        NSLayoutConstraint.activate([
            close.widthAnchor.constraint(equalToConstant: 32),
            close.heightAnchor.constraint(equalToConstant: 32),
            close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            close.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if collectionView.contentOffset.x == 0, startIndex > 0 {
            collectionView.setContentOffset(CGPoint(x: collectionView.bounds.width * CGFloat(startIndex), y: 0), animated: false)
        }
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewImageCell.reuseId, for: indexPath) as! PreviewImageCell
        cell.setURL(imageURLs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

final class PreviewImageCell: UICollectionViewCell {
    static let reuseId = "PreviewImageCell"
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setURL(_ url: URL) {
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "img_placeholder"), options: [.continueInBackground], completed: nil)
    }
}
