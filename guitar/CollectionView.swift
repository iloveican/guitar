//
//  CollectionView.swift
//  guitar
//
//  Created by lazycal on 2017/5/25.
//  Copyright © 2017年 lazycal. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {
    var validTouches = [UITouch]()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //MARK: Gesture
//    func updateNotes() {
//        for touch in validTouches {
//            self.controll
//        }
//    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesBegan")
//        print(touches.count)
//        for touch in touches {
//            let position = touch.location(in: self)
//            print(position)
//        }
//        validTouches.append(contentsOf: touches)
//        updateNotes()
//        super.touchesBegan(touches, with: event)
//    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesMoved:")
//        print(touches.count)
//        updateNotes()
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesEnded:")
//        print(touches.count)
//        for touch in touches {
//            validTouches.remove(at: validTouches.index(of: touch)!)
//        }
//        updateNotes()
//    }
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesCancelled:")
//        print(touches.count)
//        for touch in touches {
//            validTouches.remove(at: validTouches.index(of: touch)!)
//        }
//        updateNotes()
//    }
}
