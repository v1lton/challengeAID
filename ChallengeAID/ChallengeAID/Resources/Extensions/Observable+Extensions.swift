//
//  Observable+Extensions.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 04/07/22.
//

import RxSwift

extension Observable {

    public func subscribeOnMainDisposed(by disposeBag: DisposeBag, onNext: ((Observable.Element) -> Void)? = nil) {
        subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global(qos: .background)))
        .observe(on: ConcurrentMainScheduler.instance)
        .subscribe(onNext: onNext)
        .disposed(by: disposeBag)
    }
}
