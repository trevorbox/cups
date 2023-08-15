FROM registry.redhat.io/ubi8/ubi:latest

ENV NAME="rhel8/cups"
ENV VERSION="2.2.6"
ENV SUMMARY="CUPS printing system"
ENV DESCRIPTION="CUPS printing system provides a portable printing layer for \
                 UNIX® operating systems. It has been developed by Apple Inc. \
                 to promote a standard printing solution for all UNIX vendors and users. \
                 CUPS provides the System V and Berkeley command-line interfaces."

LABEL name="$NAME"
LABEL version="$VERSION"
LABEL summary="$SUMMARY"
LABEL description="$DESCRIPTION"
LABEL usage="podman run -d --name cups -p 6631:6631 $NAME"

LABEL com.redhat.component="cups-container"
LABEL io.k8s.description="$DESCRIPTION"
LABEL io.k8s.display-name="cups $VERSION"
LABEL io.openshift.expose-services="6631:cups"
LABEL io.openshift.tags="cups"

RUN dnf install -y cups && \
    dnf clean all

RUN mkdir /lexppds
RUN curl -o /lexppds/Lexmark_M5200_Series.ppd https://www.openprinting.org/download/PPD/Lexmark/Lexmark_M5200_Series.ppd 
RUN cp /lexppds/Lexmark_M5200_Series.ppd /etc/cups/ppd/

RUN sed -i "s/AccessLog syslog/AccessLog stderr/g" /etc/cups/cups-files.conf
RUN sed -i "s/ErrorLog syslog/ErrorLog stderr/g" /etc/cups/cups-files.conf
RUN sed -i "s/PageLog syslog/PageLog stderr/g" /etc/cups/cups-files.conf
RUN sed -i "s/Listen localhost:631/Listen localhost:6631/g" /etc/cups/cupsd.conf
RUN sed -i "s/Require user @SYSTEM/Require user @SYSTEM cups/g" /etc/cups/cupsd.conf

# we do not need to ship cups-brf backend and it works only under root user anyway
RUN rm -f /usr/lib/cups/backend/cups-brf

ENV CUPS_CONF=/etc/cups
ENV CUPS_LOGS=/var/log/cups
ENV CUPS_SPOOL=/var/spool/cups
ENV CUPS_CACHE=/var/cache/cups
ENV CUPS_RUN=/var/run/cups
ENV CUPS_LIB=/usr/lib/cups

RUN useradd -M cups

# Setup cache before first run
RUN mkdir -p ${CUPS_CACHE}

RUN chown -R cups ${CUPS_CONF} && \
    chown -R cups ${CUPS_LOGS} && \
    chown -R cups ${CUPS_SPOOL} && \
    chown -R cups ${CUPS_CACHE} && \
    chown -R cups ${CUPS_RUN} && \
    chown -R cups ${CUPS_LIB}

EXPOSE 6631

USER cups

#RUN cd ${CUPS_CONF}/ppd
# RUN curl -o Lexmark-UPD-PPD-Files.tar.Z https://downloads.lexmark.com/downloads/drivers/Lexmark-UPD-PPD-Files.tar.Z && \
#     tar xvf Lexmark-UPD-PPD-Files.tar.Z
# RUN cd ${CUPS_CONF}/ppd/ppd_files && \
#     ./install_ppd.sh

ENTRYPOINT /usr/sbin/cupsd -f
