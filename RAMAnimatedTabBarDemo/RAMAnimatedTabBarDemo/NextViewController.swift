import Foundation
import UIKit


final class NextViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        view.addGestureRecognizer(recognizer)
    }
    
    @objc func tapHandler() {
        self.navigationController?.popViewController(animated: true)
    }
}
