#!/bin/bash
#
# This script is intended to run on the ESX host with ghettoVCB.
# Further information can be found on https://www.virtualhacker.net
#
# Version 1.0
# Written by garandil
# Email garandil@virtualhacker.net 
# Fingerprint: =CD36 C244 2BB3 F83D 43FB  DB8F E5F7 1E08 1F7B 709D
###################################################################

# Setting variables
backupdir=/vmfs/volumes/NFS/ # Datastore/Directory for the backups (must match ghettoVCB config).
current=`date +%Y_%m_%d--%H-%M-%S` # Timeformat with : not good.
lastlog=`ls -ltr /tmp/ghetto* | tail -n 1 | awk '{print $9}'` # Get's the last logfile from the backup job.
backuptime=`grep 'Backup Duration' $lastlog | awk '{print $7,$8}' >> $backupdir/backuptimes-$current.txt` # Makes temporary file containing the backup times.
vms=`cat /vmlist >> $backupdir/backuplist-$current.txt` # Makes temporary file containing the list of VM's.
tempfile1=`ls -ltr $backupdir/backuplist-* | tail -n 1 | awk '{print $9}'` # Finding tempfile for backup list.
tempfile2=`ls -ltr $backupdir/backuptimes-* | tail -n 1 | awk '{print $9}'` # Finding tempfile for backup times.
# Making sure that the resultfile is present before proceeding:
touch $backupdir/backupinfo.txt
resultfile=$backupdir/backupinfo.txt
final=`cat $resultfile | tail -n 8`

echo -e '\n' >> $backupdir/backupinfo.txt
echo -e $current >> $backupdir/backupinfo.txt
echo -e "######################################################" >> $backupdir/backupinfo.txt
echo -e "VM Name:             Time elapsed:" >> $backupdir/backupinfo.txt
echo -e "------------------------------------------------------"
awk 'NR==FNR{a[i++]=$0};{b[x++]=$0;};{k=x-i};END{for(j=0;j<i;) print a[j++],b[k++]}' $tempfile1 $tempfile2 | awk '{ printf("%- 20s %- 20s\n", $1, $2, $3, $4); }' >> $resultfile # combining the results and setting pretty columns.
echo "DONE!"

# cleanup
rm $tempfile1
rm $tempfile2
