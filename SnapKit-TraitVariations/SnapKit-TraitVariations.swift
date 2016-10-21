//
//  SnapKit-TraitVariations.swift
//  SnapKit-TraitVariations
//
//  Created by Fin on 16/10/21.
//  Copyright © 2016年 Fin All rights reserved.
//

import UIKit
import SnapKit
import Aspects

/// Provides methods for manual Trait Variations
public final class TraitVariations<T>{
    public let base: T
    public init(_ base: T){
        self.base = base;
    }
}

private var traitDictionaryKey: Void?

public protocol TraitVariationsCompatible {
    associatedtype T
    var kv: T { get }
}
public extension TraitVariationsCompatible {
    public var kv:TraitVariations<Self> {
        get{ return TraitVariations(self) }
    }
}

//MARK: -  UIView

extension UIView: TraitVariationsCompatible{
    
}

extension TraitVariations where T : UIView {
    public var wC:TraitMakerExtendable {
        return self.make(traitAttribute: .wC);
    }
    public var wR:TraitMakerExtendable {
        return self.make(traitAttribute: .wR);
    }
    public var hC:TraitMakerExtendable {
        return self.make(traitAttribute: .hC);
    }
    public var hR:TraitMakerExtendable {
        return self.make(traitAttribute: .hR);
    }
    internal func make( traitAttribute: TraitAttributes) ->TraitMakerExtendable{
        return TraitMakerExtendable(traitAttribute,self.base){(traitMaker,constraints)in
            self.completion(traitMaker, constraints: constraints)
        }
    }
    
    
    internal var traitDictionary: NSMutableDictionary? {
        return objc_getAssociatedObject(base, &traitDictionaryKey) as? NSMutableDictionary
    }
    
    internal func setTraitDictionary(_ traitDictionary: NSMutableDictionary) {
        objc_setAssociatedObject(base, &traitDictionaryKey, traitDictionary, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func setupView() {
        self.setTraitDictionary(NSMutableDictionary())
        
        
        let closure: ((Void)->Void) = {
            self.activateIfNeed()
        }
        let block: @convention(block) (Void) -> Void = closure
        let objectBlock = unsafeBitCast(block, to: AnyObject.self)
        do { try self.base.aspect_hook(#selector(UIView.traitCollectionDidChange(_:)), with: AspectOptions(rawValue: 0), usingBlock: objectBlock) }
        catch _ {}
    }
    func completion(_ traitMaker:TraitMakerExtendable , constraints: [Constraint]){
        if self.traitDictionary == nil {
            self.setupView()
        }
        let key = NSString(string: "\(traitMaker.attributes.rawValue)")
        self.traitDictionary?.setObject(constraints, forKey: key)
    }
    
    func activateIfNeed(){
        guard let dict = self.traitDictionary else {
            return;
        }
        self.base.snp.removeConstraints()
        for (key,value) in dict {
            let constraintAttr = TraitAttributes(rawValue: UInt(key as! String)!)
            print("c:" , constraintAttr.rawValue)
            var viewAttr = TraitAttributes(rawValue: 0);
            let arr = [.wC, .wR, .hC, .hR] as [TraitAttributes]
            viewAttr += arr[self.base.traitCollection.horizontalSizeClass.rawValue - 1]
            viewAttr += arr[(self.base.traitCollection.verticalSizeClass.rawValue - 1) + 2]
            print("viewAttr:" , viewAttr.rawValue)
            if viewAttr.contains(constraintAttr){
                (value as! [Constraint]).forEach({ (constraint) in
                    constraint.activate();
                })
            }
        }
    }
}

//MARK: - Trait
internal struct TraitAttributes: OptionSet {
    internal private(set) var rawValue: UInt
    internal init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    internal init(_ rawValue: UInt) {
        self.init(rawValue: rawValue)
    }
    
    internal static var wC: TraitAttributes { return self.init(1) }
    internal static var wR: TraitAttributes { return self.init(2) }
    internal static var hC: TraitAttributes {  return self.init(4) }
    internal static var hR: TraitAttributes { return self.init(8) }
    
    internal static var wChC: TraitAttributes { return self.init(5) }
    internal static var wChR: TraitAttributes { return self.init(9) }
    internal static var wRhC: TraitAttributes { return self.init(6) }
    internal static var wRhR: TraitAttributes { return self.init(10) }
    
}

internal func + (left: TraitAttributes, right: TraitAttributes) -> TraitAttributes {
    return left.union(right)
}
internal func +=(left: inout TraitAttributes, right: TraitAttributes) {
    left.formUnion(right)
}
internal func -=(left: inout TraitAttributes, right: TraitAttributes) {
    left.subtract(right)
}
internal func ==(left: TraitAttributes, right: TraitAttributes) -> Bool {
    return left.rawValue == right.rawValue
}

typealias CompletionHandlerClosure = (_ traitMaker:TraitMakerExtendable , _ constraints: [Constraint]) -> Void
public class TraitMakerExtendable {
    internal var attributes: TraitAttributes
    internal weak var view: UIView?
    internal init(_ attributes: TraitAttributes , _ view: UIView , _ handler: @escaping CompletionHandlerClosure ) {
        self.attributes = attributes
        self.completionHandler = handler
        self.view = view
    }
    
    internal var completionHandler: CompletionHandlerClosure
    public var wC:TraitMakerExtendable {
        self.attributes += .wC;
        return self;
    }
    public var wR:TraitMakerExtendable {
        self.attributes += .wR;
        return self;
    }
    public var hC:TraitMakerExtendable {
        self.attributes += .hC;
        return self;
    }
    public var hR:TraitMakerExtendable {
        self.attributes += .hR;
        return self;
    }
    
    public func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void){
        guard let view = self.view else {
            return
        }
        
        let constraints = view.snp.prepareConstraints { (make) in
            closure(make)
        }
        
        completionHandler(self,constraints)
    }
}

