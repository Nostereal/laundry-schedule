import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';
import 'package:washing_schedule/auth/auth.dart';
import 'package:washing_schedule/booking_creation_details/booking_repository.dart';
import 'package:washing_schedule/booking_creation_details/models/booking_intention_info.dart';
import 'package:washing_schedule/core/models/result.dart';
import 'package:washing_schedule/design_system/content_placeholder.dart';
import 'package:washing_schedule/di/application_module.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/profile/profile.dart';
import 'package:washing_schedule/schedule/schedule.dart';
import 'package:washing_schedule/utils/routing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'booking_creation_details_args.dart';

class BookingCreationDetailsRoute extends StatefulWidget {
  const BookingCreationDetailsRoute({
    Key? key,
    required this.date,
    required this.sessionNum,
    required this.userId,
  }) : super(key: key);

  final int userId;
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
      widget.userId,
      widget.date,
      widget.sessionNum,
    );
  }

  @override
  void initState() {
    super.initState();
    _initBookingIntentionRequest();
  }

  @override
  Widget build(BuildContext context) {
    // final BookingCreationDetailsArgs args = extractArgsFrom(context);
    return FutureBuilder(
      future: _futureBookingIntention,
      builder: (
        BuildContext context,
        AsyncSnapshot<Result<BookingIntentionInfo>> snapshot,
      ) {
        if (snapshot.hasErrorOrFailureResult) {
          return ContentPlaceholder(
            title: snapshot.typedError.message,
            action: ElevatedButton(
              onPressed: () => setState(_initBookingIntentionRequest),
              child: Text(AppLocalizations.of(context)!.refresh),
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
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(),
              title:
                  Text(AppLocalizations.of(context)!.bookingDetailsPageTitle),
            ),
            persistentFooterButtons: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  child: _createBookingButtonContent(context),
                  onPressed: () async {
                    setState(() {
                      _bookingCreationLoading = true;
                    });
                    final result = await _repository.createBooking(
                      widget.userId,
                      widget.sessionNum,
                      widget.date,
                    );

                    result.checkForType(
                      onFailureResult: (failure) {
                        showTextSnackBar(context, failure.error.message);
                      },
                      onSuccessResult: (success) {
                        // todo: close page with result
                      },
                    );

                    setState(() {
                      _bookingCreationLoading = false;
                    });
                  },
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
                                '${AppLocalizations.of(context)!.name}: ',
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
                                '${AppLocalizations.of(context)!.date}: ',
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
                                '${AppLocalizations.of(context)!.timeBracket}: ',
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

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _createBookingButtonContent(BuildContext context) {
    if (_bookingCreationLoading) {
      return const CircularProgressIndicator();
    } else {
      return Text(AppLocalizations.of(context)!.submitNewBookingButton);
    }
  }
}
