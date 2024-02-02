import 'dart:io';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/enterprise_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/bottom_sheet/bottom_sheet_for_select_posttype.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/text_box/custom_search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class WriteCommentWidget extends StatefulWidget {
  const WriteCommentWidget(
      {super.key,
      required this.onAddComment,
      required this.postId,
      required this.parentCommentId,
      required this.isOnlyTextComment,
      required this.isNewsComment});
  final Future Function() onAddComment;
  final String postId;
  final String? parentCommentId;
  final bool isOnlyTextComment;
  final bool isNewsComment;

  @override
  State<WriteCommentWidget> createState() => _WriteCommentWidgetState();
}

class _WriteCommentWidgetState extends State<WriteCommentWidget> {
  final _insightStreamController = Get.find<InsightStreamController>();
  final _enterPriseController = Get.find<EnterpriseController>();
  final TextEditingController _msgController = TextEditingController();

  List<FilePickerModel> _galleryFiles = [];
  bool _isLoadingAddComment = false;
  final _picker = ImagePicker();

  _pickImage() async {
    var file = await CommonController.pickImage();
    if (file != null) {
      var croppedFile =
          // ignore: use_build_context_synchronously
          await CommonController.cropImage(file, context, isProfile: false);
      if (croppedFile != null) {
        setState(() {
          _galleryFiles.add(
              FilePickerModel(file: File(croppedFile.path), type: "image"));
        });
      }
    }
  }

  _pickFiles() async {
    var files = await CommonController.getFilePicker();
    if (files != null) {
      for (var item in files) {
        setState(() {
          _galleryFiles
              .add(FilePickerModel(file: File(item.path), type: "File"));
        });
      }
    }
  }

