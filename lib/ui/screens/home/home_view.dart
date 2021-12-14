import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/route/faderoute.dart';
import '../../../core/widgets/card/note_card_widget.dart';
import '../../../models/note.dart';
import '../../../models/theme.dart';
import '../edit/edit_view.dart';
import '../note/note_view.dart';

class HomeView extends StatelessWidget {
  final _homeController = Get.put(HomeController());

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: primaryColor,
        onPressed: () => gotoEditNote(),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Spacer(),
              Expanded(
                child: buildHeaderWidget(context),
              ),
              Expanded(child: buildButtonRow()),
              SizedBox(
                height: 25,
              ),
              Obx(
                () => Expanded(
                  flex: 6,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      //buildHeaderWidget(context),
                      // buildButtonRow(),

                      ...buildNoteComponentsList(),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          padding: EdgeInsets.only(left: 15, right: 15),
        ),
      ),
    );
  }

  buildHeaderWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          width: MediaQuery.of(context).size.width * 0.9,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(top: 8, bottom: 32, left: 10),
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notlarım',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                    color: Theme.of(context).primaryColor),
                overflow: TextOverflow.clip,
                softWrap: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                _homeController.isFlagOn.value =
                    _homeController.isFlagOn.value == true ? false : true;
              },
              child: Obx(
                () => AnimatedContainer(
                  duration: Duration(milliseconds: 160),
                  height: 50,
                  width: 50,
                  curve: Curves.slowMiddle,
                  child: Icon(
                    _homeController.isFlagOn.value
                        ? Icons.flag
                        : Icons.flag_outlined,
                    color: _homeController.isFlagOn.value
                        ? Colors.white
                        : Colors.grey.shade300,
                  ),
                  decoration: BoxDecoration(
                      color: _homeController.isFlagOn.value
                          ? primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        width: _homeController.isFlagOn.value == true ? 2 : 1,
                        color: _homeController.isFlagOn.value
                            ? primaryColor
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                ),
              )),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.only(left: 16),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _homeController.searchController,
                      maxLines: 1,
                      onChanged: (value) {
                        handleSearch(value);
                      },
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Notlarınızda arayın',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      icon: Icon(
                          _homeController.isSearchEmpty.value
                              ? Icons.search
                              : Icons.cancel,
                          color: Colors.grey.shade300),
                      onPressed: cancelSearch,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  buildNoteComponentsList() {
    List<Widget> noteComponentsList = [];
    _homeController.notesList.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    if (_homeController.searchController.text.isNotEmpty) {
      _homeController.notesList.forEach((note) {
        if (note.title.toLowerCase().contains(
                _homeController.searchController.text.toLowerCase()) ||
            note.content
                .toLowerCase()
                .contains(_homeController.searchController.text.toLowerCase()))
          noteComponentsList.add(NoteCardWidget(
            noteData: note,
            onTapAction: openNoteToRead,
          ));
      });
      return noteComponentsList;
    }
    if (_homeController.isFlagOn.value == true) {
      _homeController.notesList.forEach((note) {
        if (note.isImportant)
          noteComponentsList.add(NoteCardWidget(
            noteData: note,
            onTapAction: openNoteToRead,
          ));
      });
    } else {
      _homeController.notesList.forEach((note) {
        noteComponentsList.add(NoteCardWidget(
          noteData: note,
          onTapAction: openNoteToRead,
        ));
      });
    }
    return noteComponentsList;
  }

  handleSearch(String value) {
    _homeController.notesList.refresh();

    if (value.isNotEmpty) {
      _homeController.isSearchEmpty.value = false;
    } else {
      _homeController.isSearchEmpty.value = true;
    }
  }

  gotoEditNote() {
    Navigator.push(
        Get.context!,
        CupertinoPageRoute(
            builder: (context) =>
                NoteView(triggerRefetch: refetchNotesFromDB)));
  }

  refetchNotesFromDB() async {
    await _homeController.setNotesFromDB();
  }

  openNoteToRead(Note noteData) async {
    // Logger().w('CLİCKED ITEM --> ${noteData.toMap()}');
    _homeController.headerShouldHide.value = true;

    Get.to(() => EditView(
          triggerRefetch: refetchNotesFromDB,
          currentNote: noteData,
        ));
    _homeController.headerShouldHide.value = false;
  }

  cancelSearch() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    _homeController.searchController.clear();
    _homeController.isSearchEmpty.value = true;
  }
}
