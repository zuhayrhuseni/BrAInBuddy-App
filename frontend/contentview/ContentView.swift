import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ChatBotView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat Bot")
                }
            
            ForumView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Forum")
                }
            
            ResourcesView()
                .tabItem {
                    Image(systemName: "link")
                    Text("Resources")
                }
        }
    }
}

// ChatBot View (BrAInbuddy Chat Bot)
struct ChatBotView: View {
    @State private var userInput: String = ""
    @State private var response: String = "Your AI response will appear here."
    
    var body: some View {
        VStack {
            // Title "BrAInbuddy"
            Text("BrAInbuddy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            // AI Profile Picture
            Image("Buddy") // Replace with your image asset name
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                .shadow(radius: 5)
                .padding(.vertical)

            // TextField for User Input
            TextField("Enter your thoughts...", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Send Button
            Button(action: {
                sendRequest()
            }) {
                Text("Send")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            // Response Display
            Text(response)
                .padding()
        }
        .padding()
    }

    func sendRequest() {
        guard let url = URL(string: "http://127.0.0.1:5000/ai-response") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["user_input": userInput]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                DispatchQueue.main.async {
                    self.response = jsonResponse?["response"] ?? "Failed to get response."
                }
            }
        }.resume()
    }
}

// Forum View (Static Forum with Mock Messages)
struct ForumView: View {
    var body: some View {
        NavigationView {
            List {
                ForumMessageView(username: "Alex", message: "I've been feeling stressed with exams coming up.", imageName: "person.fill")
                ForumMessageView(username: "Sam", message: "I managed to get through my presentation today. Feeling relieved!", imageName: "person.fill")
                ForumMessageView(username: "Jamie", message: "Does anyone have tips for dealing with anxiety before a test?", imageName: "person.fill")
            }
            .navigationTitle("Forum")
        }
    }
}

struct ForumMessageView: View {
    var username: String
    var message: String
    var imageName: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(username)
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 5)
    }
}

// Resources View (Static Page with Helpful Links)
struct ResourcesView: View {
    var body: some View {
        NavigationView {
            List {
                Link("Find a Local Therapist", destination: URL(string: "https://www.psychologytoday.com/us/therapists")!)
                Link("Mental Health Support Line", destination: URL(string: "https://www.mentalhealth.gov/get-help/immediate-help")!)
                Link("Anxiety Support Resources", destination: URL(string: "https://www.anxiety.org/")!)
            }
            .navigationTitle("Resources")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
