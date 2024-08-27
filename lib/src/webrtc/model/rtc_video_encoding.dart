import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A type that represents video encoding information.
@immutable
class RtcVideoEncoding
    with EquatableMixin
    implements Comparable<RtcVideoEncoding> {
  const RtcVideoEncoding({
    required this.maxFramerate,
    required this.maxBitrate,
    this.scaleResolutionDownBy,
  });

  final int maxFramerate;
  final int maxBitrate;
  final int? scaleResolutionDownBy;


  RtcVideoEncoding copyWith({
    int? maxFramerate,
    int? maxBitrate,
  }) {
    return RtcVideoEncoding(
      maxFramerate: maxFramerate ?? this.maxFramerate,
      maxBitrate: maxBitrate ?? this.maxBitrate,
    );
  }

  @override
  List<Object?> get props => [maxFramerate, maxBitrate];

  @override
  int compareTo(RtcVideoEncoding other) {
    final result = maxBitrate.compareTo(other.maxBitrate);
    if (result == 0) {
      return maxFramerate.compareTo(other.maxFramerate);
    }
    return result;
  }

  @override
  String toString() {
    return 'Encoding{maxFramerate: $maxFramerate, maxBitrate: $maxBitrate}';
  }
}
