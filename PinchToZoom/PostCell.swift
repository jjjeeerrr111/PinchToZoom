//
//  PostCell.swift
//  PinchToZoom
//
//  Created by Jeremy Sharvit on 2017-08-26.
//  Copyright © 2017 com.zoom. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    var postImage:UIImageView!
    var caption:UILabel!
    var isZooming = false
    var originalImageCenter:CGPoint?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        //Important!!!!!!
        self.clipsToBounds = false
        self.selectionStyle = .none
        setUpView()
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        pinch.delegate = self
        self.postImage.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
        pan.delegate = self
        self.postImage.addGestureRecognizer(pan)
    
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pan(sender: UIPanGestureRecognizer) {
        if self.isZooming && sender.state == .began {
            self.originalImageCenter = sender.view?.center
        } else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: self)
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.postImage.superview)
        }
    }
    
    func pinch(sender:UIPinchGestureRecognizer) {
        
        if sender.state == .began {
            let currentScale = self.postImage.frame.size.width / self.postImage.bounds.size.width
            let newScale = currentScale*sender.scale
            
            if newScale > 1 {
                self.isZooming = true
            }
        } else if sender.state == .changed {
            
            guard let view = sender.view else {return}
            
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            
            let currentScale = self.postImage.frame.size.width / self.postImage.bounds.size.width
            var newScale = currentScale*sender.scale
            
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.postImage.transform = transform
                sender.scale = 1
            }else {
                view.transform = transform
                sender.scale = 1
            }
            
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            
            guard let center = self.originalImageCenter else {return}
            
            UIView.animate(withDuration: 0.3, animations: {
                self.postImage.transform = CGAffineTransform.identity
                self.postImage.center = center
            }, completion: { _ in
                self.isZooming = false
            })
        }
        
    }
    
    func setUpView() {
        postImage = UIImageView()
        postImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(postImage)
        
        caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(caption)
        
        let const:[NSLayoutConstraint] = [
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImage.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            caption.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 8),
            caption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            caption.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            caption.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,constant: -8)
        ]
        NSLayoutConstraint.activate(const)
        
        postImage.image = #imageLiteral(resourceName: "Rep")
        postImage.contentMode = .scaleAspectFill
        //Important steps:
        postImage.isUserInteractionEnabled = true
        
        caption.numberOfLines = 0
        caption.font = UIFont.boldSystemFont(ofSize: 18)
        caption.layer.zPosition = -1
    }
}
