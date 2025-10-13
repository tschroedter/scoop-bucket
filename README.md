# tschroedter Scoop Bucket

[![Tests](https://github.com/tschroedter/scoop-bucket/actions/workflows/ci.yml/badge.svg)](https://github.com/tschroedter/scoop-bucket/actions/workflows/ci.yml)
[![Excavator](https://github.com/tschroedter/scoop-bucket/actions/workflows/excavator.yml/badge.svg)](https://github.com/tschroedter/scoop-bucket/actions/workflows/excavator.yml)

A custom [Scoop](https://scoop.sh) bucket for Windows command-line installations. This bucket includes utilities tailored for automation, scripting, and hardware control — starting with the Idasen System Tray app for Bluetooth desk control.

---

## 🚀 How to Use This Bucket

```powershell
scoop bucket add tschroedter https://github.com/tschroedter/scoop-bucket
scoop install tschroedter/idasen-systemtray
