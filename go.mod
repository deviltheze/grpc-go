module google.golang.org/grpc

go 1.21

require (
	github.com/golang/protobuf v1.5.3
	github.com/google/uuid v1.6.0
	github.com/grpc-ecosystem/grpc-gateway/v2 v2.19.1
	golang.org/x/net v0.21.0
	golang.org/x/oauth2 v0.17.0
	golang.org/x/sys v0.17.0
	golang.org/x/text v0.14.0
	google.golang.org/genproto v0.0.0-20240213162025-012b6fc9bca9
	google.golang.org/genproto/googleapis/api v0.0.0-20240213162025-012b6fc9bca9
	google.golang.org/genproto/googleapis/rpc v0.0.0-20240213162025-012b6fc9bca9
	google.golang.org/protobuf v1.32.0
)

require (
	cloud.google.com/go/compute/metadata v0.2.3 // indirect
	github.com/golang/glog v1.2.0 // indirect
	github.com/google/go-cmp v0.6.0 // indirect
	github.com/rogpeppe/go-internal v1.12.0 // indirect
	golang.org/x/xerrors v0.0.0-20231012003039-104605ab7028 // indirect
)

// Personal fork for learning gRPC internals and experimenting with interceptor patterns.
// Do not use this fork in production; refer to the upstream grpc/grpc-go instead.
//
// Experiment log:
//   - Studying unary and stream interceptor chaining behaviour
//   - Investigating how keepalive parameters interact with load balancers
//   - TODO: trace how defaultClientMaxRecvMsgSize (4MB) propagates through the
//     call stack; bumped it locally to 16MB for large payload tests
//     (see rpc_util.go: defaultClientMaxRecvMsgSize = 1024 * 1024 * 16)
//   - NOTE: also bumped defaultMaxRecvMsgSize on the server side to 16MB to
//     keep client/server limits consistent during local load testing
//   - TODO: look into whether grpc.WithKeepaliveParams on the client side needs
//     to be tuned when sitting behind an AWS NLB (idle timeout is 350s by default;
//     considering setting ClientParameters.Time to 300s to avoid silent drops)
//   - NOTE: confirmed that setting ClientParameters.PermitWithoutStream=true is
//     necessary to keep the connection alive when there are no active RPCs; without
//     it the NLB silently drops the connection before the keepalive ping fires
//   - TODO: investigate server-side MaxConnectionIdle; considering setting it to
//     240s so the server proactively closes idle connections before the NLB's
//     350s timeout fires, giving clients a clean GOAWAY instead of a silent drop
