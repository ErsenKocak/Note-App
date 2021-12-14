import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/painting.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../controllers/database_controller.dart';
import '../../../controllers/edit_controller.dart';
import '../../../core/widgets/carousel_slider/carousel_slider_widget.dart';
import '../../../models/note.dart';
import '../../../models/theme.dart';

class NoteView extends StatefulWidget {
  Function()? triggerRefetch;
  Note? existingNote;

  NoteView({
    Key? key,
    this.triggerRefetch,
    this.existingNote,
  }) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final _editController = Get.put(EditController());
  var _dbController = Get.put(DataBaseController());
  final ImagePicker _picker = ImagePicker();
  final _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _editController.selectedImageFile = Rxn<File>(null);

    if (widget.existingNote == null) {
      _editController.currentNote = Note(
          content: '', title: '', date: DateTime.now(), isImportant: false);
      _editController.isNoteNew.value = true;
    } else {
      _editController.currentNote = widget.existingNote!;
      _editController.isNoteNew.value = false;
    }
    _editController.titleController.text = _editController.currentNote.title!;
    _editController.contentController.text =
        _editController.currentNote.content!;
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    _editController.contentController.text = _lastWords;
    setState(() {});
  }

  FocusNode titleFocus = FocusNode();

  FocusNode contentFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed:
              // If not yet listening for speech start, otherwise stop
              _speechToText.isNotListening ? _startListening : _stopListening,
          child: Icon(
            _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
            color: Colors.white,
          ),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    focusNode: titleFocus,
                    autofocus: true,
                    controller: _editController.titleController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onSubmitted: (text) {
                      titleFocus.unfocus();
                      FocusScope.of(context).requestFocus(contentFocus);
                    },
                    onChanged: (value) {
                      markTitleAsDirty(value);
                    },
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Başlık',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 32,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w700),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      focusNode: contentFocus,
                      controller: _editController.contentController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (value) {
                        markContentAsDirty(value);
                      },
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Bir şeyler yazın...',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() =>
                      _editController.selectedImageFile.value != null &&
                              MediaQuery.of(context).viewInsets.bottom == 0
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: CarouselSliderWidget(
                                      image: _editController
                                          .selectedImageFile.value!.path),
                                ),
                              ],
                            )
                          : SizedBox()),
                ),
              ],
            ),
            ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    height: 80,
                    color: Theme.of(context).canvasColor.withOpacity(0.3),
                    child: SafeArea(
                      child: Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: handleBack,
                            ),
                            Spacer(),
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.delete_outline),
                                onPressed: () {
                                  handleDelete();
                                },
                              ),
                            ),
                            Expanded(
                                child: IconButton(
                                    onPressed: handleImages,
                                    icon: Icon(Icons.camera_enhance_outlined))),
                            Obx(
                              () => Expanded(
                                flex: _editController.isDirty.value ||
                                        _editController.selectedImageFile !=
                                            null
                                    ? 3
                                    : 0,
                                child: AnimatedContainer(
                                  margin: EdgeInsets.only(left: 10),
                                  duration: Duration(milliseconds: 200),
                                  width:
                                      _editController.isDirty.value ? 120 : 0,
                                  height: 42,
                                  curve: Curves.decelerate,
                                  child: RaisedButton.icon(
                                    color: Theme.of(context).accentColor,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(100),
                                            bottomLeft: Radius.circular(100))),
                                    icon: Icon(Icons.done),
                                    label: Text(
                                      'Kaydet',
                                      style: TextStyle(letterSpacing: 1),
                                    ),
                                    onPressed: handleSave,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ));
  }

  void handleImages() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Logger().w('IMAGE --> ${image.name}');
      var file = File(image.path);
      _editController.selectedImageFile.refresh();
      _editController.selectedImageFile = Rxn<File>(file);
    }
  }

  void handleSave() async {
    if (_editController.selectedImageFile.value != null) {
      Logger().w('RESIMLER EKLENDİ');
      _editController.currentNote.imagePath =
          _editController.selectedImageFile.value!.path;
      Logger().w('EKLENEN NOTE RESIM ${_editController.currentNote.toMap()}');
    }
    _editController.currentNote.title = _editController.titleController.text;
    _editController.currentNote.content =
        _editController.contentController.text;
    if (_editController.isNoteNew.value) {
      var latestNote =
          await _dbController.addNoteInDB(_editController.currentNote);
      _editController.currentNote = latestNote;
    } else {
      await _dbController.updateNoteInDB(_editController.currentNote);
    }
    _editController.isNoteNew.value = false;
    _editController.isDirty.value = false;
    widget.triggerRefetch!();

    titleFocus.unfocus();
    contentFocus.unfocus();
    handleBack();
  }

  void markTitleAsDirty(String title) {
    _editController.isDirty.value = true;
  }

  void markContentAsDirty(String content) {
    _editController.isDirty.value = true;
  }

  void markImportantAsDirty() {
    _editController.currentNote.isImportant =
        _editController.currentNote.isImportant == true ? true : false;
    handleSave();
  }

  void handleDelete() async {
    if (_editController.isNoteNew.value) {
      Navigator.pop(Get.context!);
    } else {
      showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text('Notu Sil'),
              content: Text('Notu silmek istediğinize emin misiniz?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('SİL',
                      style: prefix0.TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () async {
                    await _dbController
                        .deleteNoteInDB(_editController.currentNote);
                    widget.triggerRefetch!();
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

  void handleBack() {
    Navigator.pop(Get.context!);
  }
}
