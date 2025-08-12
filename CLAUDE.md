# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI-based Sudoku game for iOS/macOS built with Xcode. The app features sudoku puzzle generation, solving, and gameplay with note-taking functionality.

## Build and Development Commands

### Building the Project
```bash
# Build the project from command line
xcodebuild -project Sudoku-Demo.xcodeproj -scheme Sudoku-Demo -destination 'platform=iOS Simulator,name=iPhone 15' build

# Build for macOS (if supported)
xcodebuild -project Sudoku-Demo.xcodeproj -scheme Sudoku-Demo -destination 'platform=macOS' build
```

### Running the Project
- Open `Sudoku-Demo.xcodeproj` in Xcode
- Select target device/simulator
- Press Cmd+R to build and run

### Testing
No formal test suite is present in the project structure.

## Architecture Overview

### Core Components

**AppController** (`AppController.swift`)
- Main app coordinator using `@ObservableObject`
- Manages sudoku game state and persistence via UserDefaults
- Handles async sudoku generation and cancellation
- Contains references to main controllers: `SudokuController`, `DLXController`, `ColorController`

**SudokuController** (`SudokuPart/ViewModel/SudokuViewModel.swift`)
- Primary game logic controller
- Manages 9x9 game board with `Cell` objects
- Handles game states: fill mode vs note mode
- Tracks game progress, completion, and scoring
- Implements cell selection, number filling, and note-taking

**DLX Algorithm** (`DLXPart/DLX.swift`)
- Dancing Links X (DLX) implementation for sudoku solving
- Generates complete sudoku solutions
- Creates puzzle boards by removing numbers while maintaining unique solutions
- Core algorithm for puzzle generation and validation

### UI Structure

**View Hierarchy:**
- `Sudoku_DemoApp` → `HomePageView` (entry point)
- `SudokuPageView` - Main game interface
- `SudokuCellView` - Individual cell rendering
- `FillButtonView` / `FunctionButtonView` - Input controls

**Key Models:**
- `Cell` - Individual sudoku cell with position, value, notes, and visual state
- `CellList` - Manages collections of filled cells
- `UserInfo` / `Recorder` - Player statistics and game history
- `Difficulty` - Puzzle difficulty levels

### Module Organization

- **SudokuPart/**: Core game logic (Model, View, ViewModel)
- **DLXPart/**: Sudoku generation and solving algorithms  
- **HomePart/**: Home screen and navigation
- **SettingView/**: User preferences, records, and color themes

## Key Implementation Details

### State Management
- Uses SwiftUI's `@StateObject` and `@Published` for reactive UI updates
- Game state persisted automatically to UserDefaults via JSON encoding
- Timer management for gameplay duration tracking

### Sudoku Generation Process
1. Generate complete solution using randomized DLX algorithm
2. Remove numbers iteratively while ensuring unique solution
3. Validate puzzle difficulty based on number of given clues

### Cell Selection System
- Complex selection logic highlighting rows, columns, and 3x3 blocks
- Visual feedback system with multiple cell states (selected, highlighted, blank)
- Coordinate-based touch handling for cell interaction

## Refactoring Plan

This project is undergoing a comprehensive refactoring to become a polished, App Store-ready application. The refactoring is divided into multiple phases:

### Phase 1-2: Modern SwiftUI & Architecture (Current Focus)
- **iOS 18 Upgrade**: Migrate from `@ObservableObject` to new `@Observable` framework
- **MVVM Correction**: Fix current architectural issues and implement proper MVVM patterns
- **UI Redesign**: Complete visual overhaul with modern design principles
- **iOS 18 Features**: Leverage new SwiftUI capabilities and system integrations

### Phase 3: Data Layer Modernization (Future)
- **SwiftData Migration**: Replace UserDefaults persistence with SwiftData
- **Improved Data Models**: Restructure data layer for better performance and functionality

### Phase 4: Advanced Architecture (Long-term)
- **TCA Implementation**: Complete redesign using The Composable Architecture
- **Enhanced State Management**: Implement unidirectional data flow and better testability

## Development Guidelines

### Code Standards
- **Comments**: All code comments must be written in English, regardless of communication language
- **Architecture**: Follow proper MVVM patterns during refactoring
- **iOS Target**: iOS 18.0+ to utilize latest SwiftUI features
- **Dependencies**: Minimize external dependencies, prefer native frameworks

### Current Technical Debt
- Legacy MVVM implementation needs correction
- UserDefaults-based persistence is temporary
- UI design requires complete overhaul
- Missing proper separation of concerns

## Development Notes

- Target: iOS 18.0+ (as configured in project settings)
- Swift 5.0
- No external dependencies - pure SwiftUI/Foundation
- Supports both iPhone and iPad (Universal app)
- Uses automatic code signing

## Common Workflows

- **New Game Creation**: `AppController.createNewSudoku()` - async puzzle generation
- **Game Restart**: `AppController.restartSudoku()` - reset to initial state
- **Cell Interaction**: Touch handling through `SudokuController.coordinatesFromPostion()`
- **Number Input**: `SudokuController.fillAction()` or `noteAction()` depending on mode