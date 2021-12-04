//
//  Debug.swift
//  Debug
//
//  Created by Stuart Rankin on 7/18/21. Adapted from Flatland View.
//

import Foundation

class Debug
{
    /// Dumps simple version information to the program's debug window/log.
    public static func DumpVersion()
    {
        #if DEBUG
        let Line1 = Versioning.ApplicationName
        let Line2 = " Version: \(Versioning.VerySimpleVersionString()), Build \(Versioning.Build)"
        let Line3 = " Built: \(Versioning.BuildDate), \(Versioning.BuildTime)"
        Debug.Print(Line1)
        Debug.Print(Line2)
        Debug.Print(Line3)
        #endif
    }
    
    /// Returns debug function availability. The value returned depends on how the code was compiled.
    public static var DebugAvailable: Bool
    {
        get
        {
#if DEBUG
            return true
#else
            return false
#endif
        }
    }
    
    /// Thin wrapper around `fatalError` to record extra information.
    /// - Note: If compiled with `#DEBUG` on, a stack track is dumped to the debug console. If `#DEBUG` is off,
    ///         the caller is prepended to `Message` and `fatalError` is called.
    /// - Parameter Message: The message to send to `fatalError`.
    /// - Returns: Never returns.
    public static func FatalError(_ Message: String) -> Never
    {
        let Caller = PrettyStackTrace(StackFrameContents(1))
#if DEBUG
        let Trace = PrettyStackTrace(StackFrameContents(10))
        print("Fatal error: stack trace: \(Trace)")
        fatalError(Message)
#else
        fatalError("\(Caller): \(Message)")
#endif
    }
    
    private static var PrintGate = NSObject()
    
    /// Print a message to the debug console prefixed by the time this function was called.
    /// - Note: If compiled with #DEBUG on, the message will be prefixed with a time stamp and saved in the
    ///         cumulative log list. If #DEBUG is false, the message will be printed in the debug console.
    /// - Parameter Message: The message to print.
    public static func Print(_ Message: String)
    {
        objc_sync_enter(PrintGate)
        defer{objc_sync_exit(PrintGate)}
#if DEBUG
        let Prefix = Utility.MakeTimeString(TheDate: Date())
        print("\(Prefix): \(Message)")
        Log.append((TimeStamp: Prefix, Payload: Message))
#else
        print(Message)
#endif
    }
    
    /// Holds the log.
    private static var Log = [(TimeStamp: String, Payload: String)]()
    
    /// Unconditionally removes all entries in the log.
    public static func ClearLog()
    {
        Log.removeAll()
    }
    
    /// Returns the contents of the log.
    /// - Note: If not compiled in #DEBUG, an empty array is returned.
    /// - Returns: Array of tuples, the first element being the string value timestamp and the second the text.
    public static func GetLog() -> [(TimeStamp: String, Payload: String)]
    {
#if DEBUG
        return Log
#else
        return [(String, String)]()
#endif
    }
    
    /// Return the specified number of stack frames. The first frame (which is a call to here (`StackFrameContents`)) is not
    /// included in the returned list.
    /// - Parameter Count: The number of stack frames to return.
    /// - Returns: List of stack frames, not counting the one for the call to this function.
    public static func StackFrameContents(_ Count: Int) -> [DemangledSymbol]
    {
        let Raw = Thread.callStackSymbols
        var Results = [DemangledSymbol]()
        for RawValue in Raw
        {
            if let Demangled = DemangleSymbol(Raw: RawValue)
            {
                Results.append(Demangled)
            }
        }
        Results.removeFirst()
        if Results.count < Count
        {
            return Results
        }
        var ReducedResults = [DemangledSymbol]()
        for _ in 0 ..< Count
        {
            ReducedResults.append(Results.remove(at: 0))
        }
        return ReducedResults
    }
    
    /// Demangle the stack from symbol.
    /// - Parameter Raw: The raw stack from dump.
    /// - Returns: Demangled stack frame structure.
    private static func DemangleSymbol(Raw Symbol: String) -> DemangledSymbol?
    {
        let Parts = Symbol.split(separator: " ", omittingEmptySubsequences: true)
        if Parts.count != 6
        {
            return nil
        }
        
        var ModuleName: String = ""
        var ClassName: String = ""
        var FunctionName: String = ""
        
        let Address = String(Parts[2])
        let RawOffset = String(Parts[5])
        var FinalOffset = 0
        if let Offset = Int(RawOffset)
        {
            FinalOffset = Offset
        }
        
        let Exceptions = ["UIKit", "CoreFoundation", "HIToolbox", "libdyld.dylib",
                          "libdispatch.dylib", "libclang_rt.asan_osx_dynamic.dylib"]
        if Exceptions.contains(String(Parts[1]))
        {
            FunctionName = String(Parts[3])
            ModuleName = String(Parts[1])
        }
        
        if let Demangled = SplitMangled(Symbol: String(Parts[3]))
        {
            for (EntityType, EntityValue) in Demangled
            {
                switch EntityType
                {
                    case .Class:
                        ClassName = EntityValue
                        
                    case .Function:
                        FunctionName = EntityValue
                        
                    case .Module:
                        ModuleName = EntityValue
                        
                    default:
                        continue
                }
            }
        }
        else
        {
            return nil
        }
        
        return DemangledSymbol(ModuleName: ModuleName, ClassName: ClassName, FunctionName: FunctionName,
                               Address: Address, Offset: FinalOffset, Source: Symbol)
    }
    
