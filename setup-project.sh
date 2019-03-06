#!/usr/bin/env bash

usage="$(basename "$0")

    -h show this help text
    -a artifact ID
    -g group ID
    -n application name
    -p add puppet config 
    -d add docker config
    -t packaging type jar / war
    -r place application in existing repo folder

    Examples:

    -- Create jar app with puppet and docker:

    ./eid-application-template/setup-project.sh -pd -t jar -a serviceprovider-admin -g no.difi -n serviceprovider-admin  

    -- Create war app with in existing folder:
     
    ./eid-application-template/setup-project.sh -t war -a serviceprovider-admin -g no.difi -n serviceprovider-admin -r eid-serviceprovider-admin 

    -- Create jar app:

    ./eid-application-template/setup-project.sh -t jar -a serviceprovider-admin -g no.difi -n serviceprovider-admin 

"

while getopts "r:a:g:n:t:pdmh" opt; do
  case ${opt} in
    h)
      echo "$usage"
      exit
      ;;
    a ) 
      artifactId=$OPTARG
      ;;
    g )
      groupId=$OPTARG 
      ;;
    n ) 
      app_name=$OPTARG
      ;;
    p ) 
      puppet_set=true
      ;;
    d )
      docker_set=true
      ;;
    t )
      packaging=$OPTARG
      ;;  
    r ) 
      repo_dir=$OPTARG
      ;;
    \? ) echo "Usage: cmd [-a <artifactId>] [-g <groupId>] [-n <name>]"
         exit 1
      ;;
  esac
done
shift $((OPTIND -1))

GREEN='\033[0;32m'
NC='\033[0m'


log() {
printf "${GREEN} OK ${NC} $1"
}

if [ ! -z $repo_dir ]; then
  app_dir="$repo_dir/"
  baseDir=$app_name
else
  app_dir="$app_name/"
fi

mkdir -p $app_dir && log "Created dir $app_dir as application directory \n" || exit $?

curl -s https://start.spring.io/starter.tgz -d groupId=$groupId -d artifactId=$artifactId -d packaging=$packaging -d version=DEV-SNAPSHOT -d dependencies=actuator,web -d language=java -d baseDir=$baseDir -d type=maven-project -d name=$app_name | tar -xzf - -C $app_dir && log "Extracted project: $app_dir\n" || exit $?

baseDir="$baseDir/"

dir_path=`find ${app_dir}${baseDir} -name *Application.java -printf '%h\n'`

sed -i '/<build>/a \\t\t<finalName>${project.artifactId}</finalName>' ${app_dir}${baseDir}/pom.xml

if [ "$puppet_set" = true ]; then
 
 echo "Copying puppet_modules and puppet_hiera to $app_dir"	
 puppet_module_name=${app_name//-/_}

 cp -r  dev-utils/templates/puppet/* $app_dir/

 mv $app_dir/puppet_modules/placeholder_puppet_module/ $app_dir/puppet_modules/$puppet_module_name/
 mv $app_dir/puppet_hiera/nodes/ondemand/placeholder-app-name.yaml $app_dir/puppet_hiera/nodes/ondemand/$app_name.yaml
 mv $app_dir/puppet_modules/$puppet_module_name/templates/placeholder-artifact-name.conf.erb $app_dir/puppet_modules/$puppet_module_name/templates/$artifactId.conf.erb

fi

if [ "$docker_set" = true ]; then

  echo "Copying docker folder to $app_dir"
  cp -r  dev-utils/templates/docker $app_dir/
  mv $app_dir/docker/placeholder-app-name/ $app_dir/docker/$app_name/
  mv $app_dir/docker/$app_name/placeholder-packaging $app_dir/docker/$app_name/$packaging

fi

echo "Creating folders actuator, health, log, service, config, domain in $dir_path"
mkdir -p $dir_path/{actuator,health,log,service,config,domain}

rm ${app_dir}${baseDir}src/main/resources/application.properties

cp eid-application-template/templates/java/application.yml.template ${app_dir}${baseDir}src/main/resources/application.yml

echo "Replacing all placeholder names with '$app_name'"

find $app_dir/ -type f -exec sed -i -e "s/placeholder-app-name/$app_name/g" {} \; -exec sed -i -e "s/placeholder_puppet_module/$puppet_module_name/g" {} \; -exec sed -i -e "s/placeholder-artifact-name/$artifactId/g" {} \; -exec sed -i -e "s/placeholder-group-id/$groupId/g" {} \; -exec sed -i -e "s/placeholder-packaging/$packaging/g" {} \;

cp eid-application-template/templates/java/actuator/*  $dir_path/actuator/

artifactId=${artifactId//-/}

sed -i '1 i\package '"$groupId"'.'"$artifactId"'.actuator;' $dir_path/actuator/VersionEndpoint.java $dir_path/actuator/InfoEndpointExtension.java

cd ${app_dir}${baseDir}
mvn clean install
