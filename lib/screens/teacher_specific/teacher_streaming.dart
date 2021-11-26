import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sunny_connect/modals/app_post.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/services/NotificationManager/push_notification_manager.dart';
import 'package:sunny_connect/signaling.dart';
import 'package:sunny_connect/utils/field_validator.dart';
import 'package:sunny_connect/utils/widgets.dart';

class TeacherStreaming extends StatefulWidget {
  const TeacherStreaming({ Key key }) : super(key: key);
  
  @override
  _TeacherStreamingState createState() => _TeacherStreamingState();
}

class _TeacherStreamingState extends State<TeacherStreaming> {
  
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  TextEditingController titleController = TextEditingController();
  bool isLoading;
  bool _IS_STARTED;
  double height;
  double width;

  @override
  void initState() {
    isLoading=true;
    _IS_STARTED=false;
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      isLoading=false;
      setState(() {});
      
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    Future.delayed(Duration(seconds: 1), (){
      signaling.openUserMedia(_localRenderer, _remoteRenderer);
    });
    super.dispose();
  }


  void _createRoom() async {
    await signaling.openUserMedia(_localRenderer, _remoteRenderer);
    roomId = await signaling.createRoom(_remoteRenderer);
    textEditingController.text = roomId;
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    height= MediaQuery.of(context).size.height;
    width= MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: SelectableText(!_IS_STARTED?'Create New Meeting':"Live Streaming"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: false,
        child: 
        // !_IS_STARTED?
        // //
        // //
        // //Before Start
        // Container(
        //   child: Center(
        //     child: Column(
        //       children: [
        //         const SizedBox(height: 10),
        //         Padding(
        //           padding: const EdgeInsets.all( 20),
        //           child: Utilities.textField("Add meeting title...", false,
        //               TextInputAction.done, titleController, validtor: FieldValidator.validateField),
        //         ),
        //         ElevatedButton(
        //           onPressed: () async {
        //             roomId = await signaling.createRoom(_remoteRenderer);
        //             textEditingController.text = roomId;
        //             setState(() {});
        //           },
        //           child: Text("Start Meeting"),
        //         ),
        //       ],
        //     ),
        //   ),
        // )
        // :
        //
        //
        //After Start
        //Streaming Content
        Column(
          children: [
            Container(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all( 20),
                      child: Utilities.textField("Add meeting title...", false,
                          TextInputAction.done, titleController, validtor: FieldValidator.validateField),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // bool res=await Post.addNewPost(description.text,CurrentAppUser.currentUserData.uid, widget.appClass.id, '', '', 'text' , false, '');
                        // if(res){
                        //   await Utilities.showInfoDialog(context, 'New Post published', 'Your post has been published successfully!');
                        //   NotificationManager().sendAndRetrieveMessage(widget.appClass.id, '${CurrentAppUser.currentUserData.name} - posted new announcement in : ${widget.appClass.name}', '${CurrentAppUser.currentUserData.name} : ${widget.appClass.name} -- ${description.text}');
                        //   AppNavigator.pop(context);
                        //   setState(() {
                        //     isLoading=false;
                        //   });
                        // }else{
                        //   setState(() {
                        //     isLoading=false;
                        //   });
                        // }
                        // roomId = await signaling.createRoom(_remoteRenderer);
                        // textEditingController.text = roomId;
                        // setState(() {});
                      },
                      
                      child: Text("Start Meeting"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    signaling.hangUp(_localRenderer);
                  },
                  child: Text("Hangup"),
                )
              ],
            ),
          ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
                    Expanded(child: RTCVideoView(_remoteRenderer)),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text("Join the following Room: "),
            //       Flexible(
            //         child: TextFormField(
            //           controller: textEditingController,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}