import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedBoxExtension on num {
  SizedBox get sH => SizedBox(height: toDouble().h);
  SizedBox get sW => SizedBox(width: toDouble().w);
}
