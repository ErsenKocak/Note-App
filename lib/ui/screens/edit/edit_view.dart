import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:note_app/controllers/database_controller.dart';
import 'package:note_app/core/init/locator/locator.dart';
import 'package:note_app/core/widgets/carousel_slider/carousel_slider_widget.dart';
import 'package:note_app/core/widgets/photo_view/photo_view_widget.dart';

import 'package:note_app/service/database_service.dart';
import 'package:note_app/ui/screens/note/note_view.dart';
import 'package:photo_view/photo_view.dart';

import '../../../models/note.dart';

class EditView extends StatefulWidget {
  Function()? triggerRefetch;
  Note? currentNote;

  EditView({Key? key, Function()? triggerRefetch, Note? currentNote})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.currentNote = currentNote;
  }

  @override
  _EditViewState createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  var _dbController = Get.put(DataBaseController());
  bool headerShouldShow = false;
  @override
  void initState() {
    super.initState();
    showHeader();
  }

  void showHeader() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        headerShouldShow = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 40,
            ),
            buildheaderShould(),
            buildDateContainer(),
            buildNoteContent(),
            widget.currentNote!.imagePath != null &&
                    widget.currentNote!.imagePath != 'null'
                ? buildNotePhotoView(context)
                : SizedBox(),
          ],
        ),
        buildAppBar(context)
      ],
    ));
  }

  buildAppBar(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 80,
            color: Theme.of(context).canvasColor.withOpacity(0.3),
            child: SafeArea(
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: handleBack,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(widget.currentNote!.isImportant!
                        ? Icons.flag
                        : Icons.outlined_flag),
                    onPressed: () {
                      markImportantAsDirty();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: handleDelete,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: handleEdit,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  buildNotePhotoView(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PhotoViewWidget(
                    imagePath: widget.currentNote!.imagePath!)));
      },
      child: CarouselSliderWidget(
        image: widget.currentNote!.imagePath!,
      ),
    ));
  }

  buildNoteContent() {
    return Expanded(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 24.0, top: 36, bottom: 24, right: 24),
        child: Text(
          widget.currentNote!.content!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  buildDateContainer() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: headerShouldShow ? 1 : 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Text(
          DateFormat('HH:mm dd/MM/yyyy').format(widget.currentNote!.date!),
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.grey.shade500),
        ),
      ),
    );
  }

  buildheaderShould() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 24.0, right: 24.0, top: 40.0, bottom: 16),
      child: AnimatedOpacity(
        opacity: headerShouldShow ? 1 : 0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
        child: Text(
          widget.currentNote!.title!,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
          overflow: TextOverflow.visible,
          softWrap: true,
        ),
      ),
    );
  }

  void handleSave() async {
    await _dbController.updateNoteInDB(widget.currentNote!);
    widget.triggerRefetch!();
    handleBack();
  }

  markImportantAsDirty() {
    setState(() {
      widget.currentNote!.isImportant = !widget.currentNote!.isImportant!;
    });
    handleSave();
  }

  handleEdit() {
    Navigator.pop(context);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => NoteView(
                  existingNote: widget.currentNote,
                  triggerRefetch: widget.triggerRefetch,
                )));
  }

  handleBack() {
    Navigator.pop(context);
  }

  handleDelete() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Notu Sil'),
            content: Text('Notu silmek istediğinize emin misiniz ?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Sil',
                    style: TextStyle(
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  await _dbController.deleteNoteInDB(widget.currentNote!);
                  widget.triggerRefetch!();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('İptal',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
