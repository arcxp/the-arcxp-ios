//
//  Constants.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 3/18/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct Constants {
    
    // Title to display in navBar
    static let title = "The Arc XP"

    struct Org {
        static let siteName = "demo"
        static let orgName = "demo"
        static let env = "sandbox"
        static let contentDomain = "demo-demo-sandbox.web.arc-cdn.net"
        static let commerceDomain = "arcsales-arcsales-sandbox.api.cdn.arcpublishing.com"

        static let siteHierarchyName = "mobile-nav"
        static let videoCollectionAlias = "mobile-video"
    }

    struct Colors {
        static let Blue = Color("ArcXPBlue")
        static let DarkGray = Color("ArcXPDarkGray")
        static let LightBlue = Color("ArcXPLightBlue")
        static let LightGray = Color("ArcXPLightGray")
        static let FBBlue = Color("FacebookBlue")
    }

    struct Fonts {
        static let ArcXPFontName = "OldEnglishFive"
    }

    struct PrivacyPolicy {
        static let termsOfService = "Terms of Service"
        static let termsServiceUrl = "https://www.washingtonpost.com/terms-of-service/2011/11/18/gIQAldiYiN_story.html"
        static let privacyPolicy = "Privacy Policy"
        static let privacyPolicyUrl = "https://www.washingtonpost.com/privacy-policy/2011/11/18/gIQASIiaiN_story.html"
    }

    struct ImageName {
        static let ArcXPImage = "arcIcon"
        static let FBImage = "facebookIcon"
        static let GoogleImage = "googleIcon"
        static let AppleImage = "appleIcon"
        static let checkmark = "checkmark.circle"
        static let share = "square.and.arrow.up"
        static let house = "house"
        static let video = "video"
        static let person = "person.circle"
        static let gear = "gear"
        static let xmark = "xmark"
        static let magnifying = "magnifyingglass"
        static let horizontalLine = "line.horizontal.3"
        static let chevronRight = "chevron.right"
        static let boxedcheckmark = "checkmark.square.fill"
        static let square = "square"
    }

    struct ResetPassword {
        static let current = "Current Password"
        static let new = "New Password"
        static let confirm = "Confirm Password"
        static let update = "Update Password"
    }

    struct Account {
        static let account = "Account"
        static let createAccount = "Create Account"
        static let login = "Login"
        static let subscriber = "Subscriber"
        static let logout = "Logout"
        static let changePass = "Change Password"
        static let policy = "Policies"
        static let terms = "Terms of Service"
        static let cancel = "Cancel"
        static let softwareVersion = "Software Versions"
    }

    struct TabBar {
        static let home = "Home"
        static let video = "Video"
        static let search = "Search"
    }

    struct CreateAccount {
        static let signUp = "Sign Up"
        static let fbSignUp = "Sign Up with Facebook"
        static let googleSignUp = "Sign Up with Google"
        static let appleSignUp = "Sign Up with Apple"
        static let existingAccount = "Already have an account?"
        static let password = "Password"
        static let name = "Name"
        static let firstName = "First Name"
        static let lastName = "Last Name"
        static let email = "Email"
        static let address = "Email Address"
        static let done = "Done"
        static let success = "Success!"
        static let created = "Your account has been created."
    }

    struct Login {
        static let signIn = "Sign In"
        static let email = "Email"
        static let password = "Password"
        static let errorLogin = "Error logging into your account"
        static let rememberMe = "Remember Me"
        static let noAccount = "Don't have an account?"
        static let register = "Register"
        static let forgotPassword = "Forgot Password"
        static let fbSignIn = "Sign In with FaceBook"
        static let googleSignIn = "Sign In with Google"
        static let appleSignIn = "Sign In with Apple"
        static let close = "Close"
    }

    struct ForgotPassword {
        static let enterEmail = "Enter email address"
        static let emailSent = "Email Sent"
        static let emailCheck = "Please check your email"
        static let emailFail = "Failed to send email"
        static let emailReset = "Reset"
        static let emailRequest = "Request a password reset"
        static let dismiss = "Dismiss"
    }

    struct Story {
        static let news = "News"
        static let headline = "The Headline of the Article"
    }
    
    struct WidgetConstants {
        static let updated = "Updated"
        static let kind = "Kind"
        static let configurationDisplayName = "Stories"
        static let description = "View Stories"
        static let alias = "mobile-topstories"
    }
    
    struct GoogleAds {
        static let advertisment = "ADVERTISEMENT"
        static var bannerAdUnitID: String? {
            guard let adUnitID = Bundle.main.object(forInfoDictionaryKey: "GADBannerAdUnitID") as? String else {
                return nil
            }
            return adUnitID
        }
        static var nativeAdUnitID: String? {
            guard let adUnitID = Bundle.main.object(forInfoDictionaryKey: "GADNativeAdUnitID") as? String else {
                return nil
            }
            return adUnitID
        }
        static let nativeAdView = "NativeAdView"
        static let fiveStars = "stars_5"
        static let fourAndHalfStars = "stars_4_5"
        static let fourStars = "stars_4"
        static let threeAndHalfStars = "stars_3_5"
    }
}

struct PaywallConstants {
    
    static let continueReading = "to continue reading."
    static let getEveryStory = "Get every story"
    
    enum DeviceClass: String {
        case mobile, tablet, web
    }
    enum ContentType: String {
        case story, video, gallery
    }
}
