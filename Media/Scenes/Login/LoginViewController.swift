//
//  ViewController.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/6/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

protocol LoginViewControllerDelegate: class {
    func didLoginSuccessfully(with user: User)
}

class LoginViewController: UIViewController, VCStoryboardInitializable {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorTextField: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    public var viewModel: LoginViewModel!
    
    private let bag = DisposeBag()
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        // Do any additional setup after loading the view.
    }

    private func bind() {
        emailTextField.rx.text.compactMap { $0 }
            .subscribe(viewModel.emailSubject)
            .disposed(by: bag)
        passwordTextField.rx.text.compactMap{ $0 }
            .subscribe(viewModel.passwordSubject)
            .disposed(by: bag)
        
        loginButton.rx.tap
            .subscribe(viewModel.loginButtonTapSubject)
            .disposed(by: bag)
        
        viewModel.requestLoginSubject
            .subscribe(onNext: { (userStateVM) in
                switch userStateVM {
                case .loading:
                    print("loading")
                case .error(let error):
                    print("Error \(error)")
                case .success(let user):
                    UserDefaults.standard.set("hihi", forKey: "token")
                    self.delegate?.didLoginSuccessfully(with: user)
                }
            }, onError: { (error) in
                print("Login unsuccessfully")
            })
            .disposed(by: bag)
        viewModel.errorEmailSubject
            .bind(to: emailErrorLabel.rx.text)
            .disposed(by: bag)
        viewModel.errorPasswordSubject
            .bind(to: passwordErrorTextField.rx.text)
            .disposed(by: bag)
        
    }

}

struct MovieRequest: MediaRequest {
    var method: HTTPMethod = .get
    
    var url: String = "https://demo6492027.mockable.io/home"
    
    var parameter: Parameter?
    
    var header: [String : String]?
    
    
}
