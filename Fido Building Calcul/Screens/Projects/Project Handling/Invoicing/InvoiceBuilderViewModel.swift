//
//  InvoiceBuilderViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/04/2024.
//

import SwiftUI
import CoreData


@MainActor final class InvoiceBuilderViewModel: ObservableObject {
    
    @Published var invoiceDetails: InvoiceDetails
    @Published var madeChanges = false
    @Published var dialogWindow: Dialog?
    @Published var isShowingPDF = false
    @Published var isShowingMissingValues = false
    @Published var missingValues: [IdentifiableInvoiceMissingValue]?
    @Published var redraw = false
    @Published var isFocusedOnItem = false
    @Published var wasPDFShown = false
    
    var project: Project
    
    init(_ project: Project) {
        invoiceDetails = InvoiceDetails(project: project)
        self.project = project
    }
    
}


