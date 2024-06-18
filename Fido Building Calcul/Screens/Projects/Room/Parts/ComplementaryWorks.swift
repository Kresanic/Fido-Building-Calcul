//
//  ComplementaryWorks.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

struct ComplementaryWorksBubble: View {
    
    var work: WorkType.Type
    var isSwitchedOn: Bool
    var subTitle: Bool = false
    var action: () -> Void
    
    var body: some View {
         
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { action() }
        } label: {
            
            HStack(spacing: 3) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text(work.title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                    
                    if subTitle && ((work.subTitle.stringKey?.isEmpty) != nil) {
                        Text(work.subTitle)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                    }
                    
                }
                    
                Spacer()
                
                Image(systemName: isSwitchedOn ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.brandBlack)
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.brandGray)
                .clipShape(.rect(cornerRadius: 15, style: .continuous))
            
        }
        
    }
    
}

struct ComplementaryWorksLayeredBubble: View {
    
    var work: WorkType.Type
    var activeLayers: Int
    var action: () -> Void
    
    var body: some View {
         
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { action() }
        } label: {
            
            HStack(spacing: 3) {
                
                Text(work.title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                    
                Spacer()
                
                ActiveLayersIcon(activeLayers: activeLayers)
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.brandGray)
                .clipShape(.rect(cornerRadius: 15, style: .continuous))
            
        }
        
    }
    
}

struct ActiveLayersIcon: View {
    
    var activeLayers: Int
    
    var body: some View {
        
        if activeLayers == 1 {
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(Color.brandBlack)
                
                Image(.simpleLayer)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandWhite)
                    .offset(x: -3, y: -0.5)
            }.frame(width: 25, height: 25)
        } else if activeLayers == 2 {
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(Color.brandBlack)
                
                Image(.doubleLayer)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandWhite)
                    .offset(x: -1.5, y: -0.5)
            }.frame(width: 25, height: 25)
        } else {
            Image(systemName: "circle")
                .font(.system(size: 25))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 25, height: 25)
        }
        
    }
    
}