    /// Split a mangled module/class/function name up into its component parts.
    /// - Note: See [Name Mangling](https://github.com/apple/swift/blob/master/docs/ABI/Mangling.rst)
    /// - Parameter Symbol. The symbol to split.
    /// - Returns: Dictionary of demangled entities.
    private static func SplitMangled(Symbol: String) -> [MangledEntities: String]?
    {
        var EntityDictionary = [MangledEntities: String]()
        
        var Working = Symbol
        if Working.prefix(2) == MangledEntities.StableMangling.rawValue
        {
            Working.removeFirst(MangledEntities.StableMangling.rawValue.count)
            let (NameCount, Updated0) = LeadingNumber(From: Working)
            if NameCount == nil || NameCount == 0
            {
                return nil
            }
            let MName = String(Updated0.prefix(NameCount!))
            Working = Updated0
            Working.removeFirst(NameCount!)
            
            let (ClassCount, Updated1) = LeadingNumber(From: Working)
            if ClassCount == nil || ClassCount == 0
            {
                return nil
            }
            let CName = String(Updated1.prefix(ClassCount!))
            Working = Updated1
            Working.removeFirst(ClassCount! + 1)
            
            let (FunctionCount, Updated2) = LeadingNumber(From: Working)
            if FunctionCount == nil || FunctionCount == 0
            {
                return nil
            }
            let FName = String(Updated2.prefix(FunctionCount!))
            Working = Updated2
            Working.removeFirst(FunctionCount!)
            
            EntityDictionary[.Class] = String(CName)
            EntityDictionary[.Function] = String(FName)
            EntityDictionary[.Module] = String(MName)
        }
        
        return EntityDictionary
    }
    
    /// Returns the leading number from the passed string as well as the remainder of the string after the
    /// number has been returned.
    /// - Parameter From: The string to parse/modify.
    /// - Returns: Tuple with the value of the leading number and the remainder of the string once the number
    ///            has been removed. If the number cannot be parsed, the returned number is nil and the returned
    ///            string is the same as `From`.
    private static func LeadingNumber(From: String) -> (Value: Int?, Remainder: String)
    {
        var NumCount = 0
        for Char in From
        {
            if Char.isNumber
            {
                NumCount = NumCount + 1
            }
            else
            {
                break
            }
        }
        if NumCount == 0
        {
            return (nil, From)
        }
        var Working = From
        let RawNumber = Working.prefix(NumCount)
        var FinalNumber = 0
        if let SomeNumber = Int(RawNumber)
        {
            FinalNumber = SomeNumber
        }
        else
        {
            return (nil, From)
        }
        Working.removeFirst(NumCount)
        return (FinalNumber, Working)
    }
    
    /// Holds a single stack frame's worth of demangled data.
    struct DemangledSymbol
    {
        /// Module name.
        let ModuleName: String
        
        /// Class name.
        let ClassName: String
        
        /// Function name.
        let FunctionName: String
        
        /// Address.
        let Address: String
        
        /// Offset.
        let Offset: Int
        
        /// Original source line.
        let Source: String
    }
    
    /// Return a pretty string of the passed set of stack frames.
    /// - Parameter From: Array of stack frame information.
    /// - Returns: Pretty string of the contents of `From`.
    public static func PrettyStackTrace(_ From: [DemangledSymbol]) -> String
    {
        var Results = ""
        for Index in 0 ..< From.count
        {
            if From[Index].FunctionName.isEmpty
            {
                continue
            }
            if !From[Index].ClassName.isEmpty
            {
                Results.append(From[Index].ClassName)
                Results.append(".")
            }
            Results.append(From[Index].FunctionName)
            if Index < From.count - 1
            {
                Results.append(" ← ")
            }
        }
        return Results
    }
}

/// Defines various mangled entities.
enum MangledEntities: String, CaseIterable
{
    /// Stable mangling.
    case StableMangling = "$s"
    
    /// Module.
    case Module = "Module"
    
    /// Class.
    case Class = "C"
    
    /// Function.
    case Function = "Function"
}
