//
// Created by 蒋晨成 on 2021/2/8.
//

import Darwin

public final class ReadWriteLock {
    private let rwlock: UnsafeMutablePointer<pthread_rwlock_t> = UnsafeMutablePointer.allocate(capacity: 1)

    /// Create a new lock.
    public init() {
        let err = pthread_rwlock_init(rwlock, nil)
        precondition(err == 0, "\(#function) failed in pthread_rwlock with error \(err)")
    }

    deinit {
        let err = pthread_rwlock_destroy(rwlock)
        precondition(err == 0, "\(#function) failed in pthread_rwlock with error \(err)")
        rwlock.deallocate()
    }
}

public extension ReadWriteLock {
    /// Acquire a reader lock.
    ///
    /// Whenever possible, consider using `withReaderLock` instead of this
    /// method and `unlock`, to simplify lock handling.
    func lockRead() {
        let err = pthread_rwlock_rdlock(rwlock)
        precondition(err == 0, "\(#function) failed in pthread_rwlock with error \(err)")
    }

    /// Acquire a writer lock.
    ///
    /// Whenever possible, consider using `withWriterLock` instead of this
    /// method and `unlock`, to simplify lock handling.
    func lockWrite() {
        let err = pthread_rwlock_wrlock(rwlock)
        precondition(err == 0, "\(#function) failed in pthread_rwlock with error \(err)")
    }

    /// Release the lock.
    ///
    /// Whenever possible, consider using `withReaderLock` and `withWriterLock`
    /// instead of this method and `lockRead` and `lockWrite`, to simplify lock
    /// handling.
    func unlock() {
        let err = pthread_rwlock_unlock(rwlock)
        precondition(err == 0, "\(#function) failed in pthread_rwlock with error \(err)")
    }
}

public extension ReadWriteLock {
    /// Acquire the reader lock for the duration of the given block.
    ///
    /// This convenience method should be preferred to `lockRead` and `unlock`
    /// in most situations, as it ensures that the lock will be released
    /// regardless of how `body` exits.
    ///
    /// - Parameter body: The block to execute while holding the reader lock.
    /// - Returns: The value returned by the block.
    @inlinable
    func withReaderLock<T>(_ body: () throws -> T) rethrows -> T {
        lockRead()
        defer { unlock() }
        return try body()
    }

    /// Acquire the writer lock for the duration of the given block.
    ///
    /// This convenience method should be preferred to `lockWrite` and `unlock`
    /// in most situations, as it ensures that the lock will be released
    /// regardless of how `body` exits.
    ///
    /// - Parameter body: The block to execute while holding the writer lock.
    /// - Returns: The value returned by the block.
    @inlinable
    func withWriterLock<T>(_ body: () throws -> T) rethrows -> T {
        lockWrite()
        defer { unlock() }
        return try body()
    }

    // specialise Void return (for performance)
    @inlinable
    func withReaderLockVoid(_ body: () throws -> Void) rethrows {
        try withReaderLock(body)
    }

    // specialise Void return (for performance)
    @inlinable
    func withWriterLockVoid(_ body: () throws -> Void) rethrows {
        try withWriterLock(body)
    }
}
