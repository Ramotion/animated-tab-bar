import Foundation
import UIKit


final class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        view.addGestureRecognizer(recognizer)
    }
    
    @objc func tapHandler() {
        let vc = NextViewController()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, animated: true)
    }
}
