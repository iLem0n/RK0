//
//  ValueStepper.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 12.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

#if os(iOS)
import UIKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

extension Reactive where Base: TextStepper {
    var index: ControlProperty<Int> {
        return Base.value(
            control: self.base,
            getter: { (control) -> Int in
                control.selectedIndex as Int
            },
            setter: { (control, value) in
                control.selectedIndex = value
            })
    }
}

extension TextStepper {
    static func value<T, ControlType: UIControl>(
        control: ControlType,
        getter: @escaping (ControlType) -> T,
        setter: @escaping (ControlType, T) -> Void) -> ControlProperty<T> {
        let values: Observable<T> = Observable.deferred { [weak control] in
            guard let strong = control else {
                return Observable.empty()
            }
            
            return strong.rx
                .controlEvent([.valueChanged])
                .flatMap { _ in
                    return control.map { Observable.just(getter($0)) } ?? Observable.empty()
                }
                .startWith(getter(strong))
        }
        
        return ControlProperty(
            values: values,
            valueSink: Binder(control) { (control, value) in
                setter(control, value)
            }
        )
    }
}
#endif

final class TextStepper: UIControl {
    var loops: Bool
    var values: [String]
    var selectedIndex: Int {
        didSet {
            guard self.subviewsInitialized, self.selectedIndex < self.values.count else { return }
            self.valueLabel.text = "\(values[self.selectedIndex])"
            
        }
    }
    
    private var valueLabel: UILabel!
    private var decrementButton: UIButton!
    private var incrementButton: UIButton!
    private var subviewsInitialized: Bool = false
    
    init(frame: CGRect,
         values: [String],
         index: Int = 0,
         loops: Bool = true) {
        self.loops = loops
        self.values = values
        self.selectedIndex = index
        super.init(frame: frame)
        self.initializeSubviews()
        self.configureAppeareance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.loops = false
        self.values = []
        self.selectedIndex = 0
        super.init(coder: aDecoder)
        self.initializeSubviews()
        self.configureAppeareance()
        
    }
    
    private func initializeSubviews() {
        self.valueLabel = UILabel(frame: .zero)
        if self.selectedIndex < self.values.count {
            self.valueLabel.text = "\(self.values[self.selectedIndex])"
        }
        self.valueLabel.textColor = .blue
        self.valueLabel.textAlignment = .center
        
        self.decrementButton = UIButton(type: .custom)
        self.decrementButton.addTarget(self, action: #selector(TextStepper.decrementValue), for: .touchUpInside)
        self.decrementButton.setTitle("-", for: .normal)
        self.decrementButton.setTitleColor(.blue, for: .normal)
        
        self.incrementButton = UIButton(type: .custom)
        self.incrementButton.addTarget(self, action: #selector(TextStepper.incrementValue), for: .touchUpInside)
        self.incrementButton.setTitle("+", for: .normal)
        self.incrementButton.setTitleColor(.blue, for: .normal)
        
        let stack = UIStackView(arrangedSubviews: [
            self.decrementButton,
            VerticalLine(),
            self.valueLabel,
            VerticalLine(),
            self.incrementButton
            ])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.backgroundColor = .green
        
        self.addSubview(stack)
        self.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.widthAnchor.constraint(equalToConstant: 180).isActive = true
        
        self.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: stack.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
        self.subviewsInitialized = true
    }
    
    private func configureAppeareance() {
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = self.frame.height / 6.0
    }
    
    @objc private func decrementValue() {
        var newVal = self.selectedIndex - 1
        if newVal < 0 {
            newVal = loops ? self.values.count - 1 : 0
        } else {
            self.selectedIndex = newVal
        }
    }
    
    @objc private func incrementValue() {
        var newVal = self.selectedIndex + 1
        if newVal > self.values.count - 1 && loops {
            newVal = 0
        }
        guard newVal < self.values.count else { return }
        self.selectedIndex = newVal
    }
}
