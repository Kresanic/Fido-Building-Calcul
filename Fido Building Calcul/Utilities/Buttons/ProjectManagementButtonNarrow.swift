//
//  ProjectManagementButtonNarrow.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 18/01/2024.
//

import SwiftUI

enum ProjectManagementType {
    
    case duplicate, archive, delete
    
    var backgroundColor: Color {
        switch self {
        case .duplicate:
            return Color.brandGray
        case .archive:
            return Color.brandBlack
        case .delete:
            return Color.brandBlack
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .duplicate:
            return Color.brandBlack
        case .archive:
            return Color.brandWhite
        case .delete:
            return Color.brandWhite
        }
    }
    
    var sfSymbol: String{
        switch self {
        case .duplicate:
            return "doc.on.doc.fill"
        case .archive:
            return "archivebox.fill"
        case .delete:
            return "trash.fill"
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .duplicate:
            return LocalizedStringKey("Duplicate")
        case .archive:
            return LocalizedStringKey("Archive")
        case .delete:
            return LocalizedStringKey("Delete")
        }
    }
    
}

struct ProjectManagementButton: View {
    
    var type: ProjectManagementType
    
    var body: some View {
        
        HStack {
         
            Text(type.title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(type.foregroundColor)
            
            Image(systemName: type.sfSymbol)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(type.foregroundColor)
            
        }.padding(.vertical, 13)
            .frame(maxWidth: .infinity)
            .background {
                if type == .duplicate {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                        .background(Color.brandWhite)
                        .clipShape(.rect(cornerRadius: 18, style: .continuous))
                } else {
                    type.backgroundColor
                        .clipShape(.rect(cornerRadius: 18, style: .continuous))
                }
                
            }
        
    }
    
}
