FROM eavatar/builder

ENV DEBIAN_FRONTEND noninteractive
ADD pgdg.list /etc/apt/sources.list.d/
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-9.4 postgresql-client-9.4

RUN mkdir -p /dist
WORKDIR /dist

RUN mkdir -p var/lib/postgresql var/run/postgresql usr/lib/postgresql usr/share usr/lib/sudo etc lib usr/bin etc/pam.d etc/sudoers.d var/lib/sudo
RUN cp -a /usr/lib/postgresql usr/lib/
RUN cp -a /usr/share/postgresql usr/share/
RUN cp -a /usr/share/zoneinfo usr/share/
RUN cp -a /usr/share/locale usr/share/
RUN cp -r /etc/postgresql etc/
RUN cp -r /etc/postgresql-common etc/

RUN cp -r /usr/lib/sudo/* usr/lib/sudo/
RUN cp /usr/bin/sudo usr/bin
RUN cp /etc/sudoers etc/
RUN cp /etc/pam.conf etc/
RUN cp -r /etc/pam.d/* etc/pam.d/

RUN cp /usr/bin/pg_upgradecluster usr/bin/
RUN cp /usr/bin/pg_createcluster usr/bin/
RUN cp /usr/bin/pg_virtualenv usr/bin/
RUN cp /usr/bin/pg_ctlcluster usr/bin/
RUN cp /usr/bin/pg_config usr/bin/
RUN cp /usr/bin/locale usr/bin/

RUN \
	cp /lib/x86_64-linux-gnu/libpam.so.0 lib/ &&\
	cp /lib/x86_64-linux-gnu/libutil.so.1 lib/ &&\
	cp /lib/x86_64-linux-gnu/libpcre.so.3 lib/ &&\
	cp /lib/x86_64-linux-gnu/libssl.so.1.0.0 lib/ &&\
	cp /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 lib/ &&\
	cp /lib/x86_64-linux-gnu/libcrypt.so.1 lib &&\
	cp /lib/x86_64-linux-gnu/libgcrypt.so.11 lib &&\
	cp /lib/x86_64-linux-gnu/libcom_err.so.2 lib/ &&\
	cp /lib/x86_64-linux-gnu/liblzma.so.5 lib/ &&\
	cp /lib/x86_64-linux-gnu/libaudit.so.1 lib/ &&\
	cp /lib/x86_64-linux-gnu/libkeyutils.so.1 lib/ &&\
	cp /lib/x86_64-linux-gnu/libresolv.so.2 lib/ &&\
	cp /lib/x86_64-linux-gnu/libgpg-error.so.0 lib &&\
	cp /lib/x86_64-linux-gnu/libselinux.so.1 lib/ &&\
	cp /lib/x86_64-linux-gnu/libpthread.so.0 lib/ &&\
	cp /lib/x86_64-linux-gnu/libz.so.1 lib/ &&\
	cp /lib/x86_64-linux-gnu/security/pam_env.so lib/ &&\
	cp /lib/x86_64-linux-gnu/security/pam_deny.so lib/ &&\
	cp /lib/x86_64-linux-gnu/security/pam_unix.so lib/ &&\
	cp /lib/x86_64-linux-gnu/security/pam_permit.so lib/ &&\
	cp /lib/x86_64-linux-gnu/security/pam_cap.so lib/ &&\
	cp /lib/x86_64-linux-gnu/security/pam_umask.so lib/

RUN \
	cp /usr/lib/x86_64-linux-gnu/libxml2.so.2 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/liblber-2.4.so.2 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libsasl2.so.2 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2 usr/lib/ &&\
	cp /usr/lib/x86_64-linux-gnu/libgssapi.so.3 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libgnutls.so.26 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libldap_r-2.4.so.2 usr/lib/ &&\
	cp /usr/lib/x86_64-linux-gnu/libheimntlm.so.0 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libk5crypto.so.3 usr/lib/ &&\
	cp /usr/lib/x86_64-linux-gnu/libkrb5support.so.0 usr/lib/ &&\
	cp /usr/lib/x86_64-linux-gnu/libkrb5.so.26 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libkrb5.so.3 usr/lib/ &&\
	cp /usr/lib/x86_64-linux-gnu/libasn1.so.8 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libhcrypto.so.4 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libroken.so.18 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libtasn1.so.6 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libp11-kit.so.0 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libwind.so.0 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libheimbase.so.1 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libhx509.so.5 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libedit.so.2 usr/lib &&\
	cp /usr/lib/x86_64-linux-gnu/libffi.so.6 usr/lib


RUN tar cf /overlayfs.tar .
