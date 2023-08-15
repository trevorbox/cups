FROM registry.redhat.io/rhel9/cups

USER root

RUN mkdir /lexppds
RUN curl -o /lexppds/Lexmark_M5200_Series.ppd https://www.openprinting.org/download/PPD/Lexmark/Lexmark_M5200_Series.ppd 
RUN cp /lexppds/Lexmark_M5200_Series.ppd /etc/cups/ppd/

USER cups


ENTRYPOINT /usr/sbin/cupsd -f
