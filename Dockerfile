FROM jgoerzen/dosbox

RUN mkdir /dos/drive_c/TP7
COPY ./Borland_TP7/ /dos/drive_c/TP7

RUN mkdir /dos/drive_c/knavi
# COPY ./knavigator/ /dos/drive_c/knavi

RUN echo 'path %PATH%;Y:\DOS;Y:\SCRIPTS;C:\TP7/BIN' >> /dos/dosbox.conf
RUN echo 'C:' >> /dos/dosbox.conf
RUN echo 'cd KNAVI' >> /dos/dosbox.conf
RUN echo 'turbo.exe KNavi.pas' >> /dos/dosbox.conf

EXPOSE 5901

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
