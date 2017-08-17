//
//  CollectionViewController.swift
//  TransitionAnimators
//
//  Created by 张鹏 on 2017/7/2.
//  Copyright © 2017年 大白菜. All rights reserved.
//

import UIKit
import SDWebImage
import EzPhotoBrowse

class CollectionViewController: UICollectionViewController {
    
    fileprivate lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    fileprivate var urlsString: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlsString = ["http://pic62.nipic.com/file/20150319/12632424_132215178296_2.jpg", "http://img06.tooopen.com/images/20160712/tooopen_sy_170083325566.jpg"]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlsString.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let url = urlsString[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        let imageView = cell.viewWithTag(501) as? UIImageView
        
        imageView?.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .highPriority, completed: { (image, _, type, _) in
            //            if type == .none {
            //                self?.collectionView?.reloadData()
            //            }
        })
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let urls = urlsString.flatMap {URL(string: $0)}
        
        let vc = PhotoBrowserViewController(urls: urls, index: indexPath.row)
        vc.delegate = self

        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self.photoBrowserAnimator

        self.present(vc, animated: true, completion: nil)
    }

}

extension CollectionViewController: PhotoBrowserViewControllerDelegate {
    
    func photoBrowserSourceRect(index: Int) -> CGRect {
        
        let indexPath = IndexPath(row: index, section: 0)
        
        let cell = collectionView?.cellForItem(at: indexPath)
        
        return self.collectionView!.convert(cell!.frame, to: UIApplication.shared.keyWindow!)
    }

}
