//
//  PlanApiData.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 05.03.23.
//

import Foundation

struct PlanApiData: Codable{
    let status: Int
    let subscriptionPlan: String
    let subscriptionId: String?
    let subscriptionPlanId: String?
    let subscriptionStatus: String?
}
