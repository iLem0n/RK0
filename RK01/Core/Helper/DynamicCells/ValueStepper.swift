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

extension Reactive where Base: ValueStepper {
    var value: ControlProperty<Double> {
        return Base.value(
            control: self.base,
            getter: { (control) -> Double in
                control.value
            },
            setter: { (control, value) in
                control.value = value
            })
    }
}

extension ValueStepper {
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

final class ValueStepper: UIControl {
    var minimumValue: Double
    var maximumValue: Double
    var stepValue: Double
    var value: Double {
        didSet {
            guard oldValue != value, self.subviewsInitialized else { return }
            log.debug("value: \(oldValue) -> \(value)")
            self.valueLabel.text = "\(value)"
            self.sendActions(for: .valueChanged)
        }
    }
    
    private var valueLabel: UILabel!
    private var decrementButton: UIButton!
    private var incrementButton: UIButton!
    private var subviewsInitialized: Bool = false
    private let disposeBag = DisposeBag()
    
    init(frame: CGRect,
         minimumValue: Double = 1.0,
         maximumValue: Double = 10.0,
         stepValue: Double = 1.0,
         initalValue: Double = 0.0) {
        
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.stepValue = stepValue
        self.value = initalValue
        super.init(frame: frame)
        self.initializeSubviews()
        self.configureAppeareance()
        self.linkProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.minimumValue = 1.0
        self.maximumValue = 10.0
        self.stepValue = 1.0
        self.value = 0.0
        super.init(coder: aDecoder)
        self.initializeSubviews()
        self.configureAppeareance()
        self.linkProperties()
    }
    
    private func linkProperties() {
        self.rx.value
            .debug("Value")
            .map({
                log.debug("\($0) ==? \(self.maximumValue) = \($0 >= self.maximumValue)")
                return $0 >= self.maximumValue
            })
            .debug("isMin")
            .map({ !$0 })
            .debug("IncrementButton Enabled")
            .bind(to: self.incrementButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.rx.value
            .map({ $0 <= self.minimumValue })
            .map({ !$0 })
            .bind(to: self.decrementButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func initializeSubviews() {
        self.valueLabel = UILabel(frame: .zero)
        self.valueLabel.text = "\(value)"
        self.valueLabel.textColor = .blue
        self.valueLabel.textAlignment = .center
        
        self.decrementButton = UIButton(type: .custom)
        self.decrementButton.addTarget(self, action: #selector(ValueStepper.decrementValue), for: .touchUpInside)
        self.decrementButton.setTitle("-", for: .normal)
        self.decrementButton.setTitleColor(.blue, for: .normal)
        
        self.incrementButton = UIButton(type: .custom)
        self.incrementButton.addTarget(self, action: #selector(ValueStepper.incrementValue), for: .touchUpInside)
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
        
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: stack.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
        self.subviewsInitialized = true
    }
    
    private func configureAppeareance() {
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 0.75
        self.layer.cornerRadius = self.frame.height / 12.0
    }
    
    @objc private func decrementValue() {
        let newVal = self.value - self.stepValue
        guard newVal >= self.minimumValue else { return }
        self.value = newVal
    }
    
    @objc private func incrementValue() {
        let newVal = self.value + self.stepValue
        guard newVal <= self.maximumValue else { return }
        self.value = newVal
    }
}
