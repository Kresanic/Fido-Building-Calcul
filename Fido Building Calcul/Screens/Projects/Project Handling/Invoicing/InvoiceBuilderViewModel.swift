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
    @Published var redraw = false
    
    var project: Project
//    var pdfURL: URL {
//        return InvoicePDFCreator(invoiceDetails, invoiceItems).render()
//    }
    
    init(_ project: Project) { invoiceDetails = InvoiceDetails(project: project); self.project = project }
    
}


