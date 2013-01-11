#!/bin/sh
# ----------------------------------------------------------------------------
#  Copyright 2005-2009 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# ----------------------------------------------------------------------------
# Main Script for the Jaggery Server
#
# Environment Variable Prequisites
#
#   JAGGERY_HOME   Home of the Jaggery installation. If not set I will  try
#                   to figure it out.
#
# NOTE: Borrowed generously from Apache Tomcat startup scripts.
# -----------------------------------------------------------------------------
export JAVA_HOME=$(which java |xargs  readlink -f  | sed "s:bin/java::");
echo "Setting JAVA_HOME to $JAVA_HOME "
echo "Setting DB parametters"
# Parsing DB URL
proto="$(echo $DATABASE_URL | grep :// | sed -e's,^\(.*://\).*,\1,g')"
url=$(echo $DATABASE_URL | sed -e s,$proto,,g)
export dbusername="$(echo $url | grep : | cut -d: -f1)"
export dbpassword="$(echo $url | sed -e s,$dbusername:,,g  | grep @| cut -d@ -f1)"
export dbhostname=$(echo $url | sed -e s,$dbusername:$dbpassword@,,g | cut -d: -f1)
export dbport=$(echo $url | sed -e s,$dbusername:$dbpassword@,,g | cut -d: -f2| cut -d/ -f1)
export dbname="$(echo $url | grep / | cut -d/ -f2-)"
export dbtype="postgresql";
export dbdriver="org.postgresql.Driver";




# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '.*/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

# Get standard environment variables
PRGDIR=`dirname "$PRG"`

# Only set CARBON_HOME if not already set
[ -z "$JAGGERY_HOME" ] && JAGGERY_HOME=`cd "$PRGDIR/.." ; pwd`

export JAGGERY_HOME=$JAGGERY_HOME
sh $JAGGERY_HOME/carbon/bin/wso2server.sh "$@"
