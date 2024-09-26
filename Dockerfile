FROM nginx
# 
# wget -O - http://installrepo.kaltura.org/repo/apt/debian/kaltura-deb-curr.gpg.key|apt-key add -
# echo "deb [arch=amd64] http://installrepo.kaltura.org/repo/apt/debian propus main" > /etc/apt/sources.list.d/kaltura.list
RUN apt-get update && apt-get install -y wget
RUN apt-get update && apt-get install -y gnupg gnupg2 gnupg1 
RUN wget -O - http://installrepo.kaltura.org/repo/apt/debian/kaltura-deb-curr.gpg.key|apt-key add -
RUN echo "deb [arch=amd64] http://installrepo.kaltura.org/repo/apt/debian propus main" > /etc/apt/sources.list.d/kaltura.list
# 0.622 Resolving installrepo.kaltura.org (installrepo.kaltura.org)... E: gnupg, gnupg2 and gnupg1 do not seem to be installed, but one of them is required for this operation                                                                                        
RUN apt-get update && apt-get install -y kaltura-nginx

