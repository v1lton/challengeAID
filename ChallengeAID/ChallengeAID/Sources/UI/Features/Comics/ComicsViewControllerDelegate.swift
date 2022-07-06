//
//  ComicsViewControllerDelegate.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import UIKit

protocol ComicsViewControllerDelegate: AnyObject {
    func comicsViewController(didTapComic comic: ComicModel)
}
