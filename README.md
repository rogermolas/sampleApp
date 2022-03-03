
# Currency Converter


## Appendix

Build using Swift 5.0, 
XCode 13, Cocoapods Dependency Manager, MVP design pattern


## Features

- Dynamic Supported currencies (e.g EUR, USD, JPY)
- List of Main Wallet
- Dynamic Commision fee
- Summary Screen


## Library / Frameworks

**RMHTTP:** Use to send request in API server for conversion.

**ActionSheetPicker-3.0:** Use to select currency.

**MBProgressHUD:** Loading indicator UI

**CurrencyText:** Currency formatted textfield
## Adding Currency

Add new element for `supported` array
```swift
struct Currency {
    static let supported = ["EUR", "USD", "JPY"]
}
```


## Commision Fee

Add new currency and return a Tuples of pecentage.
Three types of percentage if amount is less than or 
equal `100`, greater than `500`, `1000` up is free


```swift
    var pecentage: (Double, Double) {
        switch currency {
        case "EUR":
            return (0.3, 0.2)
        case "USD":
            return (0.2, 0.09)
        case "JPY":
            return (0.5, 0.3)
        default: // other currencies
            return (0.2, 0.2)
        }
    }
```


## Development

I spent 2-3 hours a day for 5 task in 5 days

- UI/UX, Classes, Models, Tables
- Basic Logic add minus banlance , Local storage
- API Request, Model, Conversion Logic
- Error handling, View logic, Alerts
- Bug fix, UI polishing


## 🚀 About Me
I'm a iOS developer based in the Philippines, working remotely for 
international clients since 2010.

