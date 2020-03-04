#!/bin/bash
install_sf(){

	sed -i 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf
	sed -i 's|#baseurl=http://mirror.centos.org/centos|baseurl=http://mirrors.ocf.berkeley.edu/centos|' /etc/yum.repos.d/*.repo
	yum update -y
	
	yum install -y wget unzip socat java-1.8.0-openjdk-headless
	sed -i 's|#networkaddress.cache.ttl=-1|networkaddress.cache.ttl=10|' /usr/lib/jvm/jre/lib/security/java.security
	
	# Set up tomcat
	wget -q https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.30/bin/apache-tomcat-8.5.30.tar.gz && \
	     tar --strip-components=1 -xf apache-tomcat-8.5.30.tar.gz && \
	     rm -f apache-tomcat-8.5.30.tar.gz && \
	     rm -rf webapps && \
	     mkdir -p webapps/ROOT
	echo 'export CATALINA_OPTS="$CATALINA_OPTS -Xms64m -Xmx256m -XX:MaxPermSize=64m"' > /service/bin/setenv.sh

	# Set up microservice
	wget -q -O nfvo-multivimproxy.zip "https://nexus.onap.org/service/local/artifact/maven/redirect?r=snapshots&g=org.onap.vfc.nfvo.multivimproxy&a=vfc-nfvo-multivimproxy-deployment&v=LATEST&e=zip" && \
	     unzip -q -o -B nfvo-multivimproxy.zip && \
	     rm -f nfvo-multivimproxy.zip

	# Set permissions
	find . -type d -exec chmod o-w {} \;
	find . -name "*.sh" -exec chmod +x {} \;

}

add_user(){

	useradd onap
<<<<<<< HEAD
	yum -y install sudo
	chmod u+x /etc/sudoers
	sed -i '/Same thing without a password/a\onap    ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers
	chmod u-x /etc/sudoers
	chown onap:onap -R /service
}

clean_sf_cache(){
								
=======
	chown onap:onap -R /service
	chmod g+s /service
	setfacl -d --set u:onap:rwx /service

}

clean_sf_cache(){

>>>>>>> Remove sudo capability for onap user for VF-C multivimproxy docker
	yum clean all
}

install_sf
wait
add_user
clean_sf_cache
