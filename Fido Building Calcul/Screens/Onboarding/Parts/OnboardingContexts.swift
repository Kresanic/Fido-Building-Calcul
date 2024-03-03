//
//  OnboardingContexts.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/11/2023.
//

import SwiftUI

struct OnboardingPageInfo {
    
    let title: LocalizedStringKey
    let images: [ImageResource]
    let description: LocalizedStringKey
    var isFinal: Bool = false
    
}

struct OnboardingPageContexts {
    
    static let mainPriceList: OnboardingPageInfo = .init(title: "General price list", images: [.bottomBarPriceList], description: "Customize according to your work and material costs. Price changes will reflect in every newly created project.")
    
    static let projectPriceList: OnboardingPageInfo = .init(title: "Project price list", images: [.projectPriceList], description: "For changing prices in individual projects, use the project price list. Price changes will only affect the current project.")
    
    static let rooms: OnboardingPageInfo = .init(title: "Rooms", images: [.rooms], description: "By clicking on:( + ) select the room you want to renovate. If you click on: (Custom) you can create your own room name.\n\nAfter adding the work you want to perform, the app will calculate the cost of labor and materials as well as the quantity (m, m2, pcs…) of materials needed for the renovation.")
    
    static let clients: OnboardingPageInfo = .init(title: "Clients", images: [.clientsHeadline, .bottomBarClients], description: "Add a new client by clicking on: (+)\nChoose a private or legal entity and fill in the client's details.\nDon't forget to save the details.")
    
    static let newProject: OnboardingPageInfo = .init(title: "New project", images: [.createNewProject], description: "After saving the client's details, you can see already created projects, as well as create a new one by clicking on: (+)")
    
    static let settings: OnboardingPageInfo = .init(title: "Settings", images: [.archiveSettings, .bottomBarSettings], description: "Projects in the archive can be restored or permanently deleted.")
    
    static let priceListWork: OnboardingPageInfo = .init(title: "Work price list", images: [], description: """
The last item is - Auxiliary and finishing works.
This item includes: material purchase, handling, carrying out, cleaning, covering, taping, waste removal...

From our experience, we have found that it is appropriate to set this item at 10%.

Example:
Work cost will be               1000€
Auxiliary and finishing works   10%
Total work cost                 1100€
""")
    
    static let priceListMaterial: OnboardingPageInfo = .init(title: "Material price list", images: [], description: """
The last item is - Auxiliary and connecting material.
This item includes: cover films, tapes, rollers, brushes, knives, pencils...

From our experience, we have found that it is appropriate to set this item at 10%.

Example:
Material cost will be               1000€
Auxiliary and connecting material   10%
Total material cost                 1100€
""", isFinal: false)
    
}
