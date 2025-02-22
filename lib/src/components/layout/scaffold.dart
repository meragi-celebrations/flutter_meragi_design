import 'package:docking/docking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SplitController {
  ValueNotifier<bool> isSplitOpen = ValueNotifier(false);
  ValueNotifier<bool> showSplitButton = ValueNotifier(false);

  SplitController({
    bool initialIsSplitOpen = false,
    bool initialShowSplitButton = false,
  }) {
    isSplitOpen.value = initialIsSplitOpen;
    showSplitButton.value = initialShowSplitButton;
  }

  void toggleSplit() {
    isSplitOpen.value = !isSplitOpen.value;
  }
}

class MDScaffold extends StatelessWidget {
  final MDAppBar? appBar;
  final Widget? body;
  final Widget? leftChild;
  final Widget? rightChild;
  final SplitController? splitController;
  final Widget? bottomNavigationBar;

  bool get isSplit => leftChild != null && rightChild != null;

  const MDScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
  })  : leftChild = null,
        rightChild = null,
        splitController = null;

  const MDScaffold.split({
    super.key,
    required this.leftChild,
    required this.rightChild,
    this.splitController,
    this.appBar,
    this.bottomNavigationBar,
  }) : body = null;

  MDAppBar? buildHeader(SplitController controller) {
    MDAppBar? workingAppBar = appBar;

    if (isSplit) {
      workingAppBar = workingAppBar?.copyWith(
        leading: controller.showSplitButton.value
            ? ValueListenableBuilder<bool>(
                valueListenable: controller.isSplitOpen,
                builder: (context, value, _) {
                  return MDButton(
                    decoration: ButtonDecoration(
                      context: context,
                      variant: ButtonVariant.ghost,
                      type: ButtonType.primary,
                    ),
                    icon: !value ? PhosphorIconsFill.sidebarSimple : PhosphorIconsRegular.sidebarSimple,
                    onTap: () {
                      controller.toggleSplit();
                    },
                  );
                },
              )
            : null,
        actions: [
          ...(appBar?.actions ?? const []),
        ],
      );
    }

    return workingAppBar;
  }

  @override
  Widget build(BuildContext context) {
    SplitController controller = splitController ??
        SplitController(
          initialIsSplitOpen: false,
          initialShowSplitButton: isSplit,
        );
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15 * .8),
        topRight: Radius.circular(15 * .8),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildHeader(controller),
        body: body != null
            ? body!
            : LayoutBuilder(builder: (context, constraints) {
                return MDSplitBody(
                  splitController: controller,
                  leftChild: leftChild!,
                  rightChild: rightChild!,
                  maxWidth: constraints.maxWidth,
                );
              }),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

class MDSplitBody extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;
  final SplitController splitController;
  final double? maxWidth;
  const MDSplitBody({
    super.key,
    required this.leftChild,
    required this.rightChild,
    required this.splitController,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    double maxWidth = this.maxWidth ?? MediaQuery.of(context).size.width;

    return ValueListenableBuilder<bool>(
        valueListenable: splitController.isSplitOpen,
        builder: (context, maximized, _) {
          return TabbedViewTheme(
            data: TabbedViewThemeData(
              tabsArea: TabsAreaThemeData(
                visible: false,
              ),
            ),
            child: MultiSplitViewTheme(
              data: MultiSplitViewThemeData(
                dividerPainter: DividerPainters.grooved1(
                  color: const Color.fromARGB(255, 40, 33, 53),
                  highlightedColor: Colors.deepPurple,
                ),
              ),
              child: Docking(
                layout: DockingLayout(
                  root: DockingRow([
                    DockingItem(
                      size: maxWidth * .3,
                      minimalSize: maxWidth * .1,
                      widget: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15 * .8),
                              topRight: Radius.circular(15 * .8),
                            )),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15 * .8),
                            topRight: Radius.circular(15 * .8),
                          ),
                          child: leftChild,
                        ),
                      ),
                    ),
                    DockingItem(
                      maximized: maximized,
                      minimalSize: maxWidth * .5,
                      widget: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15 * .8),
                            topRight: Radius.circular(15 * .8),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15 * .8),
                            topRight: Radius.circular(15 * .8),
                          ),
                          child: rightChild,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
