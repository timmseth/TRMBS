# The Rotating MySQL Backup Script
TRMBS is an automatic way to keep X (a user-specified number) days worth of MySQL database backups with no fuss.
Designed for use with a standard LAMP setup and cron.

## How I Use This Script
*  Place it on a LAMP server and safeguard it as necessary.
    *  Do not put this script in a web-accessible directory.
    *  Use the following command in the directory containing TRMBS.sh to make the script executable:
    ```bash
    chmod a+x ./TRMBS.sh
    ```
*  Create a cron job to run this script daily. 
    *  Edit your cron jobs by running the following command as root:
    ```bash
    crontab -e
    ```
    *  If you need help with cron check out https://crontab.guru
    *  The following job will run daily at 8:30am:
    ```bash
    30 8 * * * /full/path/to/TRMBS.sh
    ```


************************************************************************

### License
This file is part of "The Rotating MySQL Backup Script" known hereafter known as "TRMBS".

TRMBS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

TRMBS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with TRMBS.  If not, see <http://www.gnu.org/licenses/>.
