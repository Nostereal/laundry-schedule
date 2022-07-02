import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:washing_schedule/booking_creation_details/booking_repository.dart';
import 'package:washing_schedule/booking_creation_details/models/booking_intention_info.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/design_system/content_placeholder.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/profile/profile.dart';
import 'package:washing_schedule/utils/snackbars.dart';

class BookingCreationDetailsRoute extends StatefulWidget {
  const BookingCreationDetailsRoute({
    Key? key,
    required this.date,
    required this.sessionNum,
    required this.token,
  }) : super(key: key);

  final String token;
  final DateTime date;
  final int sessionNum;

  static const routeName = '/booking/create/details';

  @override
  State<BookingCreationDetailsRoute> createState() =>
      _BookingCreationDetailsRouteState();
}

class _BookingCreationDetailsRouteState
    extends State<BookingCreationDetailsRoute> {
  late Future<Result<BookingIntentionInfo>> _futureBookingIntention;

  final BookingRepository _repository = getIt.get();

  bool _bookingCreationLoading = false;

  _initBookingIntentionRequest() {
    _futureBookingIntention = _repository.getIntentionInfo(
      widget.token,
      widget.date,
      widget.sessionNum,
    );
  }

  @override
  void initState() {
    super.initState();
    _initBookingIntentionRequest();
  }

  Scaffold _bookingCreationScaffold({
    List<Widget>? footerButtons,
    required Widget body,
  }) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(context.appLocal.bookingDetailsPageTitle),
      ),
      persistentFooterButtons: footerButtons,
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBookingIntention,
      builder: (
        BuildContext context,
        AsyncSnapshot<Result<BookingIntentionInfo>> snapshot,
      ) {
        if (snapshot.hasErrorOrFailureResult) {
          return _bookingCreationScaffold(
            body: ContentPlaceholder(
              title: snapshot.typedError.message,
              action: ElevatedButton(
                onPressed: () => setState(_initBookingIntentionRequest),
                child: Text(context.appLocal.refresh),
              ),
            ),
          );
        }

        if (snapshot.hasSuccessResult) {
          final intentionInfo = snapshot.successData<BookingIntentionInfo>();
          final textTheme = context.textTheme;
          final dateFormat = DateFormat('dd MMMM', L10n.systemLocale);
          const spacingRow = TableRow(
            children: [
              SizedBox(height: 8),
              SizedBox(height: 8),
            ],
          );
          return _bookingCreationScaffold(
            footerButtons: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await _createBooking();
                    result.checkForType(
                      onFailureResult: (failure) {
                        showTextSnackBar(context, failure.error.message);
                      },
                      onSuccessResult: (success) {
                        Navigator.pop(context, true);
                      },
                    );
                  },
                  child: _createBookingButtonContent(context),
                ),
              ),
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: horizontalPadding,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.bottom,
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                '${context.appLocal.name}: ',
                                style: textTheme.headline5,
                              ),
                            ),
                            Text(
                              intentionInfo.ownerName,
                              style: textTheme.bodyText1,
                            ),
                          ],
                        ),
                        spacingRow,
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                '${context.appLocal.date}: ',
                                style: textTheme.headline5,
                              ),
                            ),
                            Text(
                              dateFormat.format(intentionInfo.date),
                              style: textTheme.bodyText1,
                            ),
                          ],
                        ),
                        spacingRow,
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                '${context.appLocal.timeBracket}: ',
                                style: textTheme.headline5,
                              ),
                            ),
                            Text(
                              intentionInfo.timeInterval,
                              style: textTheme.bodyText1,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return _bookingCreationScaffold(
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
  
  Future<Result<Object>> _createBooking() async {
    setState(() {
      _bookingCreationLoading = true;
    });
    final result = await _repository.createBooking(
      widget.token,
      widget.sessionNum,
      widget.date,
    );

    setState(() {
      _bookingCreationLoading = false;
    });

    return result;
  }

  Widget _createBookingButtonContent(BuildContext context) {
    if (_bookingCreationLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else {
      return Text(context.appLocal.submitNewBookingButton);
    }
  }
}
