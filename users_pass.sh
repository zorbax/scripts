#!bin/bash
#addgroup biote
set -e
us=`cat $1`

for i in $us
do
  tr -dc A-Za-z0-9_ < /dev/urandom | head -c 6 | xargs >>  passwords.txt
done

exec 3< $1
exec 4< passwords.txt

while read iuser <&3 && read ipasswd <&4 ; do
    printf "\tCreating user: %s with password: %s\n" $iuser $ipasswd
    #adduser $iuser biote
    #echo $ipasswd | passwd --stdin $iuser
    echo -e "$iuser\t$ipasswd" >> users_passwords.txt
done

rm passwords.txt

#awk -F':' '{ if ( $3 >= 1000 ) print $1 }' /etc/passwd | grep -v nobody



# note wild card allowed
_files="$HOME/zorbax/data/*fastq $HOME/zorbax/data/fasting_map_combine"
_users="$(awk -F':' '{ if ( $3 >= 500 ) print $1 }' /etc/passwd | grep -v nobody)"
for u in $_users
do
  for f in $_files
  do
     _dir="$HOME/${u}"
     if [ -d "$_dir" ]
     then
       /bin/cp -f "${f}" "$_dir"
       chown $(id -un $u):$(id -gn $u) "${_dir}/${f}"
     fi
  done
done

#userdel -r
