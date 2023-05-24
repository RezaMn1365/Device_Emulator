import 'package:emulator/app/modules/main/components/compass_widget.dart';
import 'package:emulator/app/modules/main/components/gyroscope_gauge.dart';
import 'package:emulator/app/modules/main/views/beacon_view.dart';
import 'package:emulator/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../main/components/map.dart';
import '../../main/components/text_form_field.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  onLocalIdTextChanged(String text) {
    controller.localId = text;
  }

  onSerialTextChanged(String text) {
    controller.serial = text;
  }

  onSecretTextChanged(String text) {
    controller.secret = text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emulator Machine'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   height: Get.height / 14,
                //   width: Get.width / 3,
                //   padding: EdgeInsets.all(5.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(30.0),
                //     border: Border.all(
                //         color: Colors.black, style: BorderStyle.solid, width: 1),
                //   ),
                //   child: DropdownButtonHideUnderline(
                //     child: DropdownButton(
                //       underline: const SizedBox(),
                //       // decoration: InputDecoration(
                //       //     enabledBorder: OutlineInputBorder(
                //       //         borderRadius: BorderRadius.circular(10))),
                //       borderRadius: BorderRadius.circular(30.0),
                //       elevation: 5, isDense: true,

                //       hint: const Text(
                //         'Select a device',
                //         style: TextStyle(
                //           fontSize: 14,
                //           color: Colors.red,
                //         ),
                //       ),
                //       value: controller.dropDownValue.value,
                //       style: TextStyle(
                //           color: Colors.black, fontWeight: FontWeight.bold),
                //       items: controller.deviceList
                //           .map((element) => DropdownMenuItem(
                //                 value: element,
                //                 child: Text(element),
                //               ))
                //           .toList(),
                //       onChanged: (val) {
                //         controller.onSelected(val!);
                //       },
                //     ),
                //   ),
                // ),
                // const Text(
                //   'Please select the desired device from above list then click Run',
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                // Container(
                //     height: Get.height / 14,
                //     width: Get.width / 3,
                //     padding: EdgeInsets.all(5.0),
                //     // decoration: BoxDecoration(
                //     //   borderRadius: BorderRadius.circular(30.0),
                //     //   border: Border.all(
                //     //       color: Colors.black,
                //     //       style: BorderStyle.solid,
                //     //       width: 1),
                //     // ),
                //     child: ElevatedButton(
                //       onPressed: () {
                //         controller.submit();
                //       },
                //       child: Text('Run'),
                //     )),

                TextFormFieldWidget(
                    inputText: "DUVoqoRpY2Vrbh4T",
                    PaddingValue: 10,
                    hint: 'Please inset local id',
                    lable: 'Local Id',
                    onTextFormFieldValueChanged: (value) {
                      onLocalIdTextChanged(value);
                    }),
                TextFormFieldWidget(
                    inputText: "5555",
                    PaddingValue: 10,
                    hint: 'Please inset serial',
                    lable: 'Serial',
                    onTextFormFieldValueChanged: (value) {
                      onSerialTextChanged(value);
                    }),
                TextFormFieldWidget(
                    inputText: "m3oGIjuOmFiuFUF29eqwPNT5l5oEwVLc",
                    PaddingValue: 10,
                    hint: 'Please inset secret',
                    lable: 'Secret',
                    onTextFormFieldValueChanged: (value) {
                      onSecretTextChanged(value);
                    }),

                ElevatedButton(
                  onPressed: () {
                    onSecretTextChanged("m3oGIjuOmFiuFUF29eqwPNT5l5oEwVLc");
                    onSerialTextChanged("5555");
                    onLocalIdTextChanged("DUVoqoRpY2Vrbh4T");

                    controller.submit();
                  },
                  child: const Text('Login'),
                ),

                ElevatedButton(
                  onPressed: () {
                    controller.ticket();
                  },
                  child: const Text('Ticket'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    controller.openSocket();
                  },
                  child: Text('socket connect'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    controller.sendTicketSocket();
                  },
                  child: Text('send ticket'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await controller.sendSampleData();
                  },
                  child: Text('send sample data'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await controller.fileController.searchDirectory();
                    controller.nextPage();
                  },
                  child: Text('next page'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    Get.off(BeaconView());
                  },
                  child: Text('beacon'),
                ),

                // ElevatedButton(
                //   onPressed: () async {
                //     controller.fileController.searchDirectory();
                //   },
                //   child: Text('get dir'),
                // ),
                // ElevatedButton(
                //   onPressed: () async {
                //     controller.fileController.printResult();
                //   },
                //   child: Text('result'),
                // ),

                // ElevatedButton(
                //   onPressed: () async {
                //     controller.fileController.getFileList();
                //   },
                //   child: Text('getFileList'),
                // ),

                // ElevatedButton(
                //   onPressed: () async {
                //     await controller.gyroController.makeReportFile();
                //   },
                //   child: Text('writeToFile'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// "device_id": "GS7r8c0Xh0rzJJHQSxS45x0Nh0EyuIMf5c3uc7vk",
//         "serial": "5555",
//         "local_id": "DUVoqoRpY2Vrbh4T",
//         "secret": "m3oGIjuOmFiuFUF29eqwPNT5l5oEwVLc"
