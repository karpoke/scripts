#!/bin/sh

cd "$HOME" || exit

# list cleaners: bleachbit -l

/usr/bin/bleachbit \
    --clean \
    adobe_reader.cache \
    adobe_reader.mru \
    adobe_reader.tmp \
    amsn.cache \
    amsn.chat_logs \
    amule.logs \
    amule.tmp \
    audacious.cache \
    audacious.log \
    beagle.cache \
    beagle.logs \
    chromium.cache \
    chromium.vacuum \
    deepscan.tmp \
    easytag.logs \
    emesene.cache \
    emesene.logs \
    epiphany.cache \
    evolution.cache \
    exaile.cache \
    exaile.log \
    firefox.cache \
    firefox.crash_reports \
    firefox.vacuum \
    flash.cache \
    flash.cookies \
    gftp.cache \
    gftp.logs \
    gimp.tmp \
    gl-117.debug_logs \
    google_chrome.cache \
    google_chrome.vacuum \
    google_earth.temporary_files \
    gpodder.cache \
    gpodder.vacuum \
    hexchat.logs \
    hippo_opensim_viewer.cache \
    hippo_opensim_viewer.logs \
    java.cache \
    kde.cache \
    kde.tmp \
    libreoffice.cache \
    libreoffice.history \
    liferea.cache \
    liferea.vacuum \
    miro.cache \
    miro.logs \
    nexuiz.cache \
    openofficeorg.cache \
    opera.cache \
    pidgin.cache \
    pidgin.logs \
    realplayer.logs \
    rhythmbox.cache \
    screenlets.logs \
    seamonkey.cache \
    secondlife_viewer.Cache \
    secondlife_viewer.Logs \
    sqlite3.history \
    system.cache \
    system.memory \
    system.rotated_logs \
    system.tmp \
    system.trash \
    thumbnails.cache \
    thunderbird.cache \
    thunderbird.vacuum \
    tremulous.cache \
    vuze.cache \
    vuze.logs \
    vuze.tmp \
    warzone2100.logs \
    wine.tmp \
    winetricks.temporary_files \
    x11.debug_logs \
    xine.cache \
    yum.vacuum \
    2>&1

