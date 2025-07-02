import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';



class CameraPage extends StatefulWidget {
  final  Function?  captureImage;
  final  SensorPosition? sensorPosition;
 // SensorPosition.front
   const  CameraPage({super.key, this.captureImage, this.sensorPosition  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CameraAwesomeBuilder.awesome(
          onMediaCaptureEvent: (event)  {
            switch ( ( event.status, event.isPicture, event.isVideo)) {
              case (MediaCaptureStatus.capturing, true, false):
                debugPrint('Capturing picture...');
              case (MediaCaptureStatus.success, true, false):
                event.captureRequest.when(
                  single: (single)  async {
                    debugPrint('Picture saved: ${single.file?.path}');
                    final Directory extDir = await getTemporaryDirectory();
                    final testDir = await Directory(
                      '${extDir.path}/woloo',
                    ).create(recursive: true);
                    final String filePath =
                        '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
                   File result =   await testCompressAndGetFile(File(single.file!.path), filePath );

                    widget.captureImage!(File(result.path) );
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                  multiple: (multiple) {
                    multiple.fileBySensor.forEach((key, value) {
                      debugPrint('multiple image taken: $key ${value?.path}');
                    });
                  },
                );
              case (MediaCaptureStatus.failure, true, false):
                debugPrint('Failed to capture picture: ${event.exception}');
              case (MediaCaptureStatus.capturing, false, true):
                debugPrint('Capturing video...');
              case (MediaCaptureStatus.success, false, true):
                event.captureRequest.when(
                  single: (single) {
                    debugPrint('Video saved: ${single.file?.path}');
                  },
                  multiple: (multiple) {
                    multiple.fileBySensor.forEach((key, value) {
                      debugPrint('multiple video taken: $key ${value?.path}');
                    });
                  },
                );
              case (MediaCaptureStatus.failure, false, true):
                debugPrint('Failed to capture video: ${event.exception}');
              default:
                debugPrint('Unknown event: $event');
            }
          },
          saveConfig: SaveConfig.photoAndVideo(

            initialCaptureMode: CaptureMode.photo,
            photoPathBuilder: (sensors) async {
              final Directory extDir = await getTemporaryDirectory();
              final testDir = await Directory(
                '${extDir.path}/woloo',
              ).create(recursive: true);
              if (sensors.length == 1) {
                final String filePath =
                    '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

                debugPrint("sdfsd $filePath");
             //   BlocProvider.of<CaptureBloc>(context).add(CaptureSelfie(image: File(filePath )  ));
                // widget.captureImage!( File(filePath) );
                return SingleCaptureRequest(filePath, sensors.first);
              }
             // Separate pictures taken with front and back camera
              return MultipleCaptureRequest(
                {
                  for (final sensor in sensors)
                    sensor:
                    '${testDir.path}/${sensor.position == SensorPosition.front ? 'front_' : "back_"}${DateTime.now().millisecondsSinceEpoch}.jpg',
                },
              );
            },
            videoOptions: VideoOptions(
              enableAudio: true,
              ios: CupertinoVideoOptions(
                fps: 10,
              ),
              android: AndroidVideoOptions(
                bitrate: 6000000,
                fallbackStrategy: QualityFallbackStrategy.lower,
              ),
            ),
            exifPreferences: ExifPreferences(saveGPSLocation: true)
          ),
          sensorConfig: SensorConfig.single(
            sensor: Sensor.position(widget.sensorPosition!),
            flashMode: FlashMode.auto,
            aspectRatio: CameraAspectRatios.ratio_4_3,
            zoom: 0.0,
          ),
          enablePhysicalButton: true,
          // filter: AwesomeFilter.AddictiveRed,
          previewAlignment: Alignment.center,
          previewFit: CameraPreviewFit.contain,
          onMediaTap: (mediaCapture) {
            mediaCapture.captureRequest.when(
              single: (single) {
             //   debugPrint('single: ${single.file?.path}');
              //  single.file?.open();

                debugPrint("sinfggg ${single.file!.path }");
              },
              multiple: (multiple) {
                multiple.fileBySensor.forEach((key, value) {
                  debugPrint('multiple file taken: $key ${value?.path}');
                 // value?.open();
                });
              },
            );
          },

          //  defaultFilter: A,
          availableFilters: const [],
        ),
      ),
    );
  }


  //
  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 50,
    );


      var compress =       File(result!.path);



    return compress;
  }

}
