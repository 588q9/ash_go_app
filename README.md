# ash_go
通信客户端
基本功能
设计与实现了一个基于dart事件循环的异步多线程(isolate)socket客户端，实现了对TCP流的TLV解码与控制字节读写的工具类

保障功能
超时重传
断线重连
定时发送Ping保活

高级功能
考虑异步多isolate多socket轮调，防止阻塞单个TCP流或isolate事件循环




## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
