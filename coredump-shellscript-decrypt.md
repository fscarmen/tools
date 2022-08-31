---
title: 使用Core Dump对Shell Script解密
categories: 编程
tags: 
    - 编程
    - Shell
    - 脚本
    - 加密
    - 解密
    - Linux
date: 2022-03-09 10:53:40
---

在一些仓库内，我们想修改一些代码的时候，却发现作者很鸡贼的对脚本进行了加密。这篇文章主要来讲使用Core Dump对加密的Shell脚本进行解密。

![](https://gcore.jsdelivr.net/gh/Misaka-blog/tuchuang@master/20220225234203.png)

> 感谢某作者在GitHub的付出，让我得以写一篇文章

## 准备材料

* 一台VPS

## 解密步骤

1. SSH登录至VPS
2. 登录Root用户，执行以下命令

```shell
ulimit -c unlimited
echo "/core_dump/%e-%p-%t.core" > /proc/sys/kernel/core_pattern
mkdir /core_dump
```

第一句是设置内核coredump大小，这里设置不限制。第二句是设置coredump存储位置和格式，%e代表可执行程序名，%p代表pid， %t代表生成时间。然后去执行脚本如xxx.sh

3. 在执行需要解密的代码后面加入`6 start & (sleep 0.01 && kill -SIGSEGV $!)`，例如`./xxx.sh 6 start & (sleep 0.01 && kill -SIGSEGV $!)`，如无意外之后会输出类似[1]+ Segmentation fault (core dumped)...的提示

4. 查看`/core_dump`文件夹下，就会有dump生成的文件了

![](https://gcore.jsdelivr.net/gh/Misaka-blog/tuchuang@master/20220225235718.png)

5. 使用VS Code打开文件

![](https://gcore.jsdelivr.net/gh/Misaka-blog/tuchuang@master/20220225234716.png)

6. 拉下文件，可以看到代码已经解密出来了

![](https://gcore.jsdelivr.net/gh/Misaka-blog/tuchuang@master/20220225234816.png)

## 参考资料

FTown Blog：https://www.fythonfang.com/blog/2019/10/16/linux-core-dump-decrypt-script