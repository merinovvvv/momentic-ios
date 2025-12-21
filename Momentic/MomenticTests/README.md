# Momentic Tests

This directory contains unit tests and component tests for the Momentic iOS application.

## Test Structure

### Unit Tests (`MomenticTests/`)

#### ViewModels
- `LoginViewModelTests.swift` - Tests for login functionality and validation
- `RegisterViewModelTests.swift` - Tests for registration functionality
- `ProfileInfoViewModelTests.swift` - Tests for profile information validation
- `VerificationCodeViewModelTests.swift` - Tests for verification code flow
- `AddPhotoViewModelTests.swift` - Tests for photo upload functionality

#### Network
- `NetworkHandlerTests.swift` - Tests for network request handling
- `LoggingServiceTests.swift` - Tests for logging service

#### Models
- `AccessTokenStorageTests.swift` - Tests for token storage (Keychain operations)

#### Validation
- `AuthViewModelProtocolTests.swift` - Tests for email and password validation logic

### Component/UI Tests (`MomenticUITests/`)

- `MomenticUITests.swift` - Basic UI tests and launch performance
- `AuthFlowUITests.swift` - Authentication flow UI tests

### Mocks (`MomenticTests/Mocks/`)

- `MockNetworkHandler.swift` - Mock network handler for testing
- `MockAccessTokenStorage.swift` - Mock token storage for testing
- `MockLoggingService.swift` - Mock logging service (if needed)

## Running Tests

### In Xcode
1. Open the project in Xcode
2. Press `Cmd + U` to run all tests
3. Or use the Test Navigator (Cmd + 6) to run specific tests

### Command Line
```bash
xcodebuild test -scheme Momentic -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Test Coverage

The test suite covers:
- ✅ ViewModel business logic
- ✅ Validation logic (email, password, profile fields)
- ✅ Network request handling
- ✅ Token storage operations
- ✅ Error handling
- ✅ UI component interactions (basic)

## Notes

- Some tests use `@testable import Momentic` to access internal members
- Mock objects are used to isolate units under test
- UI tests may need adjustment based on actual UI element identifiers
- Network tests use `MockURLProtocol` to simulate network responses

## Adding New Tests

When adding new features:
1. Create corresponding test files in the appropriate directory
2. Use mocks for dependencies
3. Follow the Arrange-Act-Assert pattern
4. Use descriptive test names that explain what is being tested

