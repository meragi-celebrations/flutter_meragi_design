import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class MDPaginationView extends StatefulWidget {
  final GetListBloc bloc;

  const MDPaginationView({
    super.key,
    required this.bloc,
  });

  @override
  State<MDPaginationView> createState() => _MDPaginationViewState();
}

class _MDPaginationViewState extends State<MDPaginationView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _scrollToSelectedItem(int selectedIndex, double maxWidth) {
    if (!_scrollController.hasClients) {
      return;
    }
    const double itemWidth = 40;
    final double offset = (selectedIndex * itemWidth) - (maxWidth / 2) + (itemWidth / 2);

    // Scroll to the selected item
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: MDMultiListenableBuilder(
        listenables: [
          widget.bloc.currentPage,
          widget.bloc.totalPages,
          widget.bloc.totalCount,
          widget.bloc.pageSize,
        ],
        builder: (context, _) {
          int current = widget.bloc.currentPage.value;
          int totalPages = widget.bloc.totalPages.value;
          int pageSize = widget.bloc.pageSize.value;
          int totalCount = widget.bloc.totalCount.value;
          return Row(
            children: [
              H6(
                text: "Total: $totalCount",
                type: TextType.disabled,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Row(
                  children: [
                    InkWell(
                      onTap: current == 1
                          ? null
                          : () {
                              widget.bloc.previousPage();
                            },
                      child: Icon(
                        PhosphorIconsRegular.caretLeft,
                        size: context.theme.fonts.paragraph.medium.fontSize,
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (current != 0) {
                            _scrollToSelectedItem(current, constraints.maxWidth);
                          }
                          return SizedBox(
                            height: 30,
                            child: Center(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: totalPages,
                                scrollDirection: Axis.horizontal,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return InkWell(
                                    onTap: () {
                                      if (current != i + 1) {
                                        widget.bloc.goToPage(i + 1);
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: i + 1 == current ? null : Colors.transparent,
                                      child: Text(
                                        '${i + 1}',
                                        style: i + 1 == current
                                            ? context.theme.fonts.paragraph.medium.copyWith(
                                                color: context.theme.colors.content.onColor,
                                              )
                                            : context.theme.fonts.paragraph.medium.copyWith(
                                                color: context.theme.colors.content.primary,
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    InkWell(
                      onTap: current == totalPages
                          ? null
                          : () {
                              widget.bloc.nextPage();
                            },
                      child: Icon(
                        PhosphorIconsRegular.caretRight,
                        size: context.theme.fonts.paragraph.medium.fontSize,
                      ),
                    ),
                  ],
                ),
              ),
              if (totalCount >= 50)
                Row(
                  children: [
                    const Text("Size: "),
                    SizedBox(
                      width: 80,
                      child: MenuAnchor(
                        style: MenuStyle(
                          backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor),
                        ),
                        menuChildren: [20, 50, 100]
                            .map(
                              (e) => MenuItemButton(
                                style: const ButtonStyle(
                                  minimumSize: WidgetStatePropertyAll(Size(80, 40)),
                                ),
                                onPressed: () {
                                  widget.bloc.onPageSizeChanged(e);
                                },
                                child: Text("$e"),
                              ),
                            )
                            .toList(),
                        builder: (context, controller, child) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 9.5,
                              ),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                              ),
                              filled: true,
                              fillColor: context.theme.colors.background.primary,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("$pageSize"),
                                  const Icon(Icons.arrow_drop_down, size: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
