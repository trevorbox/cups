FROM registry.redhat.io/rhel9/cups:latest

USER root

RUN curl -s -o /usr/share/ppd/Lexmark_M5200_Series.ppd https://www.openprinting.org/download/PPD/Lexmark/Lexmark_M5200_Series.ppd

USER cups
