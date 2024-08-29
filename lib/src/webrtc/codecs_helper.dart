import 'dart:math' as math;

import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../logger/stream_log.dart';
import 'model/rtc_video_dimension.dart';
import 'model/rtc_video_parameters.dart';

// 16:9 default
const _defaultSimulcast_16x9 = {
  'f': RtcVideoParametersPresets.h720_16x960fpsHigh,
  'h': RtcVideoParametersPresets.h720_16x960fpsMedium,
  'q': RtcVideoParametersPresets.h720_16x960fpsLow,
};


List<rtc.RTCRtpEncoding> computeVideoEncodings({
  required RtcVideoDimension dimension,
  required bool isScreenShare,
}) {
  final presets = _presetsForDimension(
    isScreenShare: isScreenShare,
    dimension: dimension,
  );
  presets.forEach((rid, preset) {
    streamLog.v(
      'SV:RtcManager',
      () => '[publishVideoTrack] #$rid; preset: $preset',
    );
  });

  return encodingsFromPresets(dimension, presets: presets);
}

Map<String, RtcVideoParameters> _presetsForDimension({
  required bool isScreenShare,
  required RtcVideoDimension dimension,
}) {
  if (isScreenShare) {
    return _defaultSimulcast_16x9;
  }

  final aspectRatio = dimension.aspect();
  streamLog.v(
    'SV:RtcManager',
    () => '[publishVideoTrack] aspectRatio: $aspectRatio',
  );
  return _defaultSimulcast_16x9;
}

List<rtc.RTCRtpEncoding> encodingsFromPresets(
  RtcVideoDimension dimension, {
  required Map<String, RtcVideoParameters> presets,
}) {
  final result = <rtc.RTCRtpEncoding>[];

  presets.forEach((rid, preset) {
    final scaleResolutionDownBy = preset.encoding.scaleResolutionDownBy?.toDouble() ??
        math.max(1, dimension.min() / preset.dimension.min());
    streamLog.v(
      'SV:RtcManager',
      () => '[publishVideoTrack] #$rid; scaleResolutionDownBy: '
          '$scaleResolutionDownBy',
    );
    result.add(
      rtc.RTCRtpEncoding(
        rid: rid,
        scaleResolutionDownBy: scaleResolutionDownBy,
        maxFramerate: preset.encoding.maxFramerate,
        maxBitrate: preset.encoding.maxBitrate,
      ),
    );
  });
  return result;
}
