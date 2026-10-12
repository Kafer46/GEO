// VO TUAN KIET

import Foundation

enum TextFileStore {

    //------------------------------------
    // Đường dẫn file trong Documents
    // Lần đầu chạy: copy file từ app sang
    //------------------------------------

    static func url(_ fileName: String) -> URL {
        let docURL = URL.documentsDirectory.appendingPathComponent(fileName)

        if !FileManager.default.fileExists(atPath: docURL.path),
           let appURL = Bundle.main.url(forResource: fileName, withExtension: nil) {
            try? FileManager.default.copyItem(at: appURL, to: docURL)
        }

        return docURL
    }

    //------------------------------------
    // Đọc file thành từng dòng
    //------------------------------------

    static func readLines(_ fileName: String) -> [String] {
        let text = (try? String(contentsOf: url(fileName), encoding: .utf8)) ?? ""
        return text.split(separator: "\n").map(String.init)
    }

    //------------------------------------
    // Tách 1 dòng theo dấu phẩy
    // Dấu phẩy trong "..." thì không tách
    //------------------------------------

    static func splitFields(_ line: String) -> [String] {
        var fields: [String] = []
        var current = ""
        var inQuotes = false

        for ch in line {
            if ch == "\"" {
                inQuotes.toggle()
            } else if ch == "," && !inQuotes {
                fields.append(current.trimmingCharacters(in: .whitespaces))
                current = ""
            } else {
                current.append(ch)
            }
        }

        fields.append(current.trimmingCharacters(in: .whitespaces))
        return fields
    }

    //------------------------------------
    // Đọc category.txt
    //------------------------------------

    static func loadCategories() -> [ProductCategory] {
        readLines("category.txt").map { line in
            ProductCategory(name: splitFields(line)[1], iconName: "")
        }
    }

    //------------------------------------
    // Đọc fish.txt / plant.txt / food.txt
    //------------------------------------

    static func loadProducts(_ fileName: String, category: ProductCategory) -> [Product] {
        readLines(fileName).compactMap { line in
            let f = splitFields(line)

            guard f.count == 7, let price = Double(f[3]), let stock = Int(f[4]) else {
                return nil
            }

            return Product(name: f[1], categoryId: category.id, price: price,
                           imageName: f[5], description: f[6], stock: stock)
        }
    }

    //------------------------------------
    // Lưu sản phẩm mới vào cuối file
    //------------------------------------

    static func saveProduct(_ p: Product, to fileName: String, categoryNumber: Int) {
        let lines = readLines(fileName)
        let newLine = "\(lines.count + 1), \"\(p.name)\", \(categoryNumber), \(Int(p.price)), \(p.stock), \"\(p.imageName)\", \"\(p.description)\""

        let text = (lines + [newLine]).joined(separator: "\n") + "\n"
        try? text.write(to: url(fileName), atomically: true, encoding: .utf8)
    }
}
