---
name: flutter-design
description: Flutter 앱의 UI를 만들 때 사용. 일반적인 AI 생성 디자인 패턴을 피하고 세련되고 독창적인 Flutter UI를 생성. Use when building Flutter widgets, screens, or components.
---

# Flutter Design Skill

You tend to converge toward generic, "on distribution" outputs when building Flutter UIs. This creates bland, Material-default interfaces that all look the same. Avoid this: create distinctive, polished Flutter interfaces that feel genuinely designed.

## Typography

Choose fonts that elevate the app's personality. Avoid relying solely on the default Roboto.

- Use Google Fonts package (`google_fonts`) for variety
- Pair fonts with high contrast: display + monospace, serif + geometric sans
- Use extreme weight differences: w100/w200 vs w700/w900, not w400 vs w500
- Size jumps of 2.5x+ for hierarchy, not incremental 1.2x steps

## Color & Theme

Commit to a cohesive, intentional palette. Use `ThemeData` and `ColorScheme` for consistency.

- Define a clear primary, secondary, and accent — don't spread colors evenly
- Use `Color.fromRGBO()` or hex extensions, not `Colors.blue.shade300`
- Apply opacity and tints purposefully for depth (surface layers, cards, overlays)
- Dark mode isn't just inverted colors — rethink elevation, contrast, and emphasis
- Avoid the Material default blue/purple unless it's a deliberate choice

## Layout & Spacing

Think in systems, not arbitrary values.

- Use consistent spacing scale (4, 8, 12, 16, 24, 32, 48)
- Generous padding > cramped layouts. White space is a feature
- Use `SliverAppBar`, `CustomScrollView` for rich scroll experiences
- Prefer `Padding` + `Column`/`Row` over deep `Container` nesting
- Use `ConstrainedBox` and `SizedBox` for intentional sizing

## Motion & Animation

Subtle motion adds significant polish.

- `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSlide` for implicit animations
- `Hero` widgets for meaningful page transitions
- Staggered list animations with `AnimationController` + `Interval`
- Page transitions: use `PageRouteBuilder` with custom curves
- Prefer `Curves.easeOutCubic`, `Curves.easeInOutQuart` over linear
- Keep durations tight: 200-400ms for micro-interactions, 400-600ms for transitions

## Components & Patterns

Build components that feel crafted, not assembled.

- Custom `Card` designs with layered shadows, not default `elevation: 2`
- Use `ClipRRect` with meaningful border radius (12-20 for cards, 8-12 for buttons)
- `BackdropFilter` for glassmorphism effects where appropriate
- Custom `BottomSheet` with drag handle and smooth curves
- `Shimmer` effects for loading states instead of plain `CircularProgressIndicator`
- Use `DecoratedBox` with gradients for rich backgrounds

## Avoid Generic AI Patterns

- Default Material widgets without customization (`ElevatedButton`, `Card` with no styling)
- `Colors.blue`, `Colors.purple` as primary without theming
- Flat, single-color backgrounds with no depth
- Uniform spacing and sizing that creates a "spreadsheet" feel
- Over-reliance on `ListTile` for everything — build custom list items
- `AppBar` with just a title and no personality

## Flutter-Specific Best Practices

- Use `flutter_screenutil` for responsive sizing (.w, .h, .sp)
- Extract reusable widgets into separate files
- Prefer `const` constructors for performance
- Use `Theme.of(context)` for consistent theming access
- Keep widget trees shallow — extract when nesting exceeds 3-4 levels
