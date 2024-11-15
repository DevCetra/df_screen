//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:df_scalable/df_scalable.dart';
import 'package:df_screen_core/df_screen_core.dart';
import 'package:meta/meta.dart';

import 'package:df_log/df_log.dart';

import '../_hidden/_index.g.dart';

import '../_index.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class AdaptiveScreenView<
        TScreen extends Screen,
        TModelScreenConfiguration extends ModelScreenConfiguration,
        TController extends ScreenController<TModelScreenConfiguration>>
    extends ScreenView<TScreen, TModelScreenConfiguration, TController> {
  //
  //
  //

  // ---------------------------------------------------------------------------

  @override
  void initState() {
    this._initScreenCapture();
    this._scheduleSideInsetsCalculation();
    super.initState();
  }

  // ---------------------------------------------------------------------------
  // Provide screen capturing functionality.
  // ---------------------------------------------------------------------------

  final _bodyCaptureKey = GlobalKey();

  static GlobalKey? _staticBody3CaptureKey;

  static Widget? _bodyCapture;

  static Widget? get bodyCapture => _bodyCapture;

  /// Captures the current screen and stores it in [bodyCapture].
  static Future<void> captureScreen(BuildContext context) async {
    if (context.mounted && _staticBody3CaptureKey != null) {
      try {
        _bodyCapture = await captureWidget(_staticBody3CaptureKey!, context);
      } catch (_) {
        // Do nothing.
      }
    }
  }

  void _initScreenCapture() {
    _staticBody3CaptureKey = this._bodyCaptureKey;
  }

  void _scheduleSideInsetsCalculation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        this._assignSideInsets();
        this._didCalculateSideInsets = true;
      });
    });
  }

  // ---------------------------------------------------------------------------
  // Get the sizes of the sides (topSide, bottomSide, leftSide, rightSide) on
  // the first frame rendered.
  // ---------------------------------------------------------------------------

  bool _didCalculateSideInsets = false;

  EdgeInsets _calculatedSideInsets = EdgeInsets.zero;

  /// Override to specify the side insets.
  EdgeInsets sideInsets(EdgeInsets calculatedSideInsets) {
    return calculatedSideInsets;
  }

  final _topSideKey = GlobalKey();
  final _bottomSideKey = GlobalKey();
  final _leftSideKey = GlobalKey();
  final _rightSideKey = GlobalKey();

  void _assignSideInsets() {
    var top = 0.0;
    var bottom = 0.0;
    var left = 0.0;
    var right = 0.0;
    try {
      final box =
          this._topSideKey.currentContext?.findRenderObject() as RenderBox?;
      top = box?.size.height ?? 0.0;
    } catch (_) {
      printYellow('Failed to calculate top insets.');
    }
    try {
      final box =
          this._bottomSideKey.currentContext?.findRenderObject() as RenderBox?;
      bottom = box?.size.height ?? 0.0;
    } catch (_) {
      printYellow('Failed to calculate bottom insets.');
    }
    try {
      final box =
          this._leftSideKey.currentContext?.findRenderObject() as RenderBox?;
      left = box?.size.width ?? 0.0;
    } catch (_) {
      printYellow('Failed to calculate left insets.');
    }
    try {
      final box =
          this._rightSideKey.currentContext?.findRenderObject() as RenderBox?;
      right = box?.size.width ?? 0.0;
    } catch (_) {
      printYellow('Failed to calculate right insets.');
    }
    this._calculatedSideInsets = EdgeInsets.only(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
    );
  }

  // ---------------------------------------------------------------------------
  // Create a display structure for the screen.
  // ---------------------------------------------------------------------------

  /// Do not override. This method invokes the necessary builders and organizes
  /// the screen layout based on the current device.
  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      maintainBottomViewPadding: true,
      child: () {
        final screenSize = MediaQuery.of(context).size;
        final calculator =
            ScreenCalculator(screenSize.width, screenSize.height);
        final appLayout = AppLayout.fromScreenCalculator(calculator);
        switch (appLayout) {
          case AppLayout.MOBILE:
            final body0 = this.mobileBody(context);
            final body5 = this._final(context, body0);
            final layout = this.mobileLayout(context, body5);
            return layout;
          case AppLayout.MOBILE_HORIZONTAL:
            final body0 = this.horizontalMobileBody(context);
            final body5 = this._final(context, body0);
            final layout = this.horizontalMobileLayout(context, body5);
            return layout;
          case AppLayout.NARROW:
            final body0 = this.narrowBody(context);
            final body5 = this._final(context, body0);
            final layout = this.narrowLayout(context, body5);
            return layout;
          case AppLayout.WIDE:
            final body0 = this.wideBody(context);
            final body5 = this._final(context, body0);
            final layout = this.wideLayout(context, body5);
            return layout;
        }
      }(),
    );
  }

  //
  //
  //

  /// Activates for mobile device screen sizes. Override to customize the
  /// layout for these sizes. The [body] includes the widget returned by
  /// [mobileLayout].
  Widget mobileLayout(BuildContext context, Widget body) {
    return this.narrowLayout(context, body);
  }

  /// Activates for mobile device screen sizes ith a horizontal orientation.
  /// Override to customize the layout for these sizes. The [body] includes the
  /// widget returned by [horizontalMobileBody].
  Widget horizontalMobileLayout(BuildContext context, Widget body) {
    return this.horizontalMobileBody(context);
  }

  /// Activates for non-mobile narrow screen sizes, such as a narrow desktop
  /// window or screen. Override to customize the layout for these sizes. The
  /// [body] includes the widget returned by [narrowBody].
  Widget narrowLayout(BuildContext context, Widget body) {
    return this.layout(context, body);
  }

  /// Activates for non-mobile wide screen sizes, such as a wide desktop
  /// window or screen. Override to customize the layout for these sizes. The
  /// [body] includes the widget returned by [wideBody].
  Widget wideLayout(BuildContext context, Widget body) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxHeight / MIN_MOBILE_ASPECT_RATIO,
                maxHeight: double.infinity,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: MSurface(
                  borderRadius: BorderRadius.circular(14.0),
                  color: Colors.transparent,
                  child: this.layout(context, body),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Activates for screen sizes that do not match the criteria for
  /// [mobileLayout], [horizontalMobileLayout], [narrowLayout], or [wideLayout].
  /// Override to customize these sizes. The [body] includes the widget returned
  /// by [this.body].
  Widget layout(BuildContext context, Widget body) {
    return body;
  }

  //
  //
  //

  /// Activates for mobile device screen sizes. Override to customize the  body
  /// for these sizes.
  Widget mobileBody(BuildContext context) {
    return this.narrowBody(context);
  }

  /// Activates for mobile device screen sizes ith a horizontal orientation.
  /// Override to customize the  body for these sizes.
  Widget horizontalMobileBody(BuildContext context) {
    return Center(
      child: Icon(
        Icons.rotate_90_degrees_ccw,
        size: 48.sc,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  /// Activates for non-mobile narrow screen sizes, such as a narrow desktop
  /// window or screen. Override to customize the  body for these sizes.
  Widget narrowBody(BuildContext context) {
    return this.body(context);
  }

  /// Activates for non-mobile wide screen sizes, such as a wide desktop
  /// window or screen. Override to customize the body for these sizes.
  Widget wideBody(BuildContext context) {
    return this.body(context);
  }

  /// Activates for screen sizes that do not match the criteria for
  /// [mobileLayout], [horizontalMobileLayout], [narrowLayout], or [wideLayout].
  /// Override to customize the body for these sizes.
  @visibleForOverriding
  Widget body(BuildContext context) {
    return const SizedBox.shrink();
  }

  //
  //
  //

  /// Override to specify the alignment of the [body] within the layout. Ideal
  /// for implementing scroll views. The [sideInsets] are set to correspond
  /// with the dimensions of widgets returned by [topSide], [bottomSide],
  /// [leftSide], and [rightSide].
  Widget align(
    BuildContext context,
    Widget body,
    EdgeInsets sideInsets,
  ) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: sideInsets,
          child: body,
        ),
      ),
    );
  }

  //
  //
  //

  /// Override to specify the padding for the body.
  EdgeInsets padding() {
    return EdgeInsets.all(28.sc).copyWith(bottom: 80.sc);
  }

  //
  //
  //

  /// Override to specify the background. This is rendered behind the body.
  Widget background(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: const SizedBox.expand(),
    );
  }

  /// Override to specify the foregound. This is rendered over the body.
  ///
  /// Tip: Use an [IgnorePointer] when creating non-interactive overlays.
  Widget foreground(BuildContext context) {
    return const IgnorePointer(
      child: SizedBox.expand(),
    );
  }

  //
  //
  //

  /// Override to customize the top area of your screen.
  ///
  /// Tip: Ideal for placing elements like headers.
  Widget topSide(BuildContext context, double topInsets) {
    return const SizedBox.shrink();
  }

  /// Override to customize the bottom area of your screen.
  ///
  /// Tip: Ideal for placing elements like navigation controls.
  Widget bottomSide(BuildContext context, double bottomInsets) {
    return const SizedBox.shrink();
  }

  //// Override to customize the left area of your screen.
  ///
  /// Tip: Ideal for placing elements like menus and side panels.
  Widget leftSide(BuildContext context, double leftInsets) {
    return const SizedBox.shrink();
  }

  //// Override to customize the right area of your screen.
  ///
  /// Tip: Ideal for placing elements like menus and side panels.
  Widget rightSide(BuildContext context, double rightInsets) {
    return const SizedBox.shrink();
  }

  //
  //
  //

  /// Override to further define how the main [body], [background] and
  /// [foreground] are presented
  ///
  /// Tip: This is useful for showing or hiding the body content from the
  /// user or displaying loading indicators while the body content is being
  /// loaded.
  ///
  /// **Example:**
  ///
  /// ```dart
  /// @override
  /// Widget presentation(
  ///   BuildContext context,
  ///   Widget body,
  ///   Widget background,
  ///   Widget foreground,
  /// ) {
  ///   return PodBuilder(
  ///     pod: this._pIsLoading,
  ///     builder: (context, background, isLoading) {
  ///       if (isLoading) {
  ///         return Stack(
  ///           alignment: AlignmentDirectional.center,
  ///           fit: StackFit.expand,
  ///           children: [
  ///             background,
  ///             const CircularProgressIndicator(),
  ///           ],
  ///         );
  ///       } else {
  ///         return Stack(
  ///           alignment: AlignmentDirectional.center,
  ///           fit: StackFit.expand,
  ///          children: [
  ///             background,
  ///             body,
  ///             foreground,
  ///          ],
  ///         );
  ///       }
  ///     },
  ///     child: background,
  ///   );
  /// }
  /// ```
  Widget presentation(
    BuildContext context,
    Widget body,
    Widget background,
    Widget foreground,
  ) {
    return Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        background,
        body,
        foreground,
      ],
    );
  }

  //
  //
  //

  /// Override to define how to transition from [prevScreenBodyCapture] to
  /// [currentScreenBody].
  ///
  /// **Example 1:**
  /// ```dart
  /// // Render the previous screen capture underneath the current screen.
  /// @override
  /// Widget transition(
  ///   BuildContext context,
  ///   Widget? prevScreenBodyCapture,
  ///   Widget currentScreenBody,
  /// ) {
  ///  return Stack(
  ///    alignment: AlignmentDirectional.center,
  ///    fit: StackFit.expand,
  ///    children: [
  ///      if (prevScreenBodyCapture != null) prevScreenBodyCapture,
  ///      currentScreenBody,
  ///    ],
  ///  );
  /// }
  /// ```
  ///
  /// **Example 2:**
  /// ```dart
  /// // Fade from the previous screen capture into the current screen.
  /// @override
  /// Widget transition(
  ///   BuildContext context,
  ///   Widget? prevScreenBodyCapture,
  ///   Widget currentScreenBody,
  /// ) {
  ///   if (prevScreenBodyCapture != null) {
  ///     return WAnimatedFade(
  ///       layer1: prevScreenBodyCapture,
  ///       layer2: currentScreenBody,
  ///     );
  ///   } else {
  ///     return currentScreenBody;
  ///   }
  /// }
  /// ```
  Widget transition(
    BuildContext context,
    Widget? prevScreenBodyCapture,
    Widget currentScreenBody,
  ) {
    return Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        if (prevScreenBodyCapture != null) prevScreenBodyCapture,
        currentScreenBody,
      ],
    );
  }

  //
  //
  //

  /// Combines all the components into the final body.
  Widget _final(BuildContext context, Widget body0) {
    return ViewInsetsBuilder(
      builder: (params) {
        final topSide = this.topSide(context, params.viewInsets.top);
        final bottomSide = this.bottomSide(context, params.viewInsets.bottom);
        final leftSide = this.leftSide(context, params.viewInsets.left);
        final rightSide = this.rightSide(context, params.viewInsets.right);
        final body1 = Padding(
          padding: this.padding(),
          child: body0,
        );
        final body2 = this.align(
          context,
          body1,
          this.sideInsets(this._calculatedSideInsets),
        );
        final body3 = Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: [
            if (this._didCalculateSideInsets) body2,
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  key: this._topSideKey,
                  child: topSide,
                ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        key: this._leftSideKey,
                        child: leftSide,
                      ),
                      Expanded(
                        child: !this._didCalculateSideInsets
                            ? body2
                            : const SizedBox(),
                      ),
                      SizedBox(
                        key: this._rightSideKey,
                        child: rightSide,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  key: this._bottomSideKey,
                  child: bottomSide,
                ),
              ],
            ),
          ],
        );

        final body4 = this.presentation(
          context,
          body3,
          this.background(context),
          this.foreground(context),
        );
        final body5 = RepaintBoundary(
          key: this._bodyCaptureKey,
          child: body4,
        );
        final body6 = ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: this.transition(context, _bodyCapture, body5),
        );
        return body6;
      },
    );
  }
}
