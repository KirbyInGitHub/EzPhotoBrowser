//
//  PhotoBrowserViewController.swift
//  ezbuy
//
//  Created by 张鹏 on 2017/08/12.
//  Copyright © 2017年 com.ezbuy. All rights reserved.
//

import UIKit
import SDWebImage

private let PhotoBrowserViewCell = "PhotoBrowserViewCell"

/// 照片浏览器
public class PhotoBrowserViewController: UIViewController {

    /// 照片 URL 数组
    fileprivate let urls: [URL]
    /// 当前选中的照片索引
    fileprivate let index: Int
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

    @objc func savedPhotoToAlbum() {
        
        guard let cell = collectionView.visibleCells.objectAtIndex(0) as? PhotoBrowserCell,
            let image = cell.imageView.image else {
            return
        }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc fileprivate func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
        
        //TODO: tip
    }

    public init(urls: [URL], index: Int) {
        self.urls = urls
        self.index = index

        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {

        var rect = UIScreen.main.bounds
        rect.size.width += 20
        
        view = UIView(frame: rect)
        view.backgroundColor = UIColor.black

        setupUI()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }

    internal lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserViewLayout())
    
    fileprivate lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.darkGray
        
        return button
    }()

    fileprivate class PhotoBrowserViewLayout: UICollectionViewFlowLayout {
        
        fileprivate override func prepare() {
            super.prepare()
            
            itemSize = collectionView!.bounds.size
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            scrollDirection = .horizontal
            
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}


extension PhotoBrowserViewController {
    
    public func imageViewForPresent(index: Int) -> UIImageView {
        
        let url = self.urls.objectAtIndex(index)
        
        let image = SDImageCache.shared().imageFromCache(forKey: url?.absoluteString)
        
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.image = image
        
        return iv
    }
}

// MARK: - 设置 UI
private extension PhotoBrowserViewController {
    
    func setupUI() {

        view.addSubview(collectionView)
        view.addSubview(saveButton)

        collectionView.frame = view.bounds
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[saveButton]-16-|", options: .alignAllBottom, metrics: nil, views: ["saveButton": saveButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[saveButton]", options: .alignAllLeft, metrics: nil, views: ["saveButton": saveButton]))

        saveButton.addTarget(self, action: #selector(PhotoBrowserViewController.savedPhotoToAlbum), for: .touchUpInside)

        prepareCollectionView()
    }

    func prepareCollectionView() {

        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoBrowserViewCell)
        collectionView.dataSource = self
    }
}

extension PhotoBrowserViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserViewCell, for: indexPath) as! PhotoBrowserCell
        
        cell.imageURL = urls.objectAtIndex(indexPath.row)
        cell.photoDelegate = self
        
        return cell
    }
}

extension PhotoBrowserViewController: PhotoBrowserCellDelegate {
    
    func photoBrowserCellShouldDismiss() {
        close()
    }
    
    func photoBrowserCellDidZoom(_ scale: CGFloat) {
        
        let isHidden = (scale < 1)
        hideControls(isHidden)
        
        if isHidden {
            view.alpha = scale
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        } else {
            view.alpha = 1.0
            view.transform = CGAffineTransform.identity
        }
    }

    fileprivate func hideControls(_ isHidden: Bool) {
        saveButton.isHidden = isHidden
        collectionView.backgroundColor = isHidden ? UIColor.clear : UIColor.black
    }
}

extension PhotoBrowserViewController: PhotoBrowserDismissDelegate {

    public func imageViewForDismiss() -> UIImageView {
        
        guard let cell = collectionView.visibleCells.objectAtIndex(0) as? PhotoBrowserCell else {
            return UIImageView()
        }
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.image = cell.imageView.image

        iv.frame = cell.scrollView.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow!)

        return iv
    }
    
    public func indexForDismiss() -> Int {
        return collectionView.indexPathsForVisibleItems.objectAtIndex(0)?.row ?? 0
    }
}

extension Array {
    
    internal func objectAtIndex(_ index: Int) -> Element? {
        guard self.range.contains(index) else { return nil }
        
        return self[index]
    }
    
    private var range: CountableRange<Int> {
        return 0..<self.count
    }
}
