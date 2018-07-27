// Copyright (c) 03/05/2018. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit

extension RAMAnimatedTabBarController {
    
    func createBottomLine() {
        guard let currentItem = (containers.filter { $0.value.tag == 0 }).first?.value else { return }

        let lineHeight: CGFloat = 2
        
        let container = UIView()
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(container)
        
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true
        
        
        let line = UIView()
        line.backgroundColor = bottomLineColor
        line.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(line)
        bottomLine = line
        
        lineLeadingConstraint = bottomLine?.leadingAnchor.constraint(equalTo: currentItem.leadingAnchor)
        lineLeadingConstraint?.isActive = true

        // add constraints
        bottomLine?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomLine?.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true
        bottomLine?.widthAnchor.constraint(equalTo: currentItem.widthAnchor).isActive = true
    }
    
    func removeBottomLine() {
        guard let bottomLine = self.bottomLine else { return }

        bottomLine.superview?.removeFromSuperview()
        self.bottomLine = nil
        lineLeadingConstraint?.isActive = false
        lineLeadingConstraint = nil
    }
    
    func setBottomLinePosition(index: Int, animated: Bool = true) {
        guard let itemsCount = tabBar.items?.count, itemsCount > index,
        let currentItem = (containers.filter { $0.value.tag == index}).first?.value else { return }
        
        lineLeadingConstraint?.isActive = false
        
        lineLeadingConstraint = bottomLine?.leadingAnchor.constraint(equalTo: currentItem.leadingAnchor)
        lineLeadingConstraint?.isActive = true
        
        if animated {
            UIView.animate(withDuration: bottomLineMoveDuration) { self.bottomLine?.superview?.layoutIfNeeded() }
        } else {
            self.bottomLine?.superview?.layoutIfNeeded()
        }
    }
}
