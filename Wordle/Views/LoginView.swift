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
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }

  var body: some View {
    let loginView = VStack {
    
        HStack {
            VStack(alignment: .center) {
                Text("Привет, заходи :)")
                      .font(.largeTitle)
                      .multilineTextAlignment(.center)
                TextField("Email", text: $user.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5)
                            .opacity(0.5)))
                    .frame(width: 300)
                
                SecureField("Пароль", text: $user.password)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5).opacity(0.5)))
                    .frame(width: 300)
                
                Button(action: user.login) {
                    Text("Войти".uppercased())
                        .foregroundColor(.white)
                }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemOrange)))
                    .buttonStyle(BorderlessButtonStyle())
                
                HStack {
                    Text("У тебя нет аккаунта?")
                    Button(action: {
                        signUpViewPresented = true
                    }) {
                        Text("Создать!".uppercased())
                            .bold()
                    }
                        .fullScreenCover(isPresented: $signUpViewPresented) {
                            SignUpView(user: user, isPresented: $signUpViewPresented)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                }
            }
            Spacer(minLength: 100)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(user.topScores) { score in
                    Text(score.value)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray5)
                                .opacity(0.5)))
                        .frame(width: 400, alignment: .leading)
                }
            }.frame(width: 400)
        }
        

      Spacer()
        .frame(idealHeight: 0.05 * ScreenDimensions.height)
        .fixedSize()
     
    }
          .onAppear {
              self.user.viewDidApear()
          }
    .alert(isPresented: $user.alert, content: {
      Alert(
        title: Text("Сообщение"),
        message: Text(user.alertMessage),
        dismissButton: .destructive(Text("OK"))
      )
    })
      
    #if os(iOS) || os(tvOS)
      loginView
          .padding(150)
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
