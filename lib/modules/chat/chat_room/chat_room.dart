import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happy_care/core/themes/colors.dart';
import 'package:happy_care/data/models/room_chat/room_chat_pass.dart';
import 'package:happy_care/modules/chat/chat_room/chat_room_controller.dart';
import 'package:happy_care/modules/chat/widget/not_own_messenger.dart';
import 'package:happy_care/modules/chat/widget/own_messenger.dart';

class ChatRoomScreen extends GetView<ChatRoomController> {
  const ChatRoomScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final roomPass = Get.arguments as RoomChatPass;
    return WillPopScope(
      onWillPop: () async {
        return controller.leaveChatRoom(roomId: roomPass.id);
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kMainColor,
            titleSpacing: -10,
            title: ListTile(
              leading: CircleAvatar(
                backgroundColor: kSecondColor,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    backgroundImage:
                        roomPass.userChatWith.profile?.avatar == null
                            ? Image.asset("assets/images/icon.png").image
                            : Image.memory(base64Decode(
                                    roomPass.userChatWith.profile!.avatar!))
                                .image,
                  ),
                ),
              ),
              title: Text(
                roomPass.userChatWith.profile?.fullname ??
                    roomPass.userChatWith.email,
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              subtitle: roomPass.userChatWith.role != "member"
                  ? Text(
                      roomPass.userChatWith.specializations!.first,
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    )
                  : null,
            ),
            actions: [
              IconButton(
                onPressed: () {},
                splashRadius: 24,
                icon: Icon(
                  Icons.call_rounded,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                splashRadius: 24,
                icon: Icon(
                  Icons.video_call_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Obx(
                  () {
                    final status = controller.status.value;
                    if (status == ChatRoomStatus.loading) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: kMainColor,
                      ));
                    } else {
                      return ListView.builder(
                        reverse: true,
                        controller: controller.scrollController,
                        itemCount: controller.listMess.length,
                        itemBuilder: (context, index) {
                          if (controller.listMess[index].user !=
                              roomPass.userChatWith.id) {
                            return OwnMessenger(
                                messenge: controller.listMess[index].content!,
                                time: controller.formater.format(DateTime.parse(
                                        controller.listMess[index].time!)
                                    .toLocal()));
                          } else {
                            return NotOwnMessenger(
                              messenge: controller.listMess[index].content!,
                              avatar: roomPass.userChatWith.profile?.avatar,
                              time: controller.formater.format(
                                DateTime.parse(
                                  controller.listMess[index].time!,
                                ).toLocal(),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.image_rounded,
                              size: 25.0,
                              color: kMainColor,
                            ),
                            onPressed: () => controller.getImageToSend(),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: controller.focusNode,
                            controller: controller.textMessController,
                            maxLines: null,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 5) + EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: 'Aa',
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              hintStyle: GoogleFonts.openSans(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.emoji_emotions,
                                  size: 25.0,
                                  color: kMainColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Obx(() =>IconButton(
                            onPressed: () =>
                               !controller.isHadImage.value? controller.sendMessage(roomId: roomPass.id) :controller.sendImage(roomId: roomPass.id),
                            icon: 
                              Icon(
                                !controller.isHadImage.value
                                    ? Icons.send_rounded
                                    : Icons.attach_file,
                                size: 25.0,
                                color: kMainColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              GetBuilder<ChatRoomController>(builder: (controller) {
                return controller.imageToSend == null
                    ? SizedBox()
                    : _buildImagePreview(controller);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(ChatRoomController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ảnh được chọn',
              style: GoogleFonts.openSans(
                color: Colors.grey.shade500,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: Offset(0, 0.5),
                    blurRadius: 3,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      controller.imageToSend!,
                      width: 70,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.platformFile!.name,
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${(controller.platformFile!.size / 1024).ceil()} KB',
                          style: GoogleFonts.openSans(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.removeFile(),
                    icon: Icon(
                      Icons.close,
                      color: kMainColor,
                    ),
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
