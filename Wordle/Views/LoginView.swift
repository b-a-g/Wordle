//
//  LoginView.swift
//  Wordle
//
//  Created by Александр Беляев on 03.05.2022.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var user: UserViewModel
  @State private var signUpViewPresented = false

    init(completion: @escaping (() -> Void)) {
        let vm = UserViewModel()
        vm.completion = completion
        self.user = vm
    }

  var body: some View {
    let loginView = VStack {
      // Login title
      Text("Привет!\nВойди под своими данным")
        .font(.title)
        .multilineTextAlignment(.center)

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
          .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5).opacity(0.5)))
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
        SecureField("Пароль", text: $user.password)
      }
      .padding(0.02 * ScreenDimensions.height)

      #if os(iOS)
        passwordInputField
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5).opacity(0.5)))
          .frame(width: ScreenDimensions.width * 0.8)
      #elseif os(macOS) || os(tvOS)
        passwordInputField
      #endif

      Spacer()
        .frame(idealHeight: 0.05 * ScreenDimensions.height)
        .fixedSize()

      // Login button
      let loginButton = Button(action: user.login) {
        Text("Войти".uppercased())
          .foregroundColor(.white)
          .font(.title2)
          .bold()
      }
      .padding(0.025 * ScreenDimensions.height)
      .background(Capsule().fill(Color(.systemTeal)))

      #if os(iOS) || os(macOS)
        loginButton
          .buttonStyle(BorderlessButtonStyle())
      #elseif os(tvOS)
        loginButton
      #endif

      Spacer()
        .frame(idealHeight: 0.05 * ScreenDimensions.height)
        .fixedSize()

      // Navigation text
      HStack {
        Text("У тебя нет аккаунта?")
        let signUpButton = Button(action: {
          signUpViewPresented = true
        }) {
          Text("Создать!".uppercased())
            .bold()
        }
        .fullScreenCover(isPresented: $signUpViewPresented) {
          SignUpView(user: user, isPresented: $signUpViewPresented)
        }
        #if os(iOS) || os(macOS)
          signUpButton
            .buttonStyle(BorderlessButtonStyle())
        #elseif os(tvOS)
          signUpButton
        #endif
      }
    }
          .fullBackground(imageName: "Wordle_screen-3")
    .alert(isPresented: $user.alert, content: {
      Alert(
        title: Text("Сообщение"),
        message: Text(user.alertMessage),
        dismissButton: .destructive(Text("OK"))
      )
    })
    #if os(iOS) || os(tvOS)
      loginView
    #elseif os(macOS)
      loginView
        .frame(minWidth: 400, idealWidth: 400, minHeight: 700, idealHeight: 700)
    #endif
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
      LoginView(completion: {})
  }
}
