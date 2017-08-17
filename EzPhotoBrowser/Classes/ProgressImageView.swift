//
//  ProgressImageView.swift
//  ezbuy
//
//  Created by 张鹏 on 2017/08/12.
//  Copyright © 2017年 com.ezbuy. All rights reserved.
//

import UIKit

class ProgressImageView: UIImageView {

    var progress: CGFloat = 0 {
        didSet {
            progressView.progress = progress
        }
    }

    init() {
        super.init(frame: CGRect.zero)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        addSubview(progressView)
        progressView.backgroundColor = UIColor.clear
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[progressView]|", options: [], metrics: nil, views: ["progressView":progressView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[progressView]|", options: [], metrics: nil, views: ["progressView":progressView]))
    }

    fileprivate lazy var progressView: ProgressView = ProgressView()
}

private class ProgressView: UIView {

    fileprivate var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let r = min(rect.width, rect.height) * 0.5
        let start = CGFloat(-Double.pi / 2)
        let end = start + progress * 2 * CGFloat(Double.pi)
        
        let path = UIBezierPath(arcCenter: center, radius: r, startAngle: start, endAngle: end, clockwise: true)

        path.addLine(to: center)
        path.close()
        
        UIColor(white: 1.0, alpha: 0.3).setFill()
        
        path.fill()
    }
}
