//
//  CustomDivider.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/09.
//

import SwiftUI

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.dividerForeground)
            .frame(height: 3)
            .edgesIgnoringSafeArea(.horizontal)
        
    }
}

//struct CustomDivider_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomDivider()
//    }
//}
