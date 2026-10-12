import SwiftUI

/// Màn hình đăng nhập. Tài khoản mẫu: admin / 123456
struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var errorMessage = ""
    @State private var isLoggedIn = false

    // Tài khoản mẫu để kiểm tra, chưa nối máy chủ thật
    private let sampleUsername = "admin"
    private let samplePassword = "123456"

    private let darkBlue = Color(red: 0.04, green: 0.20, blue: 0.50)

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.78, green: 0.93, blue: 0.98),
                    Color(red: 0.25, green: 0.62, blue: 0.85)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if isLoggedIn {
                welcomeView
            } else {
                loginForm
            }
        }
    }

    // MARK: - Form đăng nhập

    private var loginForm: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Tên cửa hàng
                VStack(spacing: 8) {
                    Text("Cá Cảnh KAT")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(darkBlue)

                    Text("Đăng nhập để tiếp tục")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 90)
                .padding(.bottom, 10)

                // Các ô nhập
                VStack(spacing: 14) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                            .frame(width: 24)
                        TextField("Tên đăng nhập", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)

                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                            .frame(width: 24)

                        if showPassword {
                            TextField("Mật khẩu", text: $password)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        } else {
                            SecureField("Mật khẩu", text: $password)
                        }

                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                }

                // Thông báo lỗi
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Quên mật khẩu
                HStack {
                    Spacer()
                    Button("Quên mật khẩu?") {
                        errorMessage = "Chức năng quên mật khẩu chưa được hỗ trợ."
                    }
                    .font(.footnote)
                    .foregroundColor(darkBlue)
                }

                // Nút đăng nhập
                Button(action: login) {
                    Text("Đăng nhập")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(darkBlue)
                        .cornerRadius(12)
                }

                // Đăng ký
                HStack(spacing: 4) {
                    Text("Chưa có tài khoản?")
                        .foregroundColor(.secondary)
                    Button("Đăng ký") {
                        errorMessage = "Chức năng đăng ký chưa được hỗ trợ."
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(darkBlue)
                }
                .font(.footnote)
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - Sau khi đăng nhập

    private var welcomeView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.green)

            Text("Đăng nhập thành công")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(darkBlue)

            Text("Xin chào, \(username)!")
                .foregroundColor(.secondary)

            Button("Đăng xuất") {
                isLoggedIn = false
                password = ""
                errorMessage = ""
            }
            .padding(.top, 10)
            .foregroundColor(darkBlue)
        }
    }

    // MARK: - Xử lý

    private func login() {
        let name = username.trimmingCharacters(in: .whitespaces)

        if name.isEmpty || password.isEmpty {
            errorMessage = "Vui lòng nhập tên đăng nhập và mật khẩu."
            return
        }

        if name == sampleUsername && password == samplePassword {
            errorMessage = ""
            isLoggedIn = true
        } else {
            errorMessage = "Tên đăng nhập hoặc mật khẩu không đúng."
        }
    }
}

#Preview {
    LoginView()
}
