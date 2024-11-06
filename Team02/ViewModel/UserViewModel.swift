import Foundation
import FirebaseDatabase

class UserViewModel: ObservableObject {
    @Published var users: [User] = [] // Published property to hold fetched users
    private var databaseRef: DatabaseReference = Database.database().reference()

    init() {
        if !UserDefaults.standard.bool(forKey: "sampleUsersAddedSuccessfully") {
            addSampleUsers() // Only add sample users if they haven’t been added before
            UserDefaults.standard.set(true, forKey: "sampleUsersAddedSuccessfully")
        }
        fetchUsers() // Fetch users from the database
    }

    func saveUser(user: User) {
        let userID = user.id.uuidString
        databaseRef.child("users").child(userID).setValue(user.toDictionary()) { error, _ in
            if let error = error {
                print("Error saving user: \(error.localizedDescription)")
            } else {
                print("User saved successfully!")
            }
        }
    }

    // Method to add hardcoded sample users
    func addSampleUsers() {
        let sampleUsers = [
            User(id: UUID(), fullName: "Alice Johnson", image: "profile_pic_1", email: "alice@example.com", password: "password123", events: []),
            User(id: UUID(), fullName: "Bob Smith", image: "profile_pic_2", email: "bob@example.com", password: "password456", events: []),
            User(id: UUID(), fullName: "Charlie Brown", image: "profile_pic_3", email: "charlie@example.com", password: "password789", events: [])
        ]
        
        for user in sampleUsers {
            saveUser(user: user)
        }
    }

    func fetchUsers() {
        databaseRef.child("users").observe(.value) { snapshot in
            var fetchedUsers: [User] = []

            for case let childSnapshot as DataSnapshot in snapshot.children {
                if let userData = childSnapshot.value as? [String: Any],
                   let user = User(dictionary: userData) {
                    fetchedUsers.append(user)
                }
            }

            DispatchQueue.main.async {
                self.users = fetchedUsers // Update the published property
            }
        }
    }
}
