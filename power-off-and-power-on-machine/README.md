## Scheduled Power On

For scheduled power on of a machine use the script `power-on-timmer.sh`. This script need execute in `root` mode. The mode of use is:

- `power-on-timer.sh 'tomorrow 08:00'`

For more information you can execute `power-on-timer.sh help`.

## Scheduled Power Off

For scheduled power off of a machine use a cron job. For define de exac date you can use the following [page](https://crontab.guru/).

Following the next steps for configure the cron:

- First define the exact date, using the [page](https://crontab.guru/).
- Edit the crontab list with the command `crontab -e`
- Input the cron `* * * * * /sbin/shutdown -h now`. *NOTE*: change the `* * * * *`for your specific date.
- Save the cron and check if is all ok with `crontab -l`.

Other form for define the cron is using the following command:

```bash
echo '* * * * * /sbin/shutdown -h now' | crontab -
```
