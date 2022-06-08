//
// Created by 蒋晨成 on 2021/2/10.
//

public extension Result where Success == Void {
    static var success: Self { .success(()) }
}
