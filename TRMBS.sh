#!/bin/sh

# +===========================================+
# |                  CREDITS                  |
# +===========================================+
#   Title: The Rotating MySQL Backup Script (TRMBS)
# Version: Version 1. Updated September 11, 2017.
#  Author: Seth Timmons
# Purpose: An automatic way to keep X days of MySQL database backups.

# +===========================================+
# |                  LICENSE                  |
# +===========================================+
# This file is "The Rotating MySQL Backup Script" known hereafter known as "TRMBS".
#
# TRMBS is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# TRMBS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with TRMBS.  If not, see <http://www.gnu.org/licenses/>.

# +===========================================+
# |                  CONFIG                   |
# +===========================================+
# |   Set these as you please. That rhymed.   |
# +===========================================+

# Set variables for the "mysqldump" command
DBSERVER=127.0.0.1
DATABASE=mydatabasename
USER=XXX
PASS=XXX

# Time stamp for rotation-based archiving functionality. 
# "$(date +%Y-%m-%d)" (Year-Month-Day Format) is recommended.
# Use whichever format works for you.
TIMESTAMP="$(date +%Y-%m-%d)"

# How many days do we want in our rotating backups?
# Any backups older than the specified amount will be purged automatically.
DAYSTOKEEP=30

# Your database dumps will be kept in this directory.
DESTINATION=/opt/dbBackups/fido/  

# File name you want to save this databases backups undre.
# "${DATABASE}.sql" (Database Name) is recommended.
# Use whatever name works for you.
BACKUPFILENAME=${DATABASE}.sql

# You shouldn't need to touch this variable.
# It creates an archival name based on the TIMESTAMP and BACKUPFILENAME values.
FILE=${BACKUPFILENAME}.${TIMESTAMP}

# +==================================================+
# |                PROGRAM EXECUTION                 |
# +==================================================+
# |   You shouldnt really need to edit below this.   |
# +==================================================+

# === START TMRBS PROGRAM ===
echo "Starting The Rotating MySQL Backup Script..."

# === DO THE DUMP ===
echo "Dumping MySQL Database '${DATABASE}' to ${DESTINATION}/${FILE}..."

# REMOTE DUMP
# You can add other options onto this command if they are needed.
# mysqldump --opt --protocol=TCP --user=${USER} --password=${PASS} --host=${DBSERVER} ${DATABASE} > ${FILE}

# LOCAL DUMP
# You can add other options onto this command if they are needed.
mysqldump --opt --user=${USER} --password=${PASS} ${DATABASE} > ${DESTINATION}/${FILE}

# === ARCHIVE IT WITH GZIP ===
echo "Zipping to save you space..."

# gzip it.
gzip ${DESTINATION}/${FILE}

# Display archival success message to user.
echo "${FILE}.gz was created:"
ls -l ${DESTINATION}/${FILE}.gz

# === ROTATE IT BASED ON DAYSTOKEEP ===
echo "Checking for backups that older than ${DAYSTOKEEP} days..."

# You shouldn't need to touch this variable.
# It is used to check for old and unneeded gzip files.
# It is based upon your BACKUPFILENAME and DAYSTOKEEP values 
TO_DELETE="${BACKUPFILENAME}.$(date -d "${TIMESTAMP} - ${DAYSTOKEEP} days" +%Y-%m-%d)"  

# Check to see if the file we want to delete exists in the directory. 
# If not it will just exit. 
if [ -f ${DESTINATION}/${TO_DELETE} ]                            
	# A file older than the limit was found.
	then
		echo "Found a backup file older than ${DAYSTOKEEP} days..."
		echo "Deleting ${DESTINATION}/${TO_DELETE}..."
		unalias rm                         2> /dev/null
		rm ${DESTINATION}/${TO_DELETE}     2> /dev/null
		rm ${DESTINATION}/${TO_DELETE}.gz  2> /dev/null

	# No file older than the limit was found.
	else
		echo "No backup file older than ${DAYSTOKEEP} days were found."
fi

# === END TRMBS PROGRAM ===
echo "Ending The Rotating MySQL Backup Script."

