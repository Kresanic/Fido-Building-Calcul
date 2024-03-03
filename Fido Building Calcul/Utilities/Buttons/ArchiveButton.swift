//
//  ArchiveButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ArchiveButton: View {

    var body: some View {

        HStack {

            Spacer()

            Text("Archive project")
                .font(.system(size: 20, weight: .medium))

            Image(systemName: "archivebox.fill")
                .font(.system(size: 18))

            Spacer()

        }.foregroundStyle(Color.brandWhite)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.brandBlack)
            .clipShape(Capsule())

    }

}
