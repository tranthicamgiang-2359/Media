//
//  LoginViewModel.swift
//  Media
//
//  Created by Tran Thi Cam Giang on 8/7/19.
//  Copyright © 2019 Tran Thi Cam Giang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct LoginViewModel {
    
    let loginButtonTapSubject = PublishSubject<Void>()
    let emailSubject = PublishSubject<String>()
    let passwordSubject = PublishSubject<String>()
    let requestLoginSubject = PublishSubject<StateViewModel<User>>()
    let errorEmailSubject = PublishSubject<String>()
    let errorPasswordSubject = PublishSubject<String>()
    
    
    private let bag = DisposeBag()
    private let service: AuthenticationService
    
    init(loginService: AuthenticationService) {
        self.service = loginService
        bind()
    }
    
    private func bind() {
        let emailNotNil = loginButtonTapSubject.withLatestFrom(emailSubject).filter { !$0.isEmpty }
        let passwordNotNil = loginButtonTapSubject.withLatestFrom(passwordSubject).filter { !$0.isEmpty }
        let emailValidated = emailNotNil.filter { self.validate(email: $0) }
        let passwordValidated = passwordNotNil.filter { self.validate(password: $0) }
        let credentialCreated = Observable.combineLatest(emailValidated, passwordValidated) { Credential(email: $0, password: $1) }
        
        
        loginButtonTapSubject
            .withLatestFrom(emailSubject)
            .filter { $0.isEmpty }
            .subscribe(onNext: { email in
                self.errorEmailSubject.onNext("This field is required")
            })
            .disposed(by: bag)
        
        loginButtonTapSubject
            .withLatestFrom(passwordSubject)
            .filter { $0.isEmpty }
            .subscribe(onNext: { password in
                self.errorPasswordSubject.onNext("This field is required")
            })
            .disposed(by: bag)
        
        emailNotNil
            .filter{ !self.validate(email: $0) }
            .subscribe(onNext: { _ in
                self.errorEmailSubject.onNext("Email is not well formed")
            })
            .disposed(by: bag)
        
        passwordNotNil
            .filter { !self.validate(password: $0) }
            .subscribe(onNext: { _ in
                self.errorPasswordSubject.onNext("Password is not well formed")
            })
            .disposed(by: bag)
        
        loginButtonTapSubject
            .withLatestFrom(credentialCreated)
            .do(onNext: { (_) in
                self.requestLoginSubject.onNext(StateViewModel<User>.loading)
                self.errorEmailSubject.onNext("")
                self.errorPasswordSubject.onNext("")
            })
            .flatMapLatest { (credential) -> Single<User> in
                self.service.login(email: credential.email, password: credential.password)
            }.subscribe(onNext: { user in
                self.requestLoginSubject.onNext(StateViewModel<User>.success(user))
            }, onError: { (error) in
                self.requestLoginSubject.onNext(StateViewModel<User>.error(error))
            })
            .disposed(by: bag)
        
    }
    
}

// MARK: Validate logic
extension LoginViewModel {
    private func validate(email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: ".+@.+", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }
    
    private func validate(password: String) -> Bool {
        return password.count == 8
    }
}
