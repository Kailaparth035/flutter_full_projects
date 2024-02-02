import 'dart:io';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/feeling_list_model.dart';
import 'package:aspirevue/data/model/response/hashtag_list_model.dart';
import 'package:aspirevue/data/model/response/post_detail_model.dart';
import 'package:aspirevue/data/model/response/privacy_setting_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/permission_utils.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_feeling_list.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_greate_quote.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_inspired_by.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_tag_people.dart';
import 'package:aspirevue/view/base/bottom_sheet/bottom_sheet_for_select_posttype.dart';
import 'package:aspirevue/view/base/custom_app_bar.dart';
import 'package:aspirevue/view/base/custom_button.dart';
import 'package:aspirevue/view/base/custom_dropdown_list_two.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/create_post/widgets/text_box_for_descripiton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key, this.postId});
  final String? postId;
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _insightStreamController = Get.find<InsightStreamController>();
  final _profileController = Get.find<ProfileSharedPrefService>();
  List<DropDownOptionItemMenu> postTypeList = [];
  DropDownOptionItemMenu postType =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  List<DropDownOptionItemMenu> growthResourceDDList = [];

  DropDownOptionItemMenu growthResourceDD = DropDownOptionItemMenu(
      id: null, title: AppString.growthResources, icon: AppImages.growth2Ic);

  final TextEditingController _msgController = TextEditingController();

  final List<ButtonModelForPost> _buttonList = [];

  final List<FilePickerModel> _galleryFilesForShare = [];
  final _picker = ImagePicker();

  List<OptionItemForMultiSelect> _tagUserList = [];
  List<OptionItemForMultiSelect> _inspiredUserListMain = [];
  List<OptionItemForMultiSelect> _pivotalMomentsList = [];

  List<FeelingListDataValue> _positiveFeelingList = [];
  List<FeelingListDataValue> _negativeFeelingList = [];
  List<FeelingListDataValue> _posiNegiFeelingList = [];

  String _firstName = "";
  String _lastName = "";
  String _email = "";

  PostTagType? currentTagType;
  bool _isOtherUserForInspiredby = false;
  bool _isOtherUserForPivotalMoment = false;

  bool _loadingDD = false;

  List<HashtagData> _hashtagList = [];
  bool _isShowUserList = false;
  String _hashtagForSearch = "";

  // variables for Edit
  PostDetailData? data;
  final List<FilesMedia> _uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadButtonData();
    _loadApi();
  }

  @override
  void dispose() {
    _tagUserList = [];
    _inspiredUserListMain = [];
    _pivotalMomentsList = [];

    _positiveFeelingList = [];
    _negativeFeelingList = [];
    _posiNegiFeelingList = [];

    _firstName = "";
    _lastName = "";
    _email = "";

    currentTagType = null;
    _isOtherUserForInspiredby = false;
    _isOtherUserForPivotalMoment = false;

    _loadingDD = false;

    _hashtagList = [];
    _isShowUserList = false;
    _hashtagForSearch = "";

    // variables for Edit
    data = null;

    super.dispose();
  }

  _loadApi() async {
    if (mounted) {
      setState(() {
        _loadingDD = true;
      });
    }
    await Future.wait([_getPrivacyList(), _getHashtagList()]);
    if (widget.postId != null) {
      await _postDetailData();
    }
    if (mounted) {
      setState(() {
        _loadingDD = false;
      });
    }
  }

  Future _getPrivacyList() async {
    try {
      PrivacySettingData result =
          await _profileController.getPrivacySettings({});

      for (var item in result.questionOneValue!) {
        postTypeList.add(DropDownOptionItemMenu(
          id: item.id,
          title: item.title.toString(),
          subTitle: item.subTitle.toString(),
        ));
      }

      if (result.questionOne != 0 && result.questionOne != null) {
        var item = result.questionOneValue!
            .where((element) =>
                element.id.toString() == result.questionOne.toString())
            .toList();

        if (item.isNotEmpty) {
          postType = DropDownOptionItemMenu(
              id: item.first.id, title: item.first.title.toString());
        } else {
          postType = DropDownOptionItemMenu(
              id: postTypeList.first.id,
              title: postTypeList.first.title.toString());
        }
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    }
  }

  Future _postDetailData() async {
    try {
      PostDetailData postData =
          await _insightStreamController.getPostDetailData(widget.postId!);

      _msgController.text = postData.postText.toString();

      for (var taggedUser in postData.taggedUser!) {
        _tagUserList.add(
          OptionItemForMultiSelect(
              id: taggedUser.id.toString(),
              title: taggedUser.name.toString(),
              isChecked: true),
        );
      }

      if (postData.filesMedia!.isNotEmpty) {
        for (var item in postData.filesMedia!) {
          if (item.type == "video") {
            try {
              var thumbnailPath =
                  await CommonController.generateThumbnail(item.path!);

              _uploadedFiles.add(
                FilesMedia(
                  id: item.id,
                  path: thumbnailPath!.path.toString(),
                  type: "video",
                  isDeleted: false,
                ),
              );
            } catch (e) {
              debugPrint("====> errror ========> $e");
            }
          } else {
            _uploadedFiles.add(
              FilesMedia(
                id: item.id,
                path: item.path.toString(),
                type: "image",
                isDeleted: false,
              ),
            );
          }
        }
      }

      if (postData.postInspired != "0") {
        var item = OptionItemForMultiSelect(
            id: postData.postInspired.toString(),
            title: postData.postInspiredName.toString(),
            isChecked: true);
        _inspiredUserListMain = [];
        _inspiredUserListMain.add(item);
        currentTagType = PostTagType.inpiredBy;
      }
      if (postData.postPivotal != "0") {
        var item = OptionItemForMultiSelect(
            id: postData.postPivotal.toString(),
            title: postData.postPivotalName.toString(),
            isChecked: true);
        _pivotalMomentsList = [];
        _pivotalMomentsList.add(item);
        currentTagType = PostTagType.pivotalMoments;
      }

      if (postData.fellingActivity!.isNotEmpty) {
        currentTagType = PostTagType.iAmFeeling;

        for (var item in postData.fellingActivity!) {
          var data = FeelingListDataValue(
              id: item.id, name: item.name, isChecked: true);

          if (item.type == "positive") {
            _positiveFeelingList.add(data);
          } else {
            _negativeFeelingList.add(data);
          }
        }

        _posiNegiFeelingList = _positiveFeelingList + _negativeFeelingList;
        currentTagType = PostTagType.iAmFeeling;
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    }
  }

  Future _getHashtagList() async {
    try {
      List<HashtagData> result = await _insightStreamController.getHashtags();
      if (mounted) {
        setState(() {
          _hashtagList = result;
        });
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    }
  }

  _loadButtonData() {
    growthResourceDDList.addAll([
      DropDownOptionItemMenu(
        id: "1",
        title: AppString.booksIRecommend,
        icon: AppImages.bookRecommIc,
      ),
      DropDownOptionItemMenu(
        id: "2",
        title: AppString.podcastsIFollow,
        icon: AppImages.podcastIc,
      ),
    ]);

    _buttonList.addAll([
      ButtonModelForPost(
          title: AppString.photoVideo,
          icon: AppImages.galleryAdd,
          color: AppColors.backgroundColor5.withOpacity(0.17),
          onTap: () {
            _showPicker();
          }),
      ButtonModelForPost(
          title: AppString.tagPeople,
          icon: AppImages.tagIc1,
          color: AppColors.backgroundColor6.withOpacity(0.17),
          onTap: () {
            _showTagPeopleDialog();
          }),
      ButtonModelForPost(
          icon: AppImages.inspiredByIc,
          title: AppString.inspiredBy,
          color: AppColors.labelColor70.withOpacity(0.17),
          onTap: () async {
            _inspiredByOnTap();
          }),
      ButtonModelForPost(
          icon: AppImages.tagUser,
          title: AppString.pivotalMoments,
          color: AppColors.backgroundColor3.withOpacity(0.17),
          onTap: () {
            _pivotalMomentByOnTap();
          }),
      ButtonModelForPost(
          icon: AppImages.greateIc,
          title: AppString.greatQuote,
          color: AppColors.backgroundColor8.withOpacity(0.17),
          onTap: () {
            _greateQuoteOnTap();
          }),
      ButtonModelForPost(
          icon: AppImages.growthSourceIc,
          title: AppString.growthFocus,
          color: AppColors.backgroundColor11.withOpacity(0.17),
          onTap: () {
            _growthFocusOnTap();
          }),
      ButtonModelForPost(
          icon: AppImages.happyIc,
          title: AppString.iAmFeeling,
          color: AppColors.backgroundColor12.withOpacity(0.17),
          onTap: () {
            _imFeelingOnTap();
          }),
    ]);
  }

  _imFeelingOnTap() async {
    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return FeelingListAlertDialog(
          positiveList: _positiveFeelingList,
          negativeList: _negativeFeelingList,
        );
      },
    );

    if (result != null) {
      if (mounted) {
        setState(() {
          _positiveFeelingList =
              result['positive'] as List<FeelingListDataValue>;
          _negativeFeelingList =
              result['nagative'] as List<FeelingListDataValue>;

          _posiNegiFeelingList = _positiveFeelingList + _negativeFeelingList;
          if (_posiNegiFeelingList.isNotEmpty) {
            currentTagType = PostTagType.iAmFeeling;
          } else {
            currentTagType = null;
          }
        });
      }
    }
  }

  _growthFocusOnTap() async {
    String valueToSend = _getHashTagRemovedString(_msgController.text);

    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GreateQuoteAlertDialog(
          text: valueToSend,
          postTagType: PostTagType.growthFocus,
        );
      },
    );

    if (result != null) {
      if (mounted) {
        setState(() {
          _msgController.text = result;
          currentTagType = PostTagType.growthFocus;
          _msgController.text += " ${AppString.growthFocusHash}";
        });
      }
    }
  }

  _greateQuoteOnTap() async {
    String valueToSend = _getHashTagRemovedString(_msgController.text);

    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GreateQuoteAlertDialog(
          text: valueToSend,
          postTagType: PostTagType.greatQuote,
        );
      },
    );

    if (result != null) {
      if (mounted) {
        setState(() {
          _msgController.text = result;
          currentTagType = PostTagType.greatQuote;
          _msgController.text += " ${AppString.greatQuoteHash}";
        });
      }
    }
  }

  _showTagPeopleDialog() async {
    List<Map<String, dynamic>> list = [];

    for (var item in _tagUserList) {
      list.add({
        "id": item.id,
        "title": item.title,
        "isChecked": item.isChecked,
      });
    }
    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return TagPeopleAlertDialog(selectedUserList: list);
      },
    );

    if (result != null) {
      if (mounted) {
        setState(() {
          if ((result as List).isNotEmpty) {
            _tagUserList = result as List<OptionItemForMultiSelect>;
          } else {
            _tagUserList = [];
          }
        });
      }
    }
  }

  _pivotalMomentByOnTap() async {
    String valueToSend = _getHashTagRemovedString(_msgController.text);

    List<Map<String, dynamic>> list = [];

    for (var item in _pivotalMomentsList) {
      list.add({
        "id": item.id,
        "title": item.title,
        "isChecked": item.isChecked,
      });
    }

    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return InspiredByAlertDialog(
            isInspiredBy: false,
            isOtherUser: _isOtherUserForPivotalMoment,
            selectedUserList: list,
            text: valueToSend,
            firstName: _firstName,
            lastName: _firstName,
            email: _email);
      },
    );

    if (result != null) {
      if (result['is_current_user'] == true) {
        if (mounted) {
          setState(() {
            _isOtherUserForPivotalMoment = false;
            _pivotalMomentsList =
                result['data'] as List<OptionItemForMultiSelect>;
          });
        }
        if (_pivotalMomentsList.isNotEmpty) {
          if (mounted) {
            setState(() {
              _msgController.text = result['msg'];
              currentTagType = PostTagType.pivotalMoments;
              _msgController.text += " ${AppString.pivotalMomentHash}";
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _msgController.text = _getRemovedString(
                  AppString.pivotalMomentHash, _msgController.text);
              if (currentTagType == PostTagType.pivotalMoments) {
                currentTagType = null;
              }
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isOtherUserForPivotalMoment = true;
            _msgController.text = result['msg'];
            currentTagType = PostTagType.pivotalMoments;
            _msgController.text += " ${AppString.pivotalMomentHash}";
            _firstName = result['data']['fname'];
            _lastName = result['data']['lname'];
            _email = result['data']['email'];
          });
        }
      }

      // setState(() {
      //   _msgController.text = result['msg'];
      //   currentTagType = PostTagType.pivotalMoments;
      //   _msgController.text += " ${AppString.pivotalMomentHash}";
      // });
    }
  }

  _inspiredByOnTap() async {
    String valueToSend = _getHashTagRemovedString(_msgController.text);

    List<Map<String, dynamic>> list = [];

    for (var item in _inspiredUserListMain) {
      list.add({
        "id": item.id,
        "title": item.title,
        "isChecked": item.isChecked,
      });
    }

    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return InspiredByAlertDialog(
            isInspiredBy: true,
            isOtherUser: _isOtherUserForInspiredby,
            selectedUserList: list,
            text: valueToSend,
            firstName: _firstName,
            lastName: _lastName,
            email: _email);
      },
    );

    if (result != null) {
      if (result['is_current_user'] == true) {
        if (mounted) {
          setState(() {
            _isOtherUserForInspiredby = false;
            _inspiredUserListMain =
                result['data'] as List<OptionItemForMultiSelect>;

            if (_inspiredUserListMain.isNotEmpty) {
              setState(() {
                _msgController.text = result['msg'];
                currentTagType = PostTagType.inpiredBy;
                _msgController.text += " ${AppString.inspiredByHash}";
              });
            } else {
              setState(() {
                _msgController.text = _getRemovedString(
                    AppString.inspiredByHash, _msgController.text);
                if (currentTagType == PostTagType.inpiredBy) {
                  currentTagType = null;
                }
              });
            }
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isOtherUserForInspiredby = true;
            _msgController.text = result['msg'];
            currentTagType = PostTagType.inpiredBy;
            _msgController.text += " ${AppString.inspiredByHash}";
            _firstName = result['data']['fname'];
            _lastName = result['data']['lname'];
            _email = result['data']['email'];
          });
        }
      }

      // setState(() {
      //   _msgController.text = result['msg'];
      //   currentTagType = PostTagType.inpiredBy;
      //   _msgController.text += " ${AppString.inspiredByHash}";
      // });
    }
  }

  void _showPicker() async {
    var result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SelectPostTypeBottomSheet();
      },
    );

    if (result != null) {
      if (result == "image") {
        _pickImage();
      } else {
        _pickVideo();
      }
    }
  }

  String _getHashTagRemovedString(
    String value,
  ) {
    var item = value
        .replaceAll(AppString.inspiredByHash, " ")
        .replaceAll(AppString.pivotalMomentHash, " ")
        .replaceAll(AppString.greatQuoteHash, " ")
        .replaceAll(AppString.growthFocusHash, " ")
        .replaceAll(AppString.booksIRecommendHash, " ")
        .replaceAll(AppString.podcastsIFollowHash, " ");

    return item;
  }

  String _getRemovedString(
    String valueToRemove,
    String value,
  ) {
    var item = value.replaceAll(valueToRemove, " ");

    return item;
  }

  _pickImage() async {
    if (CommonController.getIsIOS()) {
      bool? isPermitGranted =
          await PermissionUtils.takePermission(Permission.photos);

      if (isPermitGranted == null || isPermitGranted == false) {
        return null;
      }
    }

    var file = await CommonController.pickImage();
    if (file != null) {
      var cropedFile =
          // ignore: use_build_context_synchronously
          await CommonController.cropImage(file, context, isProfile: false);
      if (cropedFile != null) {
        if (mounted) {
          setState(() {
            var lenght = _uploadedFiles
                .where((element) => element.isDeleted == false)
                .length;
            if (lenght + _galleryFilesForShare.length + 1 > 8) {
              showCustomSnackBar(AppString.uploadmax);
              return;
            } else {
              _galleryFilesForShare.add(
                  FilePickerModel(file: File(cropedFile.path), type: "image"));
            }
          });
        }
      }
    }
  }

  Future _pickVideo() async {
    final pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    XFile? xfilePick = pickedFile;

    if (xfilePick != null) {
      final bytes = await xfilePick.length();
      final kb = (bytes / 1024);
      final mb = kb / 1024;
      if (mb > 20) {
        showCustomSnackBar("Please select video below 20MB", duration: 2);
        return false;
      }

      // ignore: use_build_context_synchronously
      buildLoading(context);
      try {
        if (CommonController.getIsAndroid()) {
          var mediaInfo = await CommonController.compressVideo(xfilePick);
          if (mediaInfo != null) {
            var thumbnailPath =
                await CommonController.generateThumbnail(mediaInfo.file!.path);
            if (mounted) {
              setState(() {
                if (_galleryFilesForShare.length + 1 > 8) {
                  showCustomSnackBar(AppString.uploadmax);
                  return;
                } else {
                  _galleryFilesForShare.add(FilePickerModel(
                      file: File(mediaInfo.file!.path),
                      thumbnailFile: thumbnailPath,
                      type: "video"));
                }
              });
            }
          } else {
            var thumbnailPath =
                await CommonController.generateThumbnail(pickedFile!.path);
            if (mounted) {
              setState(() {
                if (_galleryFilesForShare.length + 1 > 8) {
                  showCustomSnackBar(AppString.uploadmax);
                  return;
                } else {
                  _galleryFilesForShare.add(FilePickerModel(
                      file: File(pickedFile.path),
                      thumbnailFile: thumbnailPath,
                      type: "video"));
                }
              });
            }
          }
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
    return CommonController.getAnnanotaion(
      child: GestureDetector(
        onTap: () {
          CommonController.hideKeyboard(context);
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: widget.postId == null
                ? "  ${AppString.createPost}"
                : "  ${AppString.editPost}",
            onBackPressed: () {
              Get.back();
            },
            onPressed: () {
              Get.back();
            },
            showActionIcon: false,
            actionImage: AppImages.close,
            textColor: AppColors.labelColor8,
            iconButtonColor: AppColors.labelColor5,
            isBackButtonExist: true,
            context: context,
          ),
          backgroundColor: AppColors.white,
          body: Stack(
            children: [
              _buildMainView(context),
              _loadingDD
                  ? Container(
                      color: AppColors.black.withOpacity(0.1),
                      child: const Center(
                        child: CustomLoadingWidget(),
                      ),
                    )
                  : 0.sbh
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView _buildMainView(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<ProfileSharedPrefService>(
        builder: (sharedPrefController) {
          return Padding(
            padding: EdgeInsets.all(2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageAndName(
                  sharedPrefController.profileData.value.photo.toString(),
                  sharedPrefController.profileData.value.name.toString(),
                ),
                15.sp.sbh,
                widget.postId != null ? 0.sp.sbh : _buildDropDown(),
                widget.postId != null ? 0.sp.sbh : 15.sp.sbh,
                _buildTextField(),
                15.sp.sbh,
                _buildTitleAndDivider(),
                _buildSelectedFilesView(),
                15.sp.sbh,
                _buildButtonGrid(),
                15.sp.sbh,
                _buildDropDownForGrowthResource(),
                15.sp.sbh,
                CustomButton(
                  buttonText:
                      widget.postId == null ? AppString.post : AppString.update,
                  width: MediaQuery.of(context).size.width,
                  radius: Dimensions.radiusContainer,
                  fontWeight: FontWeight.w700,
                  height: 6.5.h,
                  fontSize: 13.sp,
                  onPressed: () {
                    _submitRequest();
                  },
                ),
                15.sp.sbh,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedFilesView() {
    return Wrap(
      children: [
        ..._uploadedFiles
            .where((element) => element.isDeleted == false)
            .map((e) {
          int index = _uploadedFiles.indexOf(e);
          return _buildUloadedItem(index);
        }),
        ..._galleryFilesForShare.map((e) {
          int index = _galleryFilesForShare.indexOf(e);
          return _buildItem(index);
        })
      ],
    );
  }

  Widget _buildUloadedItem(int index) {
    return Stack(
      children: [
        Container(
            width: 30.w - 15.sp,
            height: 30.w - 15.sp,
            margin: EdgeInsets.all(5.sp),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.black,
                width: 0.3,
              ),
              borderRadius: BorderRadius.circular(5.sp),
            ),
            child: _uploadedFiles[index].type == "image"
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(5.sp),
                    child: Image.network(_uploadedFiles[index].path.toString()))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(5.sp),
                    child: Image.file(
                        File(_uploadedFiles[index].path.toString())))),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _uploadedFiles[index].isDeleted = true;
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
        _uploadedFiles[index].type == "video"
            ? const Positioned.fill(
                child: Icon(
                  Icons.play_arrow,
                  color: AppColors.white,
                ),
              )
            : 0.sbh,
      ],
    );
  }

  Widget _buildItem(int index) {
    return Stack(
      children: [
        Container(
            width: 30.w - 15.sp,
            height: 30.w - 15.sp,
            margin: EdgeInsets.all(5.sp),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.black,
                width: 0.3,
              ),
              borderRadius: BorderRadius.circular(5.sp),
            ),
            child: _galleryFilesForShare[index].type == "image"
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(5.sp),
                    child: Image.file(_galleryFilesForShare[index].file))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(5.sp),
                    child: Image.file(
                        _galleryFilesForShare[index].thumbnailFile!))),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _galleryFilesForShare.removeAt(index);
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
        _galleryFilesForShare[index].type == "video"
            ? const Positioned.fill(
                child: Icon(
                  Icons.play_arrow,
                  color: AppColors.white,
                ),
              )
            : 0.sbh,
      ],
    );
  }

  AlignedGridView _buildButtonGrid() {
    return AlignedGridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 10.sp,
      crossAxisSpacing: 10.sp,
      primary: false,
      itemCount: _buttonList.length,
      itemBuilder: (context, index) => _buildButtonTile(index),
    );
  }

  InkWell _buildButtonTile(int index) {
    return InkWell(
      onTap: () {
        _buttonList[index].onTap();
      },
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: _buttonList[index].color,
          borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: _buttonList[index].icon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    5.sp.sbw,
                    Image.asset(
                      _buttonList[index].icon.toString(),
                      height: 15.sp,
                      width: 15.sp,
                    ),
                    5.sp.sbw,
                    Flexible(
                      child: CustomText(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: AppColors.labelColor18,
                        text: _buttonList[index].title,
                        textAlign: TextAlign.left,
                        overFlow: TextOverflow.ellipsis,
                        maxLine: 2,
                        fontFamily: AppString.manropeFontFamily,
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: AppColors.labelColor18,
                  text: _buttonList[index].title,
                  textAlign: TextAlign.center,
                  overFlow: TextOverflow.ellipsis,
                  maxLine: 2,
                  fontFamily: AppString.manropeFontFamily,
                ),
              ),
      ),
    );
  }

  Column _buildTitleAndDivider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
          color: AppColors.labelColor14,
          text: AppString.addVideoPhoto,
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        ),
        Divider(
          color: AppColors.labelColor,
          height: 7.sp,
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return GetBuilder<ProfileSharedPrefService>(
        builder: (sharedPrefController) {
      return Column(
        children: [
          TextBoxWidgetForDescription(
            onChanged: (val) {
              var cursorPos = _msgController.selection.base.offset;

              String textBeforeCusor =
                  _msgController.text.substring(0, cursorPos);

              if (cursorPos > 1 && _msgController.text[cursorPos - 1] == "#") {
                if (_msgController.text[cursorPos - 2] != " ") {
                  String textAfterCursor =
                      _msgController.text.substring(cursorPos);

                  setState(() {
                    textBeforeCusor = textBeforeCusor.substring(
                        0, textBeforeCusor.length - 1);
                    _msgController.text = "$textBeforeCusor #$textAfterCursor";
                  });

                  _msgController.selection =
                      TextSelection.collapsed(offset: cursorPos + 1);
                }
              }

              int lastBlankIndex = textBeforeCusor.lastIndexOf(" ");
              int lastHashIndex = textBeforeCusor.lastIndexOf("#");

              if (lastHashIndex != -1) {
                String stringHashToCurrent = _msgController.text.substring(
                    lastBlankIndex != -1 ? lastBlankIndex : 0, cursorPos);

                RegExp exp = RegExp(r'(#([\w]+))');
                var matchedList = exp.allMatches(stringHashToCurrent).toList();

                if (matchedList.isNotEmpty) {
                  setState(() {
                    _isShowUserList = true;
                    _hashtagForSearch = matchedList.first.group(0).toString();
                  });
                } else {
                  setState(() {
                    _isShowUserList = false;
                    _hashtagForSearch = "";
                  });
                }
              } else {
                setState(() {
                  _isShowUserList = false;
                  _hashtagForSearch = "";
                });
              }
            },
            borderColor: AppColors.labelColor9.withOpacity(0.2),
            labelText:
                "${AppString.whatsYourmind}${sharedPrefController.profileData.value.firstName}?",
            editColor: AppColors.labelColor12,
            textEditingController: _msgController,
          ),
          Visibility(
            visible: _isShowUserList,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: 40.h),
              color: AppColors.backgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._hashtagList
                        .where((element) => element.title!
                            .toLowerCase()
                            .contains(_hashtagForSearch
                                .replaceAll("#", "")
                                .toLowerCase()))
                        .map(
                          (e) => _buildHashTahListtle(e),
                        )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildHashTahListtle(HashtagData e) {
    return InkWell(
      onTap: () {
        var cursorPos = _msgController.selection.base.offset;

        String textAfterCursor = _msgController.text.substring(cursorPos);

        String textBeforeCursor = _msgController.text.substring(0, cursorPos);

        int inlastHashIndex = textBeforeCursor.lastIndexOf("#");
        String countThatUserEnter =
            _msgController.text.substring(inlastHashIndex, cursorPos);

        textBeforeCursor = textBeforeCursor.substring(0, inlastHashIndex);

        _msgController.text = "$textBeforeCursor#${e.title} $textAfterCursor";

        try {
          _msgController.selection = TextSelection.collapsed(
              offset: cursorPos +
                  "${e.title.toString()} ".length -
                  countThatUserEnter.length +
                  1);
        } catch (e) {
          debugPrint(e.toString());
        }

        setState(() {
          _isShowUserList = false;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Text(
              "#${e.title}",
            ),
          ),
          8.sp.sbh,
          const Divider(
            color: AppColors.labelColor,
            height: 0,
          )
        ],
      ),
    );
  }

  CustomDropListForMessageTwo _buildDropDown() {
    return CustomDropListForMessageTwo(
      postType.title,
      postType,
      postTypeList,
      fontSize: 12.sp,
      borderColor: AppColors.labelColor,
      bgColor: AppColors.white,
      (selectedItem) {
        setState(() {
          postType = selectedItem;
        });
      },
      radius: 5.sp,
    );
  }

  CustomDropListForMessageTwo _buildDropDownForGrowthResource() {
    return CustomDropListForMessageTwo(
      growthResourceDD.title,
      growthResourceDD,
      growthResourceDDList,
      fontSize: 12.sp,
      borderColor: Colors.transparent,
      itemBgColor: AppColors.backgroundColor10.withOpacity(0.17),
      bgColor: AppColors.backgroundColor9.withOpacity(0.17),
      listTileBgColor: Colors.transparent,
      (selectedItem1) {
        String valueToSend = _getHashTagRemovedString(_msgController.text);
        if (selectedItem1.id.toString() == "1") {
          setState(() {
            _msgController.text = valueToSend;
            currentTagType = PostTagType.booksIRecommend;
            _msgController.text += " ${AppString.booksIRecommendHash}";
          });
        } else {
          setState(() {
            _msgController.text = valueToSend;
            currentTagType = PostTagType.podcastsIFollow;
            _msgController.text += " ${AppString.podcastsIFollowHash}";
          });
        }
      },
      radius: Dimensions.radiusExtraLarge,
    );
  }

  Row _buildImageAndName(String image, String name) {
    return Row(
      children: [
        CustomImageForProfile(
          image: image,
          radius: 18.sp,
          nameInitials: "",
          borderColor: AppColors.labelColor,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: name,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: AppString.manropeFontFamily,
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelColor14,
                  ),
                ),
                ..._buildis(),
                ..._buildInspiredBy(),
                ..._buildTaggedUserList()
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildis() {
    if (currentTagType == PostTagType.inpiredBy ||
        currentTagType == PostTagType.iAmFeeling ||
        _tagUserList.isNotEmpty &&
            currentTagType != PostTagType.pivotalMoments) {
      return [_buildTextSpan(' is ')];
    } else {
      return [_buildTextSpan('')];
    }
  }

  _buildInspiredBy() {
    if (currentTagType != null && currentTagType == PostTagType.inpiredBy) {
      if (_isOtherUserForInspiredby) {
        return [
          _buildTextSpan('${AppString.inspiredBy} $_firstName $_lastName ')
        ];
      } else if (_inspiredUserListMain.isEmpty) {
        return [_buildTextSpan('')];
      } else {
        return [
          ..._inspiredUserListMain
              .map((e) => _buildTextSpan("${AppString.inspiredBy} ${e.title} "))
        ];
      }
    } else if (currentTagType != null &&
        currentTagType == PostTagType.pivotalMoments) {
      if (_isOtherUserForPivotalMoment) {
        return [
          _buildTextSpan(
              "with ${AppString.ivaltalMoment} $_firstName $_lastName ")
        ];
      } else if (_pivotalMomentsList.isEmpty) {
        return [_buildTextSpan('with')];
      } else {
        return [
          ..._pivotalMomentsList.map((e) =>
              _buildTextSpan("${AppString.ivaltalMoment} with ${e.title} "))
        ];
      }
    } else if (currentTagType != null &&
        currentTagType == PostTagType.iAmFeeling) {
      if (_posiNegiFeelingList.length > 2) {
        return [
          _buildSmily(),
          ...[0, 1].map((e) {
            int index = [0, 1].indexOf(e);
            bool isLast = [0, 1].length == index + 1;
            return _buildTextSpan(
                "${_posiNegiFeelingList[e].name}${isLast == false ? ',' : ''} ");
          }),
          _buildTextSpan(
              " ${AppString.and} ${_posiNegiFeelingList.length - 2} ${AppString.others}")
        ];
      } else {
        return [
          _buildSmily(),
          ..._posiNegiFeelingList.map(
            (e) {
              int index = _posiNegiFeelingList.indexOf(e);
              bool isLast = _posiNegiFeelingList.length == index + 1;
              return _buildTextSpan("${e.name}${isLast == false ? ',' : ''} ");
            },
          )
        ];
      }
    } else {
      return [_buildTextSpan('')];
    }
  }

  TextSpan _buildSmily() {
    if (_positiveFeelingList.isNotEmpty && _negativeFeelingList.isNotEmpty) {
      return _buildTextSpan('${AppString.otherEmoji} ${AppString.feeling} ');
    } else if (_positiveFeelingList.isNotEmpty) {
      return _buildTextSpan('${AppString.smilyEmoji} ${AppString.feeling} ');
    } else {
      return _buildTextSpan('${AppString.sadEmoji} ${AppString.feeling} ');
    }
  }

  TextSpan _buildTextSpan(String text, {Function? ontap}) {
    return TextSpan(
      text: text,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          if (ontap != null) {
            ontap();
          }
        },
      style: TextStyle(
        fontSize: 12.sp,
        fontFamily: AppString.manropeFontFamily,
        fontWeight: FontWeight.w600,
        color: AppColors.labelColor14,
      ),
    );
  }

  _buildTaggedUserList() {
    if (_tagUserList.isEmpty) {
      return [_buildTextSpan('')];
    } else if (_tagUserList.length > 2) {
      return [
        _buildTextSpan(' with '),
        ...[0, 1].map((e) {
          int index = [0, 1].indexOf(e);
          bool isLast = [0, 1].length == index + 1;
          return _buildTextSpan(
              "${_tagUserList[e].title}${isLast == false ? ',' : ''} ");
        }),
        _buildTextSpan(
            " ${AppString.and} ${_tagUserList.length - 2} ${AppString.others}",
            ontap: () {
          _showTagPeopleDialog();
        })
      ];
    } else {
      return [
        _buildTextSpan(' with '),
        ..._tagUserList.map(
          (e) {
            int index = _tagUserList.indexOf(e);
            bool isLast = _tagUserList.length == index + 1;
            return _buildTextSpan("${e.title}${isLast == false ? ',' : ''} ");
          },
        )
      ];
    }
  }

  Future<List?> _uploadFiles() async {
    List<File> fileList = [];
    List<String> fileNameList = [];

    for (var item in _galleryFilesForShare) {
      fileList.add(item.file);
      fileNameList.add("files");
    }
    try {
      var response = await _insightStreamController.uploadMediaForPost(
          map: {}, imageFileList: fileList, parameterName: fileNameList);

      if (response.isSuccess == true) {
        return response.responseT!.body['data'] as List;
      } else {
        return null;
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
      return null;
    }
  }

  _submitRequest() async {
    CommonController.hideKeyboard(context);

    // // uploading files
    setState(() {
      _loadingDD = true;
    });
    List<dynamic>? filesList = [];
    if (_galleryFilesForShare.isNotEmpty) {
      filesList = await _uploadFiles();
      if (filesList == null) {
        setState(() {
          _loadingDD = false;
        });
        return;
      }
    }

    var userId = Get.find<ProfileSharedPrefService>().loginData.value.id;
    var taggedUserList = _tagUserList.map((e) => e.id).join(",");

    var postFiles = filesList.map((e) => e).join(",");

    Map<String, dynamic> requestPrm = {
      "question_one": postType.id,
      "user_id": userId,
      "post_text": _msgController.text,
      "post_tags": taggedUserList,
      "post_type": postType.id,
      "post_files": postFiles,
    };

    // variables for edit
    if (widget.postId != null) {
      requestPrm['post_id'] = widget.postId;
      requestPrm['delete_files'] = _uploadedFiles
          .where((element) => element.isDeleted == true)
          .map((e) => e.id.toString())
          .join(",");
    } else {
      requestPrm['post_id'] = 0;
      requestPrm['delete_files'] = "";
    }

    // inspired by conditions
    var inpiredByUserList = _inspiredUserListMain.map((e) => e.id).join(",");
    if (currentTagType == PostTagType.inpiredBy) {
      if (_isOtherUserForInspiredby == false) {
        requestPrm['post_inspired'] = inpiredByUserList;
        requestPrm['post_contact_inspired'] = 0;
        requestPrm['post_inspired_name'] = _inspiredUserListMain.isNotEmpty
            ? _inspiredUserListMain.first.title
            : "";
        requestPrm['post_invitee_firstname'] = "";
        requestPrm['post_invitee_lastname'] = "";
        requestPrm['post_invitee_email'] = "";
      } else {
        requestPrm['post_inspired'] = 0;
        requestPrm['post_contact_inspired'] = 1;
        requestPrm['post_inspired_name'] = "";
        requestPrm['post_invitee_firstname'] = _firstName;
        requestPrm['post_invitee_lastname'] = _lastName;
        requestPrm['post_invitee_email'] = _email;
      }
    } else {
      requestPrm['post_inspired'] = 0;
      requestPrm['post_contact_inspired'] = 0;
      requestPrm['post_inspired_name'] = "";
      requestPrm['post_invitee_firstname'] = "";
      requestPrm['post_invitee_lastname'] = "";
      requestPrm['post_invitee_email'] = "";
    }

    // pivotmoment by conditions
    var pivotemomentUserList = _pivotalMomentsList.map((e) => e.id).join(",");
    if (currentTagType == PostTagType.pivotalMoments) {
      if (_isOtherUserForInspiredby == false) {
        requestPrm['post_pivotal'] = pivotemomentUserList;
        requestPrm['post_contact_pivotal'] = 0;
        requestPrm['post_pivotal_name'] = _pivotalMomentsList.isNotEmpty
            ? _pivotalMomentsList.first.title
            : "";
        requestPrm['post_pivotal_firstname'] = "";
        requestPrm['post_pivotal_lastname'] = "";
        requestPrm['post_pivotal_email'] = "";
      } else {
        requestPrm['post_pivotal'] = 0;
        requestPrm['post_contact_pivotal'] = 1;
        requestPrm['post_pivotal_name'] = "";
        requestPrm['post_pivotal_firstname'] = _firstName;
        requestPrm['post_pivotal_lastname'] = _lastName;
        requestPrm['post_pivotal_email'] = _email;
      }
    } else {
      requestPrm['post_pivotal'] = 0;
      requestPrm['post_contact_pivotal'] = 0;
      requestPrm['post_pivotal_name'] = "";
      requestPrm['post_pivotal_firstname'] = "";
      requestPrm['post_pivotal_lastname'] = "";
      requestPrm['post_pivotal_email'] = "";
    }

    // conditions for feeling list
    if (currentTagType == PostTagType.iAmFeeling) {
      var feelingList = _posiNegiFeelingList.map((e) => e.id).join(",");
      requestPrm['post_felling_activity'] = feelingList;
    } else {
      requestPrm['post_felling_activity'] = "";
    }

    debugPrint("====> request prm $requestPrm");

    try {
      var response = await _insightStreamController.createPost(requestPrm);

      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _loadingDD = false;
        });
      }
    }
  }
}
