import Foundation

enum NumberMath {
    static func square(_ n: Int) -> Int? {
        let (value, overflow) = n.multipliedReportingOverflow(by: n)
        return overflow ? nil : value
    }

    static func cube(_ n: Int) -> Int? {
        guard let squared = square(n) else { return nil }
        let (value, overflow) = squared.multipliedReportingOverflow(by: n)
        return overflow ? nil : value
    }

    static func factorial(_ n: Int) -> Int? {
        guard n >= 0 else { return nil }
        var result = 1
        var i = 2
        while i <= n {
            let (value, overflow) = result.multipliedReportingOverflow(by: i)
            if overflow { return nil }
            result = value
            i += 1
        }
        return result
    }

    static func isPrime(_ n: Int) -> Bool {
        if n < 2 { return false }
        if n < 4 { return true }
        if n % 2 == 0 || n % 3 == 0 { return false }
        var i = 5
        while i <= n / i {
            if n % i == 0 || n % (i + 2) == 0 { return false }
            i += 6
        }
        return true
    }

    static func gcd(_ a: Int, _ b: Int) -> Int {
        var x = a.magnitude
        var y = b.magnitude
        while y != 0 {
            (x, y) = (y, x % y)
        }
        return Int(clamping: x)
    }

    static func lcm(_ a: Int, _ b: Int) -> Int? {
        if a == 0 || b == 0 { return 0 }
        let divisor = UInt(gcd(a, b))
        let (value, overflow) = (a.magnitude / divisor).multipliedReportingOverflow(by: b.magnitude)
        return overflow ? nil : Int(exactly: value)
    }
}
