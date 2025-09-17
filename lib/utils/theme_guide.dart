// Theme Guide for BudgetBee App
// This file provides guidelines for implementing theme-aware UI components


/// Theme Guide for BudgetBee Application
/// 
/// This guide provides best practices for implementing theme-aware components
/// throughout the BudgetBee application.
/// 
/// ## Key Principles:
/// 1. Always use Theme.of(context) instead of hardcoded colors
/// 2. Use semantic color names (primaryColor, cardColor, etc.)
/// 3. Test both light and dark themes
/// 4. Use system theme mode for automatic switching
/// 
/// ## Common Theme Properties:
/// 
/// ### Colors:
/// - Theme.of(context).primaryColor - Main brand color (gold/yellow)
/// - Theme.of(context).scaffoldBackgroundColor - Main background
/// - Theme.of(context).cardColor - Card backgrounds
/// - Theme.of(context).dividerColor - Dividers and borders
/// 
/// ### Text Colors:
/// - Theme.of(context).textTheme.bodyLarge?.color - Primary text
/// - Theme.of(context).textTheme.bodyMedium?.color - Secondary text
/// - Theme.of(context).textTheme.bodySmall?.color - Tertiary text
/// 
/// ## Implementation Examples:
/// 
/// ### ✅ Good - Theme-aware:
/// ```dart
/// Container(
///   color: Theme.of(context).cardColor,
///   child: Text(
///     'Hello',
///     style: TextStyle(
///       color: Theme.of(context).textTheme.bodyLarge?.color,
///     ),
///   ),
/// )
/// ```
/// 
/// ### ❌ Bad - Hardcoded:
/// ```dart
/// Container(
///   color: const Color(0xFF2A2A2A),
///   child: const Text(
///     'Hello',
///     style: TextStyle(color: Colors.white),
///   ),
/// )
/// ```
/// 
/// ## Component Guidelines:
/// 
/// ### Scaffolds:
/// - Remove backgroundColor from Scaffold (uses theme automatically)
/// - Use Theme.of(context).scaffoldBackgroundColor if needed
/// 
/// ### AppBars:
/// - Remove backgroundColor and foregroundColor
/// - Use Theme.of(context).appBarTheme automatically
/// 
/// ### Cards:
/// - Use Theme.of(context).cardColor for backgrounds
/// - Use Card widget instead of Container with decoration
/// 
/// ### Buttons:
/// - Use ElevatedButton, TextButton, etc. (theme-aware by default)
/// - Remove custom backgroundColor/foregroundColor
/// 
/// ### Dialogs:
/// - Remove backgroundColor from AlertDialog
/// - Use default theme colors
/// 
/// ### Progress Indicators:
/// - Use Theme.of(context).primaryColor for valueColor
/// - Use Theme.of(context).textTheme.bodySmall?.color for backgroundColor
/// 
/// ## Testing Checklist:
/// - [ ] Test in light mode
/// - [ ] Test in dark mode  
/// - [ ] Test in system mode
/// - [ ] Verify all text is readable
/// - [ ] Check contrast ratios
/// - [ ] Test theme switching
/// 
/// ## Future Development:
/// When adding new screens or components:
/// 1. Follow this guide
/// 2. Use theme properties instead of hardcoded colors
/// 3. Test in all theme modes
/// 4. Update this guide if new patterns emerge
/// 
/// ## Theme Provider Usage:
/// ```dart
/// Consumer<ThemeProvider>(
///   builder: (context, themeProvider, child) {
///     return YourWidget();
///   },
/// )
/// ```
/// 
/// ## Theme Mode Selection:
/// - AppThemeMode.light - Always light theme
/// - AppThemeMode.dark - Always dark theme  
/// - AppThemeMode.system - Follow system setting (recommended)
/// 
/// This guide ensures consistent theming across the entire application
/// and provides a foundation for future development.
