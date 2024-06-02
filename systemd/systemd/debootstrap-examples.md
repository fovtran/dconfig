### Bootstrap base ubuntu skeleton
```
debootstrap --no-check-gpg \
            --arch amd64 \
            --components="main,restricted,universe,multiverse" \
            --include="openssh-server vim" \
            xenial \
            /tmp/ubuntu-bootstrap/ \
            http://archive.ubuntu.com/ubuntu/
```