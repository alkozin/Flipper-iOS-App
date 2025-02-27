// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: events/update_flipper_start.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Metric_Events_UpdateFlipperStart: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var updateFrom: String = String()

  var updateTo: String = String()

  var updateID: Int64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "metric.events"

extension Metric_Events_UpdateFlipperStart: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".UpdateFlipperStart"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "update_from"),
    2: .standard(proto: "update_to"),
    3: .standard(proto: "update_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.updateFrom) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.updateTo) }()
      case 3: try { try decoder.decodeSingularInt64Field(value: &self.updateID) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.updateFrom.isEmpty {
      try visitor.visitSingularStringField(value: self.updateFrom, fieldNumber: 1)
    }
    if !self.updateTo.isEmpty {
      try visitor.visitSingularStringField(value: self.updateTo, fieldNumber: 2)
    }
    if self.updateID != 0 {
      try visitor.visitSingularInt64Field(value: self.updateID, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Metric_Events_UpdateFlipperStart, rhs: Metric_Events_UpdateFlipperStart) -> Bool {
    if lhs.updateFrom != rhs.updateFrom {return false}
    if lhs.updateTo != rhs.updateTo {return false}
    if lhs.updateID != rhs.updateID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
