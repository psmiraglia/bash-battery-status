# Battery Status

Send a user notification (via `notify-send`) when

* the battery capacity is **less than 40%** and the status is **Discharging**
* the battery capacity is **more than 80%** and the status is **Charging**

# How to use it with crontab

1.  Put the `battery-status.sh` script where you prefer and make it executable

    ~~~
    $ cp battery-status.sh /opt/tools/battery-status.sh
    $ chmod +x /opt/tools/battery-status.sh
    ~~~

2.  Configure `crontab` in order to execute the script every five minutes

    ~~~
    $ echo '*/5 * * * * root /opt/tools/battery-status.sh' > /etc/cron.d/battery-status
    ~~~

3.  Enjoy!
