//
//  SignUpView.swift
//  Wordle
//
//  Created by Александр Беляев on 03.05.2022.
//
import SwiftUI

struct SignUpView: View {
  @ObservedObject var user: UserViewModel
  @Binding var isPresented: Bool

  var body: some View {
    let signUpView = VStack {
      // Sign up title
      Text("Новый аккаунт".uppercased())
        .font(.title)

      Spacer()
        .frame(idealHeight: 0.1 * ScreenDimensions.height)
        .fixedSize()

      // Email textfield
      let emailInputField = HStack {
        Image("user-icon")
          .resizable()
          .scaledToFit()
          .frame(width: 30.0, height: 30.0)
          .opacity(0.5)
        let emailTextField = TextField("Email", text: $user.email)
        #if os(iOS)
          emailTextField
            .keyboardType(.emailAddress)
            .autocapitalization(UITextAutocapitalizationType.none)
        #elseif os(macOS) || os(tvOS)
          emailTextField
        #endif
      }
      .padding(0.02 * ScreenDimensions.height)

      #if os(iOS)
        emailInputField
          .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
          .frame(width: ScreenDimensions.width * 0.8)
      #elseif os(macOS) || os(tvOS)
        emailInputField
      #endif

      // Password textfield
      let passwordInputField = HStack {
        Image("lock-icon")
          .resizable()
          .scaledToFit()
          .frame(width: 30.0, height: 30.0)
          .opacity(0.5)
        SecureField("Password", text: $user.password)
      }
      .padding(0.02 * ScreenDimensions.height)

      #if os(iOS)
        passwordInputField
          .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
          .frame(width: ScreenDimensions.width * 0.8)
      #elseif os(macOS) || os(tvOS)
        passwordInputField
      #endif

      Spacer()
        .frame(idealHeight: 0.05 * ScreenDimensions.height)
        .fixedSize()

      // Sign up button
      let signUpButton = Button(action: user.signUp) {
        Text("Создать".uppercased())
          .foregroundColor(.white)
          .font(.title2)
          .bold()
      }
      .padding(0.025 * ScreenDimensions.height)
      .background(Capsule().fill(Color(.systemTeal)))

      #if os(iOS) || os(macOS)
        signUpButton
          .buttonStyle(BorderlessButtonStyle())
      #elseif os(tvOS)
        signUpButton
      #endif

      Spacer()
        .frame(idealHeight: 0.05 * ScreenDimensions.height)
        .fixedSize()

      // Navigation text
      HStack {
        Text("Уже есть аккаунт? Тогда заходи)")
        let loginButton = Button(action: {
          isPresented = false
        }) {
          Text("Войти".uppercased())
            .bold()
        }

        #if os(iOS) || os(macOS)
          loginButton
            .buttonStyle(BorderlessButtonStyle())
        #elseif os(tvOS)
          loginButton
        #endif
      }
    }
    .alert(isPresented: $user.alert, content: {
      Alert(
        title: Text("Message"),
        message: Text(user.alertMessage),
        dismissButton: .destructive(Text("Ok"))
      )
    })
    #if os(iOS) || os(tvOS)
      signUpView
    #elseif os(macOS)
      signUpView
        .frame(minWidth: 400, idealWidth: 400, minHeight: 700, idealHeight: 700)
    #endif
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView(user: user, isPresented: .constant(false))
      .preferredColorScheme(.light)
  }
}
