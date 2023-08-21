//
//  BannerViewController.swift
//  TheArcXP
//
//  Created by Amani Hunter on 5/15/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import UIKit

class BannerAdViewController: UIViewController {

  weak var delegate: BannerAdViewControllerWidthDelegate?

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    delegate?.bannerAdViewController(
      self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
  }

  override func viewWillTransition(
    to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
  ) {
    coordinator.animate { _ in
      // do nothing
    } completion: { _ in
      self.delegate?.bannerAdViewController(
        self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
    }
  }
}
