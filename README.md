# Order Book iOS App

See Live Order Book and Recent Trades of XBTUSD

## Features
- Live Order Book
- Live Recent Trades


## 🔧 Setting up Local Development

Required:

- [Xcode 14+](https://developer.apple.com/download) This project was compiled using Xcode 14.2.
- iOS 15 minimum deployment.

## Architecture
This project is following SwiftUI MVVM Design Pattern and Architecture loosely based on MVVM-based architecture from https://nalexn.github.io/clean-architecture-swiftui/.


## Project Structure

```
OrderBook                     # Root
 -[Configs]                   # Storing base URL 
 -[Extensions]                # helper functions
 -[Models]                    # Data Model structs from API
 -[Repositories]              # Endpoints and WebSocket-calling class
 -[Resources]                 # Assets Resource
 -[Views]                     # Screens, Views & ViewModels components
   -Home/         
   -OrderBook/
   -RecentTrades/
   -OrderBookApp.swift        # App entry point
```

### Built with
- **Swift 5** compiled on XCode 14.2
- **MVVM** Model-View-ViewModel Design Pattern
- **SwiftUI** Apple latest UI Framework
- **API from: wss://ws.bitmex.com**