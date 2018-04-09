//
//  SDNavBar.swift
//  SDPhotoBrowser
//
//  Created by Sunny on 2017/3/13.
//  Copyright © 2017年 Sunny. All rights reserved.
//

import UIKit

class SDNavBar: UIView {
    
    // Default Setup Back Image
    var leftOneButton: UIButton!
    var leftTwoButton: UIButton!
    var rightOneButton: UIButton!
    var rightTwoButton: UIButton!
    
    var letfOneButtonClosure: (() -> Void)?
    var letfTwoButtonClosure: (() -> Void)?
    var rightOneButtonClosure: (() -> Void)?
    var rightTwoButtonClosure: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        addAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK:- Private Methods
extension SDNavBar {
    
    func setupUI() {
    
        autoresizingMask = []
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        
        leftOneButton = UIButton(type: .custom)
        leftOneButton.translatesAutoresizingMaskIntoConstraints = false
        leftOneButton.setImage(UIImage.sd_resource(named: "nav_Back"), for: .normal)
        addSubview(leftOneButton)
        
        leftTwoButton = UIButton(type: .custom)
        leftTwoButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftTwoButton)
        
        rightOneButton = UIButton(type: .custom)
        rightOneButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightOneButton)
        
        rightTwoButton = UIButton(type: .custom)
        rightTwoButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightTwoButton)
        
        addConstraint(NSLayoutConstraint(item: leftOneButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: leftOneButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftOneButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44))
        addConstraint(NSLayoutConstraint(item: leftOneButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44))
        
        addConstraint(NSLayoutConstraint(item: leftTwoButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: leftTwoButton, attribute: .left, relatedBy: .equal, toItem: self.leftOneButton, attribute: .right, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: leftTwoButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44))
        addConstraint(NSLayoutConstraint(item: leftTwoButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44))
        
        addConstraint(NSLayoutConstraint(item: rightOneButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: rightOneButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: rightOneButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44))
        addConstraint(NSLayoutConstraint(item: rightOneButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44))

        addConstraint(NSLayoutConstraint(item: rightTwoButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: rightTwoButton, attribute: .right, relatedBy: .equal, toItem: self.rightOneButton, attribute: .left, multiplier: 1.0, constant: -10))
        addConstraint(NSLayoutConstraint(item: rightTwoButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44))
        addConstraint(NSLayoutConstraint(item: rightTwoButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44))
    }
    
    func addAction() {
        
        leftOneButton.addTarget(self, action: #selector(handleLeftOneButtonTapped(sender:)), for: .touchUpInside)
    
        leftTwoButton.addTarget(self, action: #selector(handleLeftTwoButtonTapped(sender:)), for: .touchUpInside)
        
        rightOneButton.addTarget(self, action: #selector(handleRightOneButtonTapped(sender:)), for: .touchUpInside)
        
        rightTwoButton.addTarget(self, action: #selector(handleRightTwoButtonTapped(sender:)), for: .touchUpInside)
    }
    
    func handleLeftOneButtonTapped(sender: UIButton) {
        letfOneButtonClosure?()
    }
    
    func handleLeftTwoButtonTapped(sender: UIButton) {
        letfTwoButtonClosure?()
    }
    
    func handleRightOneButtonTapped(sender: UIButton) {
        rightOneButtonClosure?()
    }
    
    func handleRightTwoButtonTapped(sender: UIButton) {
        rightTwoButtonClosure?()
    }

}


