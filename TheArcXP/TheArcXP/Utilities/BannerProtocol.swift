//
//  BannerProtocol.swift
//  TheArcXP
//
//  Created by Amani Hunter on 5/15/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import Foundation

protocol BannerAdViewControllerWidthDelegate: AnyObject {
    func bannerAdViewController(_ bannerViewController: BannerAdViewController, didUpdate width: CGFloat)
}
