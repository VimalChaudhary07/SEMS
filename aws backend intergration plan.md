# SEMS AWS Backend Integration Plan

The comprehensive AWS backend integration plan has been compiled into **[AWS_BACKEND_INTEGRATION_PLAN.md](file:///d:/flutter_env/sems/AWS_BACKEND_INTEGRATION_PLAN.md)**.

Please refer to [AWS_BACKEND_INTEGRATION_PLAN.md](file:///d:/flutter_env/sems/AWS_BACKEND_INTEGRATION_PLAN.md) for:
- End-to-End AWS Architecture & Service Topology (IoT Core, Timestream, DynamoDB, Cognito, Lambda, EventBridge, SageMaker, Bedrock).
- Edge-to-Cloud mTLS X.509 Communication, ESP32-S3 + ATECC608A Hardware Specs & Fleet Provisioning by Claim.
- Device Shadow State Machine (`desired` vs. `reported`) and sub-500ms remote switching.
- Single-Table DynamoDB schema and Amazon Timestream time-series table definitions.
- Complete REST OpenAPI and WebSocket event protocols.
- Phased 8-stage cloud deployment roadmap.
- Comprehensive cost models for 1,000, 10,000, and 100,000 smart sockets.
