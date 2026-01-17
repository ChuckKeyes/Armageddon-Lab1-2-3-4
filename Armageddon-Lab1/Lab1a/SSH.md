

For documentation, visit http://aws.amazon.com/documentation/ecs
[ec2-user@ip-10-10-10-150 ~]$ sudo tail -n 200 /var/log/cloud-init-output.log
Cloud-init v. 22.2.2 running 'init' at Fri, 16 Jan 2026 18:13:29 +0000. Up 6.39 seconds.
ci-info: ++++++++++++++++++++++++++++++++++++++Net device info+++++++++++++++++++++++++++++++++++++++
ci-info: +--------+------+-----------------------------+---------------+--------+-------------------+
ci-info: | Device |  Up  |           Address           |      Mask     | Scope  |     Hw-Address    |
ci-info: +--------+------+-----------------------------+---------------+--------+-------------------+
ci-info: |  ens5  | True |         10.10.10.150        | 255.255.255.0 | global | 06:3b:ba:76:23:0d |
ci-info: |  ens5  | True | fe80::43b:baff:fe76:230d/64 |       .       |  link  | 06:3b:ba:76:23:0d |
ci-info: |   lo   | True |          127.0.0.1          |   255.0.0.0   |  host  |         .         |
ci-info: |   lo   | True |           ::1/128           |       .       |  host  |         .         |
ci-info: +--------+------+-----------------------------+---------------+--------+-------------------+
ci-info: +++++++++++++++++++++++++++++Route IPv4 info++++++++++++++++++++++++++++++
ci-info: +-------+-------------+------------+-----------------+-----------+-------+
ci-info: | Route | Destination |  Gateway   |     Genmask     | Interface | Flags |
ci-info: +-------+-------------+------------+-----------------+-----------+-------+
ci-info: |   0   |   0.0.0.0   | 10.10.10.1 |     0.0.0.0     |    ens5   |   UG  |
ci-info: |   1   |  10.10.0.2  | 10.10.10.1 | 255.255.255.255 |    ens5   |  UGH  |
ci-info: |   2   |  10.10.10.0 |  0.0.0.0   |  255.255.255.0  |    ens5   |   U   |
ci-info: |   3   |  10.10.10.1 |  0.0.0.0   | 255.255.255.255 |    ens5   |   UH  |
ci-info: +-------+-------------+------------+-----------------+-----------+-------+
ci-info: +++++++++++++++++++Route IPv6 info+++++++++++++++++++
ci-info: +-------+-------------+---------+-----------+-------+
ci-info: | Route | Destination | Gateway | Interface | Flags |
ci-info: +-------+-------------+---------+-----------+-------+
ci-info: |   0   |  fe80::/64  |    ::   |    ens5   |   U   |
ci-info: |   2   |    local    |    ::   |    ens5   |   U   |
ci-info: |   3   |  multicast  |    ::   |    ens5   |   U   |
ci-info: +-------+-------------+---------+-----------+-------+
Generating public/private ed25519 key pair.
Your identification has been saved in /etc/ssh/ssh_host_ed25519_key
Your public key has been saved in /etc/ssh/ssh_host_ed25519_key.pub
The key fingerprint is:
SHA256:TJQb/Q9RhINhrvRPZNh9n0/dG88lgiuZwg7Gi+zlD3I root@ip-10-10-10-150.ap-northeast-1.compute.internal
The key's randomart image is:
+--[ED25519 256]--+
|        .ooo +o  |
|       .oooo+.   |
|        ooo.+o. .|
|       +.o +o  .=|
|        S o oo.o*|
|   . .   o + ..+*|
|  . E o + . .  .+|
| . B = . .       |
| .+ o.o          |
+----[SHA256]-----+
Generating public/private ecdsa key pair.
Your identification has been saved in /etc/ssh/ssh_host_ecdsa_key
Your public key has been saved in /etc/ssh/ssh_host_ecdsa_key.pub
The key fingerprint is:
SHA256:tuX6tnHFGPCVR1YBQJgon7JdGjlFn2GY849UvPgecJg root@ip-10-10-10-150.ap-northeast-1.compute.internal
The key's randomart image is:
+---[ECDSA 256]---+
|        o.B=o.o+*|
|     . . Booo+...|
|      o + ooB .. |
|     . * . E *   |
|      + S o B o  |
|     . + + . =   |
|        . o o .  |
|         ..o .   |
|        .oo.     |
+----[SHA256]-----+
Cloud-init v. 22.2.2 running 'modules:config' at Fri, 16 Jan 2026 18:13:31 +0000. Up 7.63 seconds.
Cloud-init v. 22.2.2 running 'modules:final' at Fri, 16 Jan 2026 18:13:31 +0000. Up 8.08 seconds.
Amazon Linux 2023 repository                     66 MB/s |  52 MB     00:00    
Amazon Linux 2023 Kernel Livepatch repository   247 kB/s |  30 kB     00:00    
Dependencies resolved.
Nothing to do.
Complete!
Last metadata expiration check: 0:00:02 ago on Fri Jan 16 18:13:46 2026.
Dependencies resolved.
================================================================================
 Package             Arch      Version                     Repository      Size
