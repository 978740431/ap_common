import 'package:ap_common/models/score_data.dart';
import 'package:ap_common/resources/ap_icon.dart';
import 'package:ap_common/resources/ap_theme.dart';
import 'package:ap_common/utils/ap_localizations.dart';
import 'package:ap_common/widgets/hint_content.dart';
import 'package:ap_common/widgets/item_picker.dart';
import 'package:ap_common/widgets/option_dialog.dart';
import 'package:flutter/material.dart';

enum ScoreState { loading, finish, error, empty, offlineEmpty }

class ScoreScaffold extends StatefulWidget {
  static const String routerName = '/score';

  final ScoreState state;
  final ScoreData scoreData;
  final List<String> semesters;
  final int semesterIndex;
  final bool isOffline;
  final Function(int index) onSelect;
  final Function() onRefresh;
  final Widget itemPicker;
  final String middleTitle;
  final String finalTitle;

  final bool isShowConductScore;
  final bool isShowCredit;

  const ScoreScaffold({
    Key key,
    @required this.state,
    @required this.scoreData,
    @required this.isOffline,
    @required this.onRefresh,
    this.itemPicker,
    this.semesters,
    this.semesterIndex,
    this.onSelect,
    this.middleTitle,
    this.finalTitle,
    this.isShowConductScore = true,
    this.isShowCredit = false,
  }) : super(key: key);

  @override
  ScoreScaffoldState createState() => ScoreScaffoldState();
}

class ScoreScaffoldState extends State<ScoreScaffold> {
  ApLocalizations app;

  TextStyle get _textBlueStyle =>
      TextStyle(color: ApTheme.of(context).blueText, fontSize: 16.0);

  TextStyle get _textStyle => TextStyle(fontSize: 15.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    app = ApLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(app.score),
        backgroundColor: ApTheme.of(context).blue,
      ),
      floatingActionButton: (widget.itemPicker != null)
          ? null
          : FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: _pickSemester,
            ),
      body: Container(
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: 8.0),
            (widget.itemPicker == null)
                ? ItemPicker(
                    dialogTitle: app.picksSemester,
                    onSelected: widget.onSelect,
                    items: widget.semesters,
                    currentIndex: widget.semesterIndex,
                  )
                : widget.itemPicker,
            if (widget.isOffline)
              Text(
                app.offlineScore,
                style: TextStyle(color: ApTheme.of(context).grey),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await widget.onRefresh();
                  return null;
                },
                child: _body(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    switch (widget.state) {
      case ScoreState.loading:
        return Container(
            child: CircularProgressIndicator(), alignment: Alignment.center);
      case ScoreState.error:
      case ScoreState.empty:
        return FlatButton(
          onPressed: () {
            if (widget.itemPicker == null && widget.state == ScoreState.empty)
              _pickSemester();
            else
              widget.onRefresh();
          },
          child: HintContent(
            icon: ApIcon.assignment,
            content: widget.state == ScoreState.error
                ? app.clickToRetry
                : app.scoreEmpty,
          ),
        );
      case ScoreState.offlineEmpty:
        return HintContent(
          icon: ApIcon.classIcon,
          content: app.noOfflineData,
        );
      default:
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        10.0,
                      ),
                    ),
                    border: Border.all(color: Colors.grey, width: 1.5),
                  ),
                  child: Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(2.5),
                      1: FlexColumnWidth(1.0),
                      2: FlexColumnWidth(1.0),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.symmetric(
                      inside: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    children: [
                      TableRow(
                        children: <Widget>[
                          _scoreTextBorder(app.subject, true),
                          _scoreTextBorder(
                              widget.middleTitle ?? app.midtermScore, true),
                          _scoreTextBorder(
                              widget.finalTitle ?? app.finalScore, true),
                        ],
                      ),
                      for (var score in widget.scoreData.scores)
                        _scoreTableRowTitle(score)
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        10.0,
                      ),
                    ),
                    border: Border.all(color: Colors.grey, width: 1.5),
                  ),
                  child: Column(
                    children: <Widget>[
                      if (widget.isShowConductScore)
                        _textBorder(
                          '${app.conductScore}：${widget.scoreData.detail.conduct ?? ''}',
                          widget.isShowConductScore,
                        ),
                      if (widget.isShowCredit)
                        _textBorder(
                          '${app.creditsTakenEarned}：'
                          '${widget.scoreData.detail.creditTaken ?? ''}'
                          '${widget.scoreData.detail.isCreditEmpty ? '' : ' / '}'
                          '${widget.scoreData.detail.creditEarned ?? ''}',
                          !widget.isShowConductScore,
                        ),
                      _textBorder(
                        '${app.average}：${widget.scoreData.detail.average ?? ''}',
                        !(widget.isShowConductScore || widget.isShowCredit),
                      ),
                      _textBorder(
                        '${app.rank}：${widget.scoreData.detail.classRank ?? ''}',
                        false,
                      ),
                      _textBorder(
                        '${app.percentage}：${widget.scoreData.detail.classPercentage ?? ''}',
                        false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _textBorder(String text, bool isTop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? BorderSide.none
              : BorderSide(color: ApTheme.of(context).grey, width: 0.5),
        ),
      ),
      alignment: Alignment.center,
      child: SelectableText(
        text ?? '',
        textAlign: TextAlign.center,
        style: _textBlueStyle,
      ),
    );
  }

  TableRow _scoreTableRowTitle(Score score) {
    return TableRow(children: <Widget>[
      _scoreTextBorder(score.title, false),
      _scoreTextBorder(score.middleScore, false),
      _scoreTextBorder(score.finalScore, false)
    ]);
  }

  Widget _scoreTextBorder(String text, bool isTitle) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      alignment: Alignment.center,
      child: SelectableText(
        text ?? '',
        textAlign: TextAlign.center,
        style: isTitle ? _textBlueStyle : _textStyle,
      ),
    );
  }

  void _pickSemester() {
    showDialog(
      context: context,
      builder: (_) => SimpleOptionDialog(
        title: app.picksSemester,
        items: widget.semesters,
        index: widget.semesterIndex,
        onSelected: widget.onSelect,
      ),
    );
  }
}
