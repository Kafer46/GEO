import Foundation

enum SampleData {
    struct SampleSet {
        let students: [Student]
        let teachers: [Teacher]
        let subjects: [Subject]
        let enrollments: [Enrollment]
    }

    private static let studentNames = [
        "An Nguyen", "Binh Tran", "Chi Le", "Dung Pham", "Giang Hoang",
        "Hanh Vu", "Huy Dang", "Khanh Bui", "Lan Do", "Long Ngo",
        "Mai Duong", "Minh Ly", "Nam Phan", "Ngoc Truong", "Phuc Vo",
        "Quan Dinh", "Quynh Ha", "Son Mai", "Tam Lam", "Thao Cao",
        "Trang Ta", "Trung Luu", "Tuan Kieu", "Uyen Trinh", "Vy Quach"
    ]

    static func make() -> SampleSet {
        let students: [Student] = studentNames.enumerated().compactMap { index, name in
            let number = String(format: "%03d", index + 1)
            let emailName = name.lowercased().replacingOccurrences(of: " ", with: ".")
            return try? Student(id: "S\(number)", name: name, email: "\(emailName)@school.edu")
        }

        let subjects: [Subject] = [
            try? Subject(id: "IOS101", title: "iOS Programming", credits: 3, semester: 1),
            try? Subject(id: "SWE201", title: "Software Engineering", credits: 3, semester: 1),
            try? Subject(id: "DB202", title: "Database Systems", credits: 4, semester: 2),
            try? Subject(id: "NET203", title: "Computer Networks", credits: 3, semester: 2),
            try? Subject(id: "GEO301", title: "Geo Programming", credits: 2, semester: 3),
            try? Subject(id: "MAT101", title: "Discrete Mathematics", credits: 3, semester: 1)
        ].compactMap { $0 }

        let teachers: [Teacher] = [
            try? Teacher(id: "T01", name: "Phuong Truong", email: "phuong.truong@school.edu"),
            try? Teacher(id: "T02", name: "Hung Nguyen", email: "hung.nguyen@school.edu"),
            try? Teacher(id: "T03", name: "Linh Tran", email: "linh.tran@school.edu"),
            try? Teacher(id: "T04", name: "Bao Le", email: "bao.le@school.edu")
        ].compactMap { $0 }

        let assignments: [(Int, [Int])] = [(0, [0, 4]), (1, [1, 0]), (2, [2, 5]), (3, [3, 2])]
        for (teacherIndex, subjectIndexes) in assignments where teacherIndex < teachers.count {
            for subjectIndex in subjectIndexes where subjectIndex < subjects.count {
                try? teachers[teacherIndex].assign(subjectID: subjects[subjectIndex].id)
            }
        }

        var enrollments: [Enrollment] = []
        for (studentIndex, student) in students.enumerated() {
            for offset in 0..<4 {
                let subject = subjects[(studentIndex + offset) % subjects.count]
                let isGraded = (studentIndex + offset) % 5 != 0
                let mark = isGraded ? Double((studentIndex * 7 + offset * 3) % 11) : nil
                if let enrollment = try? Enrollment(studentID: student.id, subjectID: subject.id,
                                                    academicYear: "2026-2027", mark: mark) {
                    enrollments.append(enrollment)
                }
            }
        }

        return SampleSet(students: students, teachers: teachers, subjects: subjects, enrollments: enrollments)
    }
}
