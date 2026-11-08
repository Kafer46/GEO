#include <iostream>
#include <string>
#include <limits>

using namespace std;

struct Student {
    string id;
    string name;
    double gpa;
};

const int MAX_STUDENTS = 100;

int findIndexById(Student students[], int n, const string& id) {
    for (int i = 0; i < n; i++) {
        if (students[i].id == id) {
            return i;
        }
    }
    return -1;
}

void showAll(Student students[], int n) {
    if (n == 0) {
        cout << "No students in the list.\n";
        return;
    }
    cout << "--- Student List ---\n";
    for (int i = 0; i < n; i++) {
        cout << i + 1 << ". " << students[i].id << " - " << students[i].name
             << " - " << students[i].gpa << "\n";
    }
}

double readGpa() {
    double gpa;
    while (!(cin >> gpa) || gpa < 0 || gpa > 10) {
        cin.clear();
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << "Invalid GPA. Enter GPA (0 - 10): ";
    }
    return gpa;
}

int main() {
    Student students[MAX_STUDENTS];
    int n = 0;
    int choice;

    while (true) {
        cout << "\n=== Student Management ===\n";
        cout << "1. Add student\n";
        cout << "2. Show all students\n";
        cout << "3. Remove a student by id\n";
        cout << "4. Update a student's GPA\n";
        cout << "5. Find the student with the highest GPA\n";
        cout << "6. Exit\n";
        cout << "Choose an option: ";

        if (!(cin >> choice)) {
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Invalid option.\n";
            continue;
        }

        if (choice == 1) {
            if (n >= MAX_STUDENTS) {
                cout << "The list is full.\n";
                continue;
            }
            string id, name;
            cout << "Enter id: ";
            cin >> id;
            if (findIndexById(students, n, id) != -1) {
                cout << "Id already exists.\n";
                continue;
            }
            cout << "Enter name: ";
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            getline(cin, name);
            cout << "Enter GPA: ";
            double gpa = readGpa();

            students[n].id = id;
            students[n].name = name;
            students[n].gpa = gpa;
            n = n + 1;
            cout << "Student added!\n";
        } else if (choice == 2) {
            showAll(students, n);
        } else if (choice == 3) {
            string id;
            cout << "Enter id to remove: ";
            cin >> id;
            int index = findIndexById(students, n, id);
            if (index == -1) {
                cout << "Student not found.\n";
            } else {
                for (int i = index; i < n - 1; i++) {
                    students[i] = students[i + 1];
                }
                n--;
                cout << "Student removed!\n";
            }
        } else if (choice == 4) {
            string id;
            cout << "Enter id to update: ";
            cin >> id;
            int index = findIndexById(students, n, id);
            if (index == -1) {
                cout << "Student not found.\n";
            } else {
                cout << "Enter new GPA: ";
                students[index].gpa = readGpa();
                cout << "GPA updated!\n";
            }
        } else if (choice == 5) {
            if (n == 0) {
                cout << "No students in the list.\n";
            } else {
                int best = 0;
                for (int i = 1; i < n; i++) {
                    if (students[i].gpa > students[best].gpa) {
                        best = i;
                    }
                }
                cout << "Highest GPA: " << students[best].id << " - " << students[best].name
                     << " - " << students[best].gpa << "\n";
            }
        } else if (choice == 6) {
            cout << "Goodbye!\n";
            break;
        } else {
            cout << "Invalid option.\n";
        }
    }

    return 0;
}
