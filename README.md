

# **GIAppDebugConsole**

This package can help you (or testers/QA/TM in your team) to do on-device debugging with easy. It can show PiP-style console that can display any meaningful info that you need. Also you can add custom actions to the console menu, for facilitating some useful routine for testing (to copy push/fcm token for example).

This project was inspared by [LocalConsole](https://github.com/duraidabdul/LocalConsole) from Duraid Abdul. But it supports only iOS 14+, you can't add your actions, but can dynamically display view frames and restart SpringBoard. This project supports iOS 11+.

<div>
  <img src="https://user-images.githubusercontent.com/4835671/120287761-0014ff80-c2d9-11eb-8202-ddae8ee911aa.mp4" width="320">
  <img src="https://user-images.githubusercontent.com/4835671/120646244-c1c34000-c492-11eb-8b11-10e65d879db8.mov" width="320">
</div>


## **Setup**

1. In your Xcode project, navigate to File > Swift Packages > Add Package Dependency...

2. Paste the following into the URL field: https://github.com/Dalein/GIAppDebugConsole.git

3. Once the package dependency has been added, you can import GIAppDebugConsole.


## **Usage**

To show console you can call it from anywhere: 
```swift
GIAppDebugConsole.shared.show()
```

To log something: 
```swift
GIAppDebugConsole.shared.log("test")
```

Or attributed string:
```swift
GIAppDebugConsole.shared.logAttributed(.init(string: "My super log", attributes: [.foregroundColor: UIColor.red]))
```

It's safe to log simultaneously string and NSAttributedString.

By default console has two actions in menu: *Clear console* and *Copy*.
You can add your own actions like this:

```swift
GIAppDebugConsole.shared.addAction(.init(title: "Copy Push token", handler: { [weak self] in
    self?.copyPushToken()
}))
        
GIAppDebugConsole.shared.addAction(.init(title: "Do a barrel roll", handler: { [weak self] in
    self?.doBarrelRoll()
}))
```

Console is fully customazible, you can setup it UI as you wish. You can adjust all, or only interesting you settings (all has default values). Call it before first console show. Fully setup can look like this:

```swift
GIAppDebugConsoleConfigurator.configureAppDebugConsole(
            consoleUIConfig: .init(consoleDefaultSize: .init(width: 300, height: 200),
                                   consoleMaxSize: .init(width: 500, height: 500),
                                   consoleBackgroundColor: .red,
                                   textColor: .white,
                                   font: .systemFont(ofSize: 20, weight: .bold),
                                   menuButtonConfig: .init(size: .init(width: 50, height: 50),
                                                           backgroundColor: .black,
                                                           image: .init(named: "ellipsis"),
                                                           title: nil,
                                                           tintColor: .blue, alpha: 0.7)))
```



Example project can be found [here](https://github.com/Dalein/GIAppDebugConsoleUsageExample).
