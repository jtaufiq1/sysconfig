● pop-os
    State: degraded
    Units: 308 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 2 units
    Since: Mon 2025-09-08 22:46:33 GMT; 10min ago
  systemd: 255.4-1ubuntu8.10~1753120728~24.04~c44d1c4
   CGroup: /user.slice/user-1000.slice/user@1000.service
           ├─app.slice
           │ ├─app-cosmic-com.system76.CosmicAppList-36675.scope
           │ │ ├─36675 alacritty
           │ │ ├─36686 /bin/bash
           │ │ └─36759 btop
           │ ├─app-dbus\x2d:1.1\x2dorg.gnome.Identity.slice
           │ │ └─dbus-:1.1-org.gnome.Identity@0.service
           │ │   └─36273 /usr/libexec/goa-identity-service
           │ ├─app-dbus\x2d:1.1\x2dorg.gnome.OnlineAccounts.slice
           │ │ └─dbus-:1.1-org.gnome.OnlineAccounts@0.service
           │ │   └─36233 /usr/libexec/goa-daemon
           │ ├─app-dbus\x2d:1.85\x2dorg.a11y.atspi.Registry.slice
           │ │ └─dbus-:1.85-org.a11y.atspi.Registry@0.service
           │ │   └─36230 /usr/libexec/at-spi2-registryd --use-gnome-session
           │ ├─app-geoclue\x2ddemo\x2dagent@autostart.service
           │ │ └─35978 /usr/libexec/geoclue-2.0/demos/agent
           │ ├─app-org.gnome.Evolution\x2dalarm\x2dnotify@autostart.service
           │ │ └─35940 /usr/libexec/evolution-data-server/evolution-alarm-notify
           │ ├─app-print\x2dapplet@autostart.service
           │ │ └─35981 /usr/bin/python3 /usr/share/system-config-printer/applet.py
           │ ├─com.system76.SystemUpdater.Local.service
           │ │ └─36426 /usr/bin/pop-system-updater
           │ ├─cosmic-app-library.scope
           │ │ └─35769 cosmic-app-library
           │ ├─cosmic-bg.scope
           │ │ └─35793 cosmic-bg
           │ ├─cosmic-files-applet.scope
           │ │ └─35802 cosmic-files-applet
           │ ├─cosmic-greeter.scope
           │ │ └─35798 cosmic-greeter
           │ ├─cosmic-idle.scope
           │ │ └─35805 cosmic-idle
           │ ├─cosmic-launcher.scope
           │ │ ├─35772 cosmic-launcher
           │ │ ├─35857 pop-launcher --max-open 99 --max-files 20 --max-search 20
           │ │ ├─35876 /usr/lib/pop-launcher/plugins/cosmic_toplevel/cosmic-toplevel
           │ │ └─35877 /usr/lib/pop-launcher/plugins/pop_shell/pop-shell
           │ ├─cosmic-osd.scope
           │ │ └─35783 cosmic-osd
           │ ├─cosmic-workspaces.scope
           │ │ └─35777 cosmic-workspaces
           │ ├─dconf.service
           │ │ └─35800 /usr/libexec/dconf-service
           │ ├─evolution-addressbook-factory.service
           │ │ └─36323 /usr/libexec/evolution-addressbook-factory
           │ ├─evolution-calendar-factory.service
           │ │ └─36291 /usr/libexec/evolution-calendar-factory
           │ ├─evolution-source-registry.service
           │ │ └─36168 /usr/libexec/evolution-source-registry
           │ ├─gcr-ssh-agent.service
           │ │ └─35770 /usr/libexec/gcr-ssh-agent --base-dir /run/user/1000/gcr
           │ ├─gnome-keyring-daemon.service
           │ │ └─35621 /usr/bin/gnome-keyring-daemon --foreground --components=pkcs11,secrets --control-directory=/run/user/1000/keyring
           │ ├─xdg-desktop-portal-cosmic.scope
           │ │ └─35809 /usr/libexec/xdg-desktop-portal-cosmic
           │ └─xdg-desktop-portal-gtk.service
           │   └─36097 /usr/libexec/xdg-desktop-portal-gtk
           ├─init.scope
           │ ├─35593 /usr/lib/systemd/systemd --user
           │ └─35594 "(sd-pam)"
           └─session.slice
             ├─at-spi-dbus-bus.service
             │ ├─35821 /usr/libexec/at-spi-bus-launcher
             │ ├─36101 /usr/bin/dbus-broker-launch --config-file=/usr/share/defaults/at-spi2/accessibility.conf --scope user
             │ └─36104 dbus-broker --log 4 --controller 9 --machine-id 810a64766a1549dcd1f71bad67560cf9 --max-bytes 100000000000000 --max-fds 6400000 --max-matches 5000000000
             ├─dbus-broker.service
             │ ├─35612 /usr/bin/dbus-broker-launch --scope user
             │ └─35614 dbus-broker --log 4 --controller 10 --machine-id 810a64766a1549dcd1f71bad67560cf9 --max-bytes 100000000000000 --max-fds 25000000000000 --max-matches 5000000000
             ├─filter-chain.service
             │ └─35616 /usr/bin/pipewire -c filter-chain.conf
             ├─gvfs-afc-volume-monitor.service
             │ └─36281 /usr/libexec/gvfs-afc-volume-monitor
             ├─gvfs-daemon.service
             │ ├─35822 /usr/libexec/gvfsd
             │ └─35879 /usr/libexec/gvfsd-fuse /run/user/1000/gvfs -f
             ├─gvfs-goa-volume-monitor.service
             │ └─36217 /usr/libexec/gvfs-goa-volume-monitor
             ├─gvfs-gphoto2-volume-monitor.service
             │ └─36172 /usr/libexec/gvfs-gphoto2-volume-monitor
             ├─gvfs-mtp-volume-monitor.service
             │ └─36147 /usr/libexec/gvfs-mtp-volume-monitor
             ├─gvfs-udisks2-volume-monitor.service
             │ └─36088 /usr/libexec/gvfs-udisks2-volume-monitor
             ├─pipewire-pulse.service
             │ └─35620 /usr/bin/pipewire-pulse
             ├─pipewire.service
             │ └─35615 /usr/bin/pipewire
             ├─wireplumber.service
             │ └─35619 /usr/bin/wireplumber
             ├─xdg-desktop-portal.service
             │ └─35871 /usr/libexec/xdg-desktop-portal
             ├─xdg-document-portal.service
             │ ├─36004 /usr/libexec/xdg-document-portal
             │ └─36082 fusermount3 -o rw,nosuid,nodev,fsname=portal,auto_unmount,subtype=portal -- /run/user/1000/doc
             └─xdg-permission-store.service
               └─36018 /usr/libexec/xdg-permission-store
