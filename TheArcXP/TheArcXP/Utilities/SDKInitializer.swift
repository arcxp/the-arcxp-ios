//
//  ContentSDKHelper.swift
//  the-arcxp-iOS
//
//  Created by Mahesh Venkateswarlu on 2/27/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import ArcXP
import Foundation

struct SDKInitializer {

    static func initializeArcXPSDKs() {
        let commerceConfiguration = CommerceConfiguration(baseUrl: "https://\(Constants.Org.commerceDomain)",
                                                          organization: Constants.Org.orgName,
                                                          environment: .sandbox,
                                                          site: Constants.Org.siteName)

        let contentConfiguration = ContentConfiguration(baseUrl: "https://\(Constants.Org.contentDomain)",
                                                        organization: Constants.Org.orgName,
                                                        environment: .sandbox,
                                                        site: Constants.Org.siteName,
                                                        thumborResizerKey: "thumbor",
                                                        cacheConfiguration: ArcXPCacheConfig(timeToConsider: 10))

        let videoConfiguration = VideoConfiguration(organization: Constants.Org.orgName,
                                                    environment: .sandbox,
                                                    useGeorestrictions: false)

        Services.configure(service: .commerce(commerceConfiguration))
        Services.configure(service: .content(contentConfiguration))
        Services.configure(service: .video(videoConfiguration))
    }
}
