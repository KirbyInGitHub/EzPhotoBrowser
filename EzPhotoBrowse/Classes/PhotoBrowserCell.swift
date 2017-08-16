//
//  PhotoBrowserCell.swift
//  ezbuy
//
//  Created by 张鹏 on 2017/08/12.
//  Copyright © 2017年 com.ezbuy. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate: NSObjectProtocol {
    /// 视图控制器将要关闭
    func photoBrowserCellShouldDismiss()
    
    /// 通知代理缩放的比例
    func photoBrowserCellDidZoom(_ scale: CGFloat)
}

class PhotoBrowserCell: UICollectionViewCell {
    
    weak var photoDelegate: PhotoBrowserCellDelegate?

    @objc fileprivate func tapImage() {
        photoDelegate?.photoBrowserCellShouldDismiss()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}

    var imageURL: URL? {
        didSet {
            updateCell(with: imageURL)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageURL = nil
    }
    
    fileprivate func updateCell(with url: URL?) {
        
        guard let url = imageURL else { return }
        resetScrollView()
        
        let placeholderImage = SDImageCache.shared().imageFromCache(forKey: url.absoluteString)
        
        setPlaceHolder(placeholderImage)
        
        imageView.sd_setImage(with: url, placeholderImage: nil, options: .retryFailed, progress: { (current, total, _) in
            
            DispatchQueue.main.async {
                self.placeHolder.progress = CGFloat(current) / CGFloat(total)
            }
            
        }) { (image, error, _, _) in
            
            guard let image = image else { return }
            
            self.placeHolder.isHidden = true
            self.setPositon(image)
        }
    }
    
    fileprivate func setPlaceHolder(_ image: UIImage?) {
        
        placeHolder.isHidden = false
        
        placeHolder.image = image
        placeHolder.sizeToFit()
        placeHolder.center = scrollView.center
    }

    fileprivate func resetScrollView() {

        imageView.transform = CGAffineTransform.identity

        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
    }

    fileprivate func setPositon(_ image: UIImage) {

        let size = self.displaySize(image)

        if size.height < scrollView.bounds.height {

            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            let y = (scrollView.bounds.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        } else {
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.contentSize = size
        }
    }

    fileprivate func displaySize(_ image: UIImage) -> CGSize {
        
        let w = scrollView.bounds.width
        let h = image.size.height * w / image.size.width
        
        return CGSize(width: w, height: h)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {

        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(placeHolder)

        var rect = bounds
        rect.size.width -= 20
        scrollView.frame = rect

        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0

        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserCell.tapImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }

    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
    fileprivate lazy var placeHolder: ProgressImageView = ProgressImageView()
}

// MARK: - UIScrollViewDelegate
extension PhotoBrowserCell: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {

        if scale < 1 {
            photoDelegate?.photoBrowserCellShouldDismiss()
            
            return
        }
        
        var offsetY = (scrollView.bounds.height - view!.frame.height) * 0.5
        offsetY = offsetY < 0 ? 0 : offsetY
        
        var offsetX = (scrollView.bounds.width - view!.frame.width) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX

        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {

        photoDelegate?.photoBrowserCellDidZoom(imageView.transform.a)
    }
    
}
