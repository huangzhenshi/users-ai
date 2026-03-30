---
inclusion: auto
---

# 项目环境配置

- 项目使用 JDK 17，系统默认 JDK 是 11
- JDK 17 路径：`D:\install\java\jdk-17.0.6`
- Maven 路径：`D:\install\apache-maven-3.9.14`

运行任何 Maven 命令时，必须指定 JAVA_HOME 和 PATH：

```powershell
$env:JAVA_HOME="D:\install\java\jdk-17.0.6"; $env:PATH="D:\install\java\jdk-17.0.6\bin;D:\install\apache-maven-3.9.14\bin;$env:PATH"; mvn <command>
```
