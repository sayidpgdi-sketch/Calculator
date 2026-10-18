# Calculator

A Flutter calculator app based on the supplied Figma community design. The UI follows the dark charcoal and electric-blue visual style, rounded keypad, and large right-aligned display.

## Features

- Responsive, mobile-first calculator layout
- Addition, subtraction, multiplication, division and decimals
- Clear, sign toggle, percent and live result preview
- Backspace-ready keypad layout and error handling
- No third-party runtime packages

## Run locally

Install Flutter, then from the repository root:

```bash
flutter pub get
flutter run
```

Run checks:

```bash
flutter analyze
flutter test
```

## Project layout

- `lib/main.dart` — app entry point and theme
- `lib/calculator_page.dart` — calculator interface and expression parser
- `test/widget_test.dart` — basic widget smoke test

## Design reference

[Calculator App UI Design — Figma](https://www.figma.com/design/9tjPEux0LZmhiNTs0l6efU/Calculator-App-Ui-Design-Download-Free--Community-?node-id=65-0)
