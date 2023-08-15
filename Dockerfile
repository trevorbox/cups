FROM registry.redhat.io/rhel9/cups:latest

USER root

RUN curl -s -o /etc/cups/ppd/Lexmark_M5200_Series.ppd https://www.openprinting.org/download/PPD/Lexmark/Lexmark_M5200_Series.ppd && \
    chown -R cups:lp /etc/cups/ppd/

USER cups
