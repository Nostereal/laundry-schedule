import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/design_system/content_placeholder.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/profile/profile.dart';
import 'package:washing_schedule/schedule/day_selector.dart';
import 'package:washing_schedule/schedule/days_page_view.dart';
import 'package:washing_schedule/schedule/models/available_dates.dart';
import 'package:washing_schedule/schedule/schedule_repository.dart';

class CalendarPagerView extends StatefulWidget {
  const CalendarPagerView({Key? key}) : super(key: key);

  @override
  CalendarPagerViewState createState() => CalendarPagerViewState();
}

class CalendarPagerViewState extends State<CalendarPagerView> {
  static int selectedIndex = 0;
  final ItemScrollController itemScrollController = ItemScrollController();
  final PageController pageViewController =
  PageController(initialPage: selectedIndex);
  final double selectedItemAlignment =
  0.393; // todo: calculate from display width and card size
  final Duration _duration = const Duration(milliseconds: 300);

  bool _isPageAnimating = false;

  late Future<Result<AvailableDates>> _futureAvailableDates;
  final ScheduleRepository repository = getIt.get();

  @override
  void initState() {
    super.initState();
    _futureAvailableDates = repository.getAvailableDates();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureAvailableDates,
      builder: (BuildContext context,
          AsyncSnapshot<Result<AvailableDates>> snapshot) {
        if (snapshot.hasErrorOrFailureResult) {
          final typedError = snapshot.typedError;
          return ContentPlaceholder(
            title: typedError.message,
            action: TextButton(
              onPressed: () {
                setState(() {
                  _futureAvailableDates = repository.getAvailableDates();
                });
              },
              child: Text(context.appLocal.refresh),
            ),
          );
        } else if (snapshot.hasSuccessResult) {
          final AvailableDates dates = snapshot.successData();
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: SizedBox(
                  height: DaySelectorListView.height *
                      DaySelectorListView.selectedItemScale,
                  child: DaySelectorListView(
                    dates: dates,
                    selectedItemAlignment: selectedItemAlignment,
                    itemScrollController: itemScrollController,
                    selectedIndex: selectedIndex,
                    onTap: (index) {
                      onPageChanged(index);
                      itemScrollController.scrollTo(
                        index: index,
                        duration: _duration,
                        alignment: selectedItemAlignment,
                      );

                      _isPageAnimating = true;
                      pageViewController
                          .animateToPage(
                        index,
                        duration: _duration * 2,
                        curve: Curves.easeInOut,
                      )
                          .then((_) => {_isPageAnimating = false});
                    },
                  ),
                ),
              ),
              Expanded(
                child: DaysPageView(
                  dates: dates.dates,
                  controller: pageViewController,
                  onPageChanged: (i) {
                    if (_isPageAnimating) return;

                    onPageChanged(i);
                    itemScrollController.scrollTo(
                      index: i,
                      duration: _duration,
                      alignment: selectedItemAlignment,
                    );
                  },
                ),
              )
            ],
          );
        }
        return const Center( // todo: skeletons like day selector view
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}