================================================================================
Installing:
 python3-pip         noarch    21.3.1-2.amzn2023.0.14      amazonlinux    1.8 M
Installing weak dependencies:
 libxcrypt-compat    x86_64    4.4.33-7.amzn2023           amazonlinux     92 k

Transaction Summary
================================================================================
Install  2 Packages

Total download size: 1.9 M
Installed size: 11 M
Downloading Packages:
(1/2): python3-pip-21.3.1-2.amzn2023.0.14.noarc  36 MB/s | 1.8 MB     00:00    
(2/2): libxcrypt-compat-4.4.33-7.amzn2023.x86_6 1.7 MB/s |  92 kB     00:00    
--------------------------------------------------------------------------------
Total                                            19 MB/s | 1.9 MB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1 
  Installing       : libxcrypt-compat-4.4.33-7.amzn2023.x86_64              1/2 
  Installing       : python3-pip-21.3.1-2.amzn2023.0.14.noarch              2/2 
  Running scriptlet: python3-pip-21.3.1-2.amzn2023.0.14.noarch              2/2 
  Verifying        : libxcrypt-compat-4.4.33-7.amzn2023.x86_64              1/2 
  Verifying        : python3-pip-21.3.1-2.amzn2023.0.14.noarch              2/2 

Installed:
  libxcrypt-compat-4.4.33-7.amzn2023.x86_64                                     
  python3-pip-21.3.1-2.amzn2023.0.14.noarch                                     

Complete!
Collecting flask
  Downloading flask-3.1.2-py3-none-any.whl (103 kB)
Collecting pymysql
  Downloading pymysql-1.1.2-py3-none-any.whl (45 kB)
Collecting boto3
  Downloading boto3-1.42.29-py3-none-any.whl (140 kB)
Collecting jinja2>=3.1.2
  Downloading jinja2-3.1.6-py3-none-any.whl (134 kB)
Collecting itsdangerous>=2.2.0
  Downloading itsdangerous-2.2.0-py3-none-any.whl (16 kB)
Collecting importlib-metadata>=3.6.0
  Downloading importlib_metadata-8.7.1-py3-none-any.whl (27 kB)
Collecting click>=8.1.3
  Downloading click-8.1.8-py3-none-any.whl (98 kB)
Collecting markupsafe>=2.1.1
  Downloading markupsafe-3.0.3-cp39-cp39-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl (20 kB)
Collecting werkzeug>=3.1.0
  Downloading werkzeug-3.1.5-py3-none-any.whl (225 kB)
Collecting blinker>=1.9.0
  Downloading blinker-1.9.0-py3-none-any.whl (8.5 kB)
Collecting s3transfer<0.17.0,>=0.16.0
  Downloading s3transfer-0.16.0-py3-none-any.whl (86 kB)
Collecting botocore<1.43.0,>=1.42.29
  Downloading botocore-1.42.29-py3-none-any.whl (14.6 MB)
Requirement already satisfied: jmespath<2.0.0,>=0.7.1 in /usr/lib/python3.9/site-packages (from boto3) (0.10.0)
Requirement already satisfied: urllib3<1.27,>=1.25.4 in /usr/lib/python3.9/site-packages (from botocore<1.43.0,>=1.42.29->boto3) (1.25.10)
Requirement already satisfied: python-dateutil<3.0.0,>=2.1 in /usr/lib/python3.9/site-packages (from botocore<1.43.0,>=1.42.29->boto3) (2.8.1)
Collecting zipp>=3.20
  Downloading zipp-3.23.0-py3-none-any.whl (10 kB)
Requirement already satisfied: six>=1.5 in /usr/lib/python3.9/site-packages (from python-dateutil<3.0.0,>=2.1->botocore<1.43.0,>=1.42.29->boto3) (1.15.0)
Installing collected packages: zipp, markupsafe, botocore, werkzeug, s3transfer, jinja2, itsdangerous, importlib-metadata, click, blinker, pymysql, flask, boto3
  Attempting uninstall: markupsafe
    Found existing installation: MarkupSafe 1.1.1
    Uninstalling MarkupSafe-1.1.1:
      Successfully uninstalled MarkupSafe-1.1.1
  Attempting uninstall: jinja2
    Found existing installation: Jinja2 2.11.3
    Uninstalling Jinja2-2.11.3:
      Successfully uninstalled Jinja2-2.11.3
Successfully installed blinker-1.9.0 boto3-1.42.29 botocore-1.42.29 click-8.1.8 flask-3.1.2 importlib-metadata-8.7.1 itsdangerous-2.2.0 jinja2-3.1.6 markupsafe-3.0.3 pymysql-1.1.2 s3transfer-0.16.0 werkzeug-3.1.5 zipp-3.23.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Created symlink /etc/systemd/system/multi-user.target.wants/rdsapp.service → /etc/systemd/system/rdsapp.service.
2026-01-16 18:13:57,678 - util.py[WARNING]: Failed to render final message template