//
//  User.swift
//  On The Map
//
//  Created by Nils Riebeling on 07.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import Foundation


struct User: Codable {

   let    lastName : String?
    let    socialAccounts : [String]?
   let    mailingAddress : String?
   let    cohortKeys : [String]?
   let    signature : String?
   let    stripeCustomerId : String?
   let    guardInfo : GuardInfo?
   let    facebookId : String?
   let    timezone : String?
   let    sitePreferences : String?
   let    occupation : String?
   let    image : String?
   let    firstName : String?
   let    jabberId : String?
   let    languages : String?
   let    badges : [String]?
   let    location : String?
   let    externalServicePassword : String?
   let    principals : [String]?
   let    enrollment : [String]?
   let    eMail : EMail
   let    websiteURL : String?
   let    external_accounts : [String]?
   let    bio : String?
   let    coachingData : String?
   let    tags : [String]?
   let    affiliateProfile : [String]?
   let    hasPassword : Bool?
   let    emailPreferences : String?
   let    resume : String?
   let    key : String
   let    nickname : String?
   let    employerSharing : Bool?
   let    Memberships : [String]?
   let    zendeskId : [String]?
   let    registered : Bool?
   let    linkedinURL : String?
   let    googleId : String?
   let    imageUrl : String?
    
    
    
    enum CodingKeys: String, CodingKey {

        case    lastName = "last_name"
        case    socialAccounts = "social_accounts"
        case    mailingAddress = "mailing_address"
        case    cohortKeys = "_cohort_keys"
        case    signature
        case    stripeCustomerId = "_stripe_customer_id"
        case    guardInfo = "guard"
        case    facebookId = "_facebook_id"
        case    timezone
        case    sitePreferences = "site_preferences"
        case    occupation
        case    image = "_image"
        case    firstName = "first_name"
        case    jabberId = "jabber_id"
        case    languages
        case    badges = "_badges"
        case    location
        case    externalServicePassword = "external_service_password"
        case    principals = "_principals"
        case    enrollment = "_enrollments"
        case    eMail = "email"
        case    websiteURL = "website_url"
        case    external_accounts = "external_accounts"
        case    bio
        case    coachingData = "coaching_data"
        case    tags
        case    affiliateProfile = "_affiliate_profiles"
        case    hasPassword = "_has_password"
        case    emailPreferences = "email_preferences"
        case    resume = "_resume"
        case    key
        case    nickname
        case    employerSharing = "employer_sharing"
        case    Memberships = "_memberships"
        case    zendeskId = "zendesk_id"
        case    registered = "_registered"
        case    linkedinURL = "linkedin_url"
        case    googleId = "_google_id"
        case    imageUrl = "_image_url"

    }

}

struct EMail: Codable {
    
    let address: String
    let verified: Bool?
    let verificationCodeSent: Bool?
    
    enum CodingKeys: String, CodingKey {
        case address
        case verified = "_verified"
        case verificationCodeSent = "_verification_code_sent"

}
}

struct GuardInfo: Codable {

    let allowedBehaviors: [String]?

    enum CodingKeys: String, CodingKey {
        case allowedBehaviors = "allowed_behaviors"
    }


}

