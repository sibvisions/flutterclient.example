import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jvx_flutterclient/ui/page/menu_page.dart';
import 'package:jvx_flutterclient/ui/widgets/menu_drawer_widget.dart';
import 'package:jvx_flutterclient/utils/globals.dart' as globals;
import 'package:jvx_flutterclient/utils/uidata.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'custom_rounded_button.dart';

class QrScannerCustomWidget extends StatefulWidget {
  @override
  _QrScannerCustomWidgetState createState() => _QrScannerCustomWidgetState();
}

class _QrScannerCustomWidgetState extends State<QrScannerCustomWidget> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String scanResult;

  // static final _possibleFormats = BarcodeFormat.values.toList()
  //   ..removeWhere((e) => e == BarcodeFormat.unknown);
  // final _flashOnController = TextEditingController(text: "Flash on");
  // final _flashOffController = TextEditingController(text: "Flash off");
  // final _cancelController = TextEditingController(text: "Cancel");

  // var _aspectTolerance = 0.00;
  // var _numberOfCameras = 0;
  // var _selectedCamera = -1;
  // var _useAutoFocus = true;
  // var _autoEnableFlash = false;

  // List<BarcodeFormat> selectedFormats = _possibleFormats.toList();

  Future scan() async {
    try {
      // var options = ScanOptions(
      //   strings: {
      //     "cancel": _cancelController.text,
      //     "flash_on": _flashOnController.text,
      //     "flash_off": _flashOffController.text,
      //   },
      //   restrictFormat: selectedFormats,
      //   useCamera: _selectedCamera,
      //   autoEnableFlash: _autoEnableFlash,
      //   android: AndroidOptions(
      //     aspectTolerance: _aspectTolerance,
      //     useAutoFocus: _useAutoFocus,
      //   ),
      // );

      // var result = await BarcodeScanner.scan(options: options);

      var result = await BarcodeScanner.scan();

      setState(() {
        scanResult = result;
        print("THIS WAS SCANNED" + scanResult);
      });
    } on PlatformException catch (e) {
      var result = 'Error';
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = 'The user did not grant the camera permission!';
        });
      } else {
        result = 'Unknown error: $e';
      }
      setState(() {
        scanResult = result;
        print("THIS WAS SCANNED" + scanResult);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String numberToCall;

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              settings: RouteSettings(name: '/Menu'),
              builder: (_) => MenuPage(
                    menuItems: globals.items,
                  )));
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: globals.appFrame.showScreenHeader
              ? AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          settings: RouteSettings(name: '/Menu'),
                          builder: (_) => MenuPage(
                                menuItems: globals.items,
                              )));
                    },
                  ),
                  title: Text('Scan QR Code'),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(FontAwesomeIcons.ellipsisV),
                      onPressed: () =>
                          _scaffoldKey.currentState.openEndDrawer(),
                    )
                  ],
                )
              : null,
          endDrawer: MenuDrawerWidget(
              menuItems: globals.items,
              listMenuItems: true,
              currentTitle: 'Scan QR Code',
              groupedMenuMode: true),
          body: Center(
            child: Container(
              margin: EdgeInsets.all(15),
              height: 150,
              decoration: BoxDecoration(
                color: UIData.ui_kit_color_2,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Result:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      scanResult == null
                          ? 'Nothing scanned yet!'
                          : scanResult?.toString(),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomRoundedButton(
                              "Scan",
                              Icon(FontAwesomeIcons.qrcode,
                                  color: Colors.white), () {
                            scan();
                          }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
