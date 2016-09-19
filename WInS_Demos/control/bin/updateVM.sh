#!/bin/bash

JAVA_VERSION=`java -version 2>&1 |awk 'NR==1{ gsub(/"/,""); print $3 }'`

if [ $JAVA_VERSION == "1.8.0_60" ]
then
    echo "Default Java version: $JAVA_VERSION"
else
    sudo update-alternatives --set java /usr/java/jdk1.8.0_60/jre/bin/java
    JAVA_VERSION=`java -version 2>&1 |awk 'NR==1{ gsub(/"/,""); print $3 }'`
    echo "Default Java version fixed to: $JAVA_VERSION"
fi

echo "========================================"
echo "Update Firefox TLS setting"
FFPROFILE_FOLDER=$(cat ~/.mozilla/firefox/profiles.ini | grep Path | sed s/^Path=//)

USERJS_FILE=~/.mozilla/firefox/$FFPROFILE_FOLDER/user.js
USERJS_CONTENT="user_pref(\"security.tls.version.max\", 3);"

grepresult=$(grep -c "$USERJS_CONTENT" $USERJS_FILE -s)

if [ -f $USERJS_FILE ] && [ $grepresult == 1 ]
then
    # property already overrided
    echo "Firefox TLS setting is correct."
else
    # property not yet overrided
    echo $USERJS_CONTENT >> $USERJS_FILE
    echo "Firefox TLS setting has been updated."
fi

echo "========================================"

if [ -d /u01/python/ ] 
then
  echo "Python 3.5.2 is already installed."
else
  echo "Install Python prerequisites..."
  
  sudo /u01/content/weblogic-innovation-seminars/WInS_Demos/control/bin/sudo1.sh
  
  echo "Install Python 3.5.2"
  
  GIT_SYSTEM_PROXY_CHECK=`git config --get --system http.proxy`
  if [ -n "$GIT_SYSTEM_PROXY_CHECK" ]; then
    export http_proxy=$GIT_SYSTEM_PROXY_CHECK
    export https_proxy=$GIT_SYSTEM_PROXY_CHECK
    echo "http_proxy=$http_proxy"
    echo "https_proxy=$https_proxy"
  else
    unset http_proxy
    unset https_proxy
    echo "http_proxy=$http_proxy"
    echo "https_proxy=$https_proxy"
  fi
  
  wget --no-check-certificate  -P /u01/ https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz
    
  cd /u01
  
  tar -xzf Python-3.5.2.tgz

  mkdir /u01/python
  cd Python-3.5.2
 
  ./configure --prefix=/u01/python
  make
  sudo make install
  
  sleep 3
  
  sudo rm -rf /u01/Python-3.5.2
  sudo rm -f Python-3.5.2.tgz
  
  export PATH=/u01/python/bin:$PATH
  
  echo "Python 3.5.2 has been installed"
fi

echo "========================================"

chmod 600 /u01/content/weblogic-innovation-seminars/cloud.demos/pk.openssh

echo "========================================"

echo "Oracle Proxy settings has been changed. Please run again Oracle Proxy ON/OFF on the desktop depending on your network connection."
echo "Everything is up to date!"