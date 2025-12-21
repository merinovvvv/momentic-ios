# Testing Guide for Momentic iOS App

## Overview

This document describes the testing strategy and implementation for the Momentic iOS application. The test suite includes both unit tests and UI/component tests.

## Test Structure

### Unit Tests (`MomenticTests/`)

#### Test Categories

1. **ViewModel Tests**
   - `LoginViewModelTests` - Tests login validation and network calls
   - `RegisterViewModelTests` - Tests registration flow
   - `ProfileInfoViewModelTests` - Tests profile validation
   - `VerificationCodeViewModelTests` - Tests verification code flow
   - `AddPhotoViewModelTests` - Tests photo upload functionality

2. **Network Tests**
   - `NetworkHandlerTests` - Tests network request handling with mocked URL sessions
   - `LoggingServiceTests` - Tests logging functionality

3. **Model Tests**
   - `AccessTokenStorageTests` - Tests Keychain token storage operations

4. **Validation Tests**
   - `AuthViewModelProtocolTests` - Tests email and password validation logic

### UI Tests (`MomenticUITests/`)

- `MomenticUITests` - Basic UI tests and launch performance
- `AuthFlowUITests` - Complete authentication flow tests

### Mock Objects (`MomenticTests/Mocks/`)

- `MockNetworkHandler` - Mock implementation of network handler
- `MockAccessTokenStorage` - Mock implementation of token storage
- `MockLoggingService` - Mock logging service for testing

## Important Notes

### Dependency Injection

The current ViewModels use concrete types (`NetworkHandler`, `AccessTokenStorage`) rather than protocols. For better testability, consider refactoring to use protocols:

```swift
// Example refactoring
protocol NetworkHandlerProtocol {
    func request(...)
}

extension NetworkHandler: NetworkHandlerProtocol {}

// Then in ViewModel
init(networkHandler: NetworkHandlerProtocol, tokenStorage: AccessTokenStorageProtocol)
```

This allows easier mocking in tests without changing the production code significantly.

### Running Tests

#### In Xcode
1. Select the test target (`MomenticTests` or `MomenticUITests`)
2. Press `Cmd + U` to run all tests
3. Or click the diamond icon next to individual test methods

#### Command Line
```bash
# Run unit tests
xcodebuild test -scheme Momentic -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:MomenticTests

# Run UI tests
xcodebuild test -scheme Momentic -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:MomenticUITests
```

## Test Coverage

### Current Coverage

- ✅ ViewModel business logic
- ✅ Input validation (email, password, profile fields)
- ✅ Network error handling
- ✅ Token storage operations
- ✅ Basic UI interactions

### Areas for Expansion

- [ ] Coordinator tests
- [ ] Factory tests
- [ ] More comprehensive UI tests
- [ ] Integration tests
- [ ] Performance tests

## Best Practices

1. **Arrange-Act-Assert Pattern**: Structure tests clearly
2. **Descriptive Names**: Test names should explain what is being tested
3. **Isolation**: Each test should be independent
4. **Mocks**: Use mocks to isolate units under test
5. **Coverage**: Aim for high code coverage on critical paths

## Example Test

```swift
func testLogin_ValidCredentials_SavesToken() {
    // Arrange
    let viewModel = LoginViewModel(networkHandler: mockNetworkHandler, tokenStorage: mockTokenStorage)
    viewModel.email = "test.user@bsu.by"
    viewModel.password = "Password123"
    mockNetworkHandler.shouldSucceed = true
    
    // Act
    viewModel.submit()
    
    // Assert
    XCTAssertEqual(mockTokenStorage.saveCallCount, 1)
}
```

## Troubleshooting

### Tests Not Running
- Ensure test target is properly configured in Xcode project
- Check that `@testable import Momentic` is present
- Verify scheme includes test targets

### Mock Issues
- Ensure mocks implement the same interface as real objects
- Check that protocols are properly defined if using protocol-based approach

### UI Test Failures
- Update UI element identifiers to match actual UI
- Ensure app launches correctly in simulator
- Check accessibility identifiers are set

## Future Improvements

1. **Protocol-Based Architecture**: Refactor ViewModels to use protocols for better testability
2. **Snapshot Testing**: Add snapshot tests for UI components
3. **Integration Tests**: Add tests that verify complete flows
4. **CI/CD Integration**: Set up automated test running in CI pipeline

