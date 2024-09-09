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
  final AppBar? appBar;
  final Widget? body;
  final Widget? leftChild;
  final Widget? rightChild;
  final SplitController? splitController;

  bool get isSplit => leftChild != null && rightChild != null;

  const MDScaffold({
    super.key,
    required this.body,
    this.appBar,
  })  : leftChild = null,
        rightChild = null,
        splitController = null;

  const MDScaffold.split({
    super.key,
    required this.leftChild,
    required this.rightChild,
    this.splitController,
    this.appBar,
  }) : body = null;

  @override
  Widget build(BuildContext context) {
    SplitController controller = splitController ??
        SplitController(
          initialIsSplitOpen: false,
          initialShowSplitButton: isSplit,
        );
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15 * .8),
          topRight: Radius.circular(15 * .8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MDHeader(
            splitController: controller,
            appBar: appBar,
          ),
          Expanded(
            child: body != null
                ? body!
                : MDSplitBody(
                    splitController: controller,
                    leftChild: leftChild!,
                    rightChild: rightChild!,
                  ),
          )
        ],
      ),
    );
  }
}

class MDSplitBody extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;
  final SplitController splitController;
  const MDSplitBody({
    super.key,
    required this.leftChild,
    required this.rightChild,
    required this.splitController,
  });

  @override
  Widget build(BuildContext context) {
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
                      size: MediaQuery.of(context).size.width * .3,
                      minimalSize: MediaQuery.of(context).size.width * .1,
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
                      minimalSize: MediaQuery.of(context).size.width * .5,
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

class MDHeader extends StatelessWidget {
  final SplitController? splitController;
  final AppBar? appBar;
  const MDHeader({
    super.key,
    this.splitController,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    AppBar finalAppBar = AppBar(
      title: appBar?.title ?? const Text(''),
      leading: appBar?.leading,
      actions: [
        ...(appBar?.actions ?? const []),
        if (splitController != null && splitController!.showSplitButton.value)
          ValueListenableBuilder<bool>(
              valueListenable: splitController!.isSplitOpen,
              builder: (context, value, _) {
                return Button(
                  decoration: ButtonDecoration(
                    context: context,
                    variant: ButtonVariant.ghost,
                    type: ButtonType.primary,
                  ),
                  icon: !value
                      ? PhosphorIconsFill.sidebarSimple
                      : PhosphorIconsRegular.sidebarSimple,
                  onTap: () {
                    splitController!.toggleSplit();
                  },
                );
              }),
      ],
      backgroundColor: Colors.deepPurple.shade100.withOpacity(.2),
      toolbarHeight: 40,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15 * .75)),
      ),
      elevation: 10,
      centerTitle: appBar?.centerTitle,
      bottom: appBar?.bottom,
      flexibleSpace: appBar?.flexibleSpace,
      leadingWidth: appBar?.leadingWidth,
    );

    return Container(
      padding: const EdgeInsets.all(3),
      child: finalAppBar,
    );
  }
}
