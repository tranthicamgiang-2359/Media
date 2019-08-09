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
            .map{ _ in return "This field is require" }
            .bind(to: self.errorEmailSubject)
            .disposed(by: bag)
        
        loginButtonTapSubject
            .withLatestFrom(passwordSubject)
            .filter { $0.isEmpty }
            .map { _ in "This field is required" }
            .bind(to: self.errorPasswordSubject)
            .disposed(by: bag)
        
        emailNotNil
            .filter{ !self.validate(email: $0) }
            .map { _ in "Email is not well formed" }
            .bind(to: self.errorEmailSubject )
            .disposed(by: bag)
        
        passwordNotNil
            .filter { !self.validate(password: $0) }
            .map { _ in "Password is not well formed" }
            .bind(to: self.errorPasswordSubject)
            .disposed(by: bag)
        
        emailValidated
            .map { _ in "" }
            .bind(to: self.errorEmailSubject)
            .disposed(by: bag)
        
        passwordValidated
            .map { _ in "" }
            .bind(to: self.errorPasswordSubject)
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
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { user in
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
        let regex = try! NSRegularExpression(pattern: "(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[!&^%$#@()/]).{8}", options: .caseInsensitive)
        
        return regex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.utf16.count)) != nil
    }
}
