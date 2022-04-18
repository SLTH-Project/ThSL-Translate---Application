import 'package:thsltranslation/models/classifier.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ClassifierQuant extends Classifier {
  ClassifierQuant({int numThreads: 1}) : super(numThreads: numThreads);

  @override
  String get modelName => 'mobilenet_v1_1.0_224_quant.tflite';
  //String get modelName => 'model_MBv2.tflite';

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 1); //ไม่รู้ TT

  @override
  NormalizeOp get postProcessNormalizeOp =>
      NormalizeOp(0, 255); // ถ้าไม่ดีลอง (127.5, 127.5)
}
