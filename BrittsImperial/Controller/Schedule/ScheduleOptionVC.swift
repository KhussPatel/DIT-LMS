//
//  ScheduleOptionVC.swift
//  BrittsImperial
//
//  Created by Khuss on 26/10/23.
//

import UIKit

class ScheduleOptionVC: UIViewController {

    @IBOutlet weak var collScheduleOption: UICollectionView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    var arrStatic = [["title":"Assignment","img":"ic_assignment"],["title":"Course Resource","img":"ic_course_resource"],["title":"Video","img":"ic_video_unit"]]
    
    var unitCode = ""
    var unitTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeaderTitle.text = unitTitle
    }
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ScheduleOptionVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrStatic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ScheduleOptionCell
        cell.lbltitle.text = arrStatic[indexPath.row]["title"]
        cell.imgIcon.image = UIImage(named: arrStatic[indexPath.row]["img"]!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 2  //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "CourseVC") as! CourseVC
            next.type = "Assignment" //Assignment, Cource
            next.unitCode = unitCode
            next.unitTitle = unitTitle
            self.navigationController?.pushViewController(next, animated: true)
        }else if indexPath.row == 1{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "CourseVC") as! CourseVC
            next.type = "Cource" //Assignment, Cource
            next.unitCode = unitCode
            next.unitTitle = unitTitle
            self.navigationController?.pushViewController(next, animated: true)
        }else{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "VideoGallaryVC") as! VideoGallaryVC
            next.unitCode = unitCode
            next.unitTitle = unitTitle
            self.navigationController?.pushViewController(next, animated: true)
        }
    }

}
