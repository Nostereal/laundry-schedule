import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:washing_schedule/home/home.dart';
import 'package:washing_schedule/l10n/l10n.dart';
import 'package:washing_schedule/schedule/schedule.dart';
import 'package:washing_schedule/utils/routing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'booking_creation_details_args.dart';

class BookingCreationDetailsRoute extends StatelessWidget {
  const BookingCreationDetailsRoute({Key? key}) : super(key: key);

  static const routeName = '/booking/create/details';

  @override
  Widget build(BuildContext context) {
    final BookingCreationDetailsArgs args = extractArgsFrom(context);

    final dateFormat = DateFormat('dd MMMM', L10n.systemLocale);
    final timeFormat = DateFormat('H:mm', L10n.systemLocale);
    final start = args.timeBracket.start;
    final end = args.timeBracket.end;
    final textTheme = Theme.of(context).textTheme;
    const spacingRow =
        TableRow(children: [SizedBox(height: 8), SizedBox(height: 8)]);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(AppLocalizations.of(context)!.bookingDetailsPageTitle),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ElevatedButton(
            child: Text(AppLocalizations.of(context)!.submitNewBookingButton),
            onPressed: () {
              showTextSnackBar(context, "Типа создаю запись 😐");
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
                defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
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
                          AppLocalizations.of(context)!.name + ': ',
                          style: textTheme.headline5,
                        ),
                      ),
                      Text(
                        "${args.user.lastName} ${args.user.firstName}",
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
                          AppLocalizations.of(context)!.date + ': ',
                          style: textTheme.headline5,
                        ),
                      ),
                      Text(
                        dateFormat.format(start),
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
                          AppLocalizations.of(context)!.timeBracket + ': ',
                          style: textTheme.headline5,
                        ),
                      ),
                      Text(
                        "${timeFormat.format(start)} — ${timeFormat.format(end)}",
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
}