  _getImageBottomSheet() async {
    var result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SelectPostTypeBottomSheet();
      },
    );

    // ignore: use_build_context_synchronously
    FocusScope.of(context).requestFocus(FocusNode());

    if (result != null) {
      if (result != null) {
        if (result == "image") {
          _pickImage();
        } else {
          _pickVideo();
        }
      }
    }
  }

  Future _pickVideo() async {
    final pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
      maxDuration: const Duration(minutes: 5),
    );

    if (pickedFile != null) {
      try {
        final bytes = await pickedFile.length();
        final kb = (bytes / 1024);
        final mb = kb / 1024;

        // ignore: use_build_context_synchronously
        buildLoading(context);
        if (mb > 20) {
          showCustomSnackBar("Please select video below 20MB", duration: 2);
          return false;
        }

        if (CommonController.getIsAndroid()) {
          var mediaInfo = await CommonController.compressVideo(pickedFile);

          if (mediaInfo != null) {
            var thumbnailFile =
                await CommonController.generateThumbnail(mediaInfo.file!.path);

            setState(() {
              _galleryFiles.add(FilePickerModel(
                  file: File(mediaInfo.file!.path),
                  thumbnailFile: thumbnailFile,
                  type: "video"));
            });
          }
        } else {
          var thumbnailFile =
              await CommonController.generateThumbnail(pickedFile.path);

          setState(() {
            _galleryFiles.add(FilePickerModel(
                file: File(pickedFile.path),
                thumbnailFile: thumbnailFile,
                type: "video"));
          });
        }
      } catch (e) {
        String error = CommonController().getValidErrorMessage(e.toString());
        showCustomSnackBar(error.toString());
      } finally {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildCommentsNameAndTextBox();
  }

  Widget _buildCommentsNameAndTextBox() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<ProfileSharedPrefService>(
                builder: (sharedPrefController) {
              return Stack(
                children: [
                  _isLoadingAddComment
                      ? Positioned.fill(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5.sp,
                          ),
                        )
                      : 0.sbh,
                  Center(
                    child: CustomImageForProfile(
                      image: sharedPrefController.profileData.value.photo
                          .toString(),
                      radius: 14.sp,
                      nameInitials: sharedPrefController
                          .profileData.value.name![0]
                          .toString(),
                      borderColor: AppColors.labelColor,
                    ),
                  ),
                ],
              );
            }),
            7.sp.sbw,
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 30.sp,
                    child: CustomSearchTextField(
                      iconPadding: 6.sp,
                      radius: 3.sp,
                      labelText: "Write a comment..",
                      editColor: AppColors.labelColor,
                      fontFamily: AppString.manropeFontFamily,
                      textEditingController: _msgController,
                      fontSize: 12.sp,
                      inputAction: TextInputAction.done,
                      onEditComplete: () {
                        if (_msgController.text.isNotEmpty ||
                            _galleryFiles.isNotEmpty) {
                          if (_galleryFiles.isEmpty &&
                              _msgController.text.trim() == "") {
                            CommonController.hideKeyboard(context);
                          } else {
                            if (widget.isNewsComment) {
                              _addNewsComment();
                            } else {
                              _addComment();
                            }
                          }
                        } else {
                          CommonController.hideKeyboard(context);
                        }
                      },
                      onChanged: (val) {},
                      suffixIcon: widget.isOnlyTextComment == true
                          ? null
                          : AppImages.imageUploadIc,
                      suffixIcon2: widget.isOnlyTextComment == true
                          ? null
                          : AppImages.linkIc,
                      iconSize: 14.sp,
                      onSecondTap: () {
                        _pickFiles();
                      },
                      onTapsuffixIcon2: () {
                        _getImageBottomSheet();
                      },
                    ),
                  ),
                  _galleryFiles.isEmpty
                      ? 0.sbh
                      : Container(
                          padding: EdgeInsets.all(5.sp),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: AppColors.labelColor,
                          ),
                          child: Column(
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  ..._galleryFiles.map((e) {
                                    int index = _galleryFiles.indexOf(e);
                                    return _buildImageAndVideoView(index);
                                  })
                                ],
                              ),
                              _isLoadingAddComment
                                  ? 0.sbh
                                  : Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          _addComment();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            top: 5.sp,
                                            bottom: 5.sp,
                                            left: 5.sp,
                                            right: 2.sp,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.primaryColor,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.send_rounded,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  _buildImageAndVideoView(int index) {
    return SizedBox(
      height: 10.h,
      child: Stack(
        children: [
          _galleryFiles[index].type == "image"
              ? Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.sp),
                      child: Image.file(_galleryFiles[index].file)),
                )
              : _galleryFiles[index].type == "video"
                  ? Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.sp),
                        child: Image.file(_galleryFiles[index].thumbnailFile!),
                      ),
                    )
                  : _galleryFiles[index].file.path.contains(".doc") ||
                          _galleryFiles[index].file.path.contains(".docx ")
                      ? Container(
                          width: 10.h,
                          padding: EdgeInsets.all(8.sp),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.sp),
                            child: Image.asset(AppImages.docImageIc),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(8.sp),
                          width: 10.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.sp),
                            child: Image.asset(AppImages.excelImageIc),
                          ),
                        ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _galleryFiles.removeAt(index);
                });
              },
              child: Container(
                height: 15.sp,
                width: 15.sp,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor7,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 12.sp,
                ),
              ),
            ),
          ),
          _galleryFiles[index].type == "video"
              ? const Positioned.fill(
                  child: Icon(
                    Icons.play_arrow,
                    color: AppColors.white,
                  ),
                )
              : 0.sbh,
        ],
      ),
    );
  }

  Future _addComment() async {
    CommonController.hideKeyboard(context);
    if (_isLoadingAddComment == true) {
      return;
    }
    setState(() {
      _isLoadingAddComment = true;
    });
    try {
      Map<String, dynamic> requestPrm = {
        "post_id": widget.postId.toString(),
        "comment": _msgController.text,
        "parent_comment_id": widget.parentCommentId ?? "",
      };

      List<File> fileList = [];
      List<String> fileNameList = [];

      for (var item in _galleryFiles) {
        if (item.type == "image" || item.type == "video") {
          fileList.add(item.file);
          fileNameList.add("images");
        } else {
          fileList.add(item.file);
          fileNameList.add("attachment");
        }
      }

      var response = await _insightStreamController.addComment(
          map: requestPrm,
          imageFileList: fileList,
          parameterName: fileNameList);

      if (response.isSuccess == true) {
        await widget.onAddComment();
        // ignore: use_build_context_synchronously

        _msgController.clear();
        setState(() {
          _galleryFiles = [];
        });

        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoadingAddComment = false;
      });
    }
  }

  Future _addNewsComment() async {
    CommonController.hideKeyboard(context);
    if (_isLoadingAddComment == true) {
      return;
    }
    setState(() {
      _isLoadingAddComment = true;
    });
    try {
      Map<String, dynamic> requestPrm = {
        "postId": widget.postId.toString(),
        "commentHtml": _msgController.text,
        "commentId": "0",
        "parentCommentId": widget.parentCommentId ?? "0"
      };

      await _enterPriseController.addNewsComment(
          map: requestPrm,
          onReload: () async {
            await widget.onAddComment();
            _msgController.clear();
          });
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoadingAddComment = false;
      });
    }
  }
}
