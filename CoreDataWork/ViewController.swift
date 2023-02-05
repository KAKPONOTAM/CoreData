import UIKit
import CoreData

final class ViewController: UIViewController {
    private let label = UILabel()
    private let secondLabel = UILabel()
    private let textField = UITextField()
    private let coreDataManager = CoreDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        label.textAlignment = .center
        secondLabel.textAlignment = .center
        
        label.frame = CGRect(x: .zero, y: 20, width: view.frame.width, height: view.frame.height / 10)
        secondLabel.frame = CGRect(x: .zero, y: view.frame.height / 5, width: view.frame.width, height: view.frame.height / 10)
        textField.frame = CGRect(x: .zero, y: view.frame.height / 2, width: view.frame.width, height: view.frame.height / 10)
        textField.placeholder = "Введите имя"
        textField.textAlignment = .center
        textField.delegate = self
        
        view.addSubview(label)
        view.addSubview(secondLabel)
        view.addSubview(textField)
        
        let user = coreDataManager.retrieveMainUser()
        label.text = user.name ?? "" + (user.company?.name ?? "")
        secondLabel.text = String(user.age)
        textField.becomeFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        coreDataManager.updateMainUser(name: text)
        let user = coreDataManager.retrieveMainUser()
        label.text = user.name
    }
}
