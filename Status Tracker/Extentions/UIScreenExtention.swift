//
//  UIScreenExtention.swift
//  Status Tracker
//
//  Created by Guru Mahan on 19/03/23.
//

import Foundation
import SwiftUI

extension UIScreen {
    var safeAreaInsets: UIEdgeInsets {
        let first = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return first?.safeAreaInsets ?? .zero
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


extension View {
    func hideKeyboardWhenTappedAround() -> some View  {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                  to: nil, from: nil, for: nil)
        }
    }
}

struct Keyboard: ViewModifier {
    @State var offset: CGFloat = 0
    func body(content: Content) -> some View {
        content.padding(.bottom,offset).onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                self.offset = height
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
                self.offset = 0
            }
        }
    }
}
