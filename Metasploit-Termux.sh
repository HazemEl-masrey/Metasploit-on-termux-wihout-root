#!/data/data/com.termux/files/usr/bin/bash -e
#Copyright ©2020 by Hazem El-masrey. All rights reserved.
# made by : Hazem El-masrey
#Youtube channel : https://m.youtube.com/c/HazemElmasrey
apt update -y
apt upgrade -y
termux-setup-storage
apt install wget -y
clear
sleep 5
# colors

red='\033[1;31m'
yellow='\033[1;33m'
blue='\033[1;34m'
reset='\033[0m'


# Metasploit version
msf_ver=5.0.40

printf "$\n{yellow}[=]WAIT UNTIL INSTALLING............${reset}\n" 
sleep 5
pkg install -y autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ruby ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config
pkg upgrade -y


printf "$\n{green}[=]Fix ruby BigDecimal.....${reset}\n"
source <(curl -L https://github.com/termux/termux-packages/files/2912002/fix-ruby-bigdecimal.sh.txt)

printf -e "$\n{green}[=]\nDownloading & Extracting.....${reset}\n"

cd $HOME
curl -LO https://github.com/rapid7/metasploit-framework/archive/$msf_ver.tar.gz
tar -xf $HOME/$msf_ver.tar.gz

printf "$\n{blue}[=]Erasing old metasploit folder.....${reset}\n"
rm -rf $HOME/metasploit-framework
mv $HOME/metasploit-framework-$msf_ver $HOME/metasploit-framework
rm $HOME/$msf_ver.tar.gz
cd $HOME/metasploit-framework
sed  /rbnacl/d  -i Gemfile.lock
sed  /rbnacl/d  -i metasploit-framework.gemspec
gem install bundler
sed  s|nokogiri (1.*)|nokogiri (1.8.0)|g  -i Gemfile.lock

gem install nokogiri -v 1.8.0 -- --use-system-libraries
 
#sed  s|grpc (.*|grpc (1.4.1)|g  -i $HOME/metasploit-framework/Gemfile.lock
#gem unpack grpc -v 1.4.1
#cd grpc-1.4.1
#curl -LO https://raw.githubusercontent.com/grpc/grpc/v1.4.1/grpc.gemspec
#curl -L https://raw.githubusercontent.com/Hax4us/Hax4us.github.io/master/extconf.patch
#patch -p1 < extconf.patch
#gem build grpc.gemspec
#gem install grpc-1.4.1.gem
#cd ..
#rm -r grpc-1.4.1


cd $HOME/metasploit-framework
gem install actionpack
bundle update activesupport
bundle install -j5
$PREFIX/bin/find -type f -executable -exec termux-fix-shebang \{\} \;
rm ./modules/auxiliary/gather/http_pdf_authors.rb
if [ -e $PREFIX/bin/msfconsole ];then
	rm $PREFIX/bin/msfconsole
fi
if [ -e $PREFIX/bin/msfvenom ];then
	rm $PREFIX/bin/msfvenom
fi
ln -s $HOME/metasploit-framework/msfconsole /data/data/com.termux/files/usr/bin/
ln -s $HOME/metasploit-framework/msfvenom /data/data/com.termux/files/usr/bin/
termux-elf-cleaner /data/data/com.termux/files/usr/lib/ruby/gems/2.4.0/gems/pg-0.20.0/lib/pg_ext.so
printf "$\n{blue}[=]Creating database${reset}\n"

cd $HOME/metasploit-framework/config
curl -LO https://raw.githubusercontent.com/gushmazuko/metasploit_in_termux/master/database.yml

mkdir -p $PREFIX/var/lib/postgresql
initdb $PREFIX/var/lib/postgresql

pg_ctl -D $PREFIX/var/lib/postgresql start
createuser msf
createdb msf_database

cd $HOME
curl -LO https://raw.githubusercontent.com/gushmazuko/metasploit_in_termux/master/postgresql_ctl.sh
chmod +x postgresql_ctl.sh


printf "$\n{blue} [*] Configuring Metasploit For You ...\n"
printf "$\n{blue} [*] to start metasploit type msfconsole\n"
finalwork
printline
printf "\n${yellow} Now you can enjoy with Metasploit in your Termux without root :)\n Don't forget to star my work\n"
printline
printline
printf "\n${blue} [*] From   :${yellow}    Made By Hazem El-masrey\n"
printf "$\n{blue} [*] YouTube :${yellow}    https://m.youtube.com/c/HazemElmasrey\n"
printline
printf "${red} \n NOTE : $yellow use ${red}--uninstall${yellow} option for uninstall\n"
printline
printf "$reset"
