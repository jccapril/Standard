//
// Created by 蒋晨成 on 2021/2/10.
//

@propertyWrapper
public struct Trimmed {
    private var value: String = ""

    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}
