//
//  Enums Projects.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

enum PropertyCategories: String, Hashable, CaseIterable, Identifiable {
    
    var id: String { self.rawValue }
    
    case flats, houses, firms, cottages
    
    static func readableSymbol(_ self: Self) -> LocalizedStringKey {
        switch self {
        case .flats:
            return "Flats"
        case .houses:
            return "Houses"
        case .firms:
            return "Companies"
        case .cottages:
            return "Cottages"
        }
        
    }
    
    static func parseToReadable(_ s: String?) -> String {
        switch s {
        case "flats":
            return "Flats"
        case "houses":
            return "Houses"
        case "firms":
            return "Companies"
        case "cottages":
            return "Cottages"
        default:
            return "Houses"
        }
    }
    
    static func parse(_ s: String?) -> PropertyCategories {
        switch s {
        case "flats":
            return .flats
        case "houses":
            return .houses
        case "firms":
            return .firms
        case "cottages":
            return .cottages
        default:
            return .flats
        }
    }
    
}

enum ProjectStatus: Int {
    
    case notSent = 0
    case sent = 1
    case approved = 2
    case finished = 3
    
    public var advanceStatus: Int64 {
        switch self {
        case .notSent:
            return 1
        case .sent:
            return 2
        case .approved:
            return 3
        case .finished:
            return 0
        }
    }
    
    public var sfSymbol: String {
        switch self {
        case .notSent:
            return "xmark.circle.fill"
        case .sent:
            return "questionmark.circle.fill"
        case .approved:
            return "checkmark.circle.fill"
        case .finished:
            return "flag.checkered.circle.fill"
        }
    }
    
    public var label: LocalizedStringKey {
        switch self {
        case .notSent:
            return "not sent"
        case .sent:
            return "sent"
        case .approved:
            return "approved"
        case .finished:
            return "finished"
        }
    }
    
    var historyEventLabel: String {
        switch self {
        case .notSent:
            return "notSent"
        case .sent:
            return "sent"
        case .approved:
            return "approved"
        case .finished:
            return "finished"
        }
    }
    
    public var backgroundColor: Color {
        switch self {
        case .notSent:
            return .brandRed
        case .sent:
            return .brandBlue
        case .approved:
            return .brandGreen
        case .finished:
            return .brandDarkGray
        }
    }
    
}

enum ProjectStatusBubbleDeployment {
    
    case projectBubble, inProject
    
    public var textFont: Font {
        switch self {
        case .projectBubble:
            return .system(size: 10, weight: .medium)
        case .inProject:
            return .system(size: 13, weight: .medium)
        }
    }
    
    public var padding: (CGFloat, CGFloat) {
        switch self {
        case .projectBubble:
            return (5, 3)
        case .inProject:
            return (6, 4)
        }
    }
    
}

enum ProjectEvents: String {
    
    case created, notSent, sent, approved, archived, unArchived, duplicated, invoiceSent, invoiceGenerated, finished
    
    var title: LocalizedStringKey {
        switch self {
        case .created:
            return "Created"
        case .notSent:
            return "Not sent"
        case .sent:
            return "Sent"
        case .invoiceSent:
            return "Invoice sent"
        case .invoiceGenerated:
            return "Invoice Generated"
        case .finished:
            return "Finished"
        case .approved:
            return "Approved"
        case .archived:
            return "Archived"
        case .duplicated:
            return "Duplicated"
        case .unArchived:
            return "Unarchived"
        }
    }
    
    var sfSymbol: String {
        switch self {
        case .created:
            return "flag.circle.fill"
        case .notSent:
            return "xmark.circle.fill"
        case .sent:
            return "paperplane.circle.fill"
        case .invoiceSent:
            return "paperplane.circle.fill"
        case .invoiceGenerated:
            return "doc.circle.fill"
        case .finished:
            return "flag.checkered.circle.fill"
        case .approved:
            return "checkmark.circle.fill"
        case .archived:
            return "archivebox.circle.fill"
        case .duplicated:
            return "doc.circle.fill"
        case .unArchived:
            return "xmark.bin.circle.fill"
        }
    }
    
    var entityObject: HistoryEvent {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let event = HistoryEvent(context: viewContext)
        event.cId = UUID()
        event.dateCreated = Date.now
        event.type = self.rawValue
        
        return event
        
    }
    
}
