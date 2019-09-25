FROM node:12.2.0

# set working directory
WORKDIR /UI

# install and cache app dependencies
COPY package.json /UI/ui-4155/ui4155/package.json
RUN npm install
RUN npm install -g @angular/cli@7.3.9

# add app
COPY . /UI/ui-4155/ui4155

# start app
CMD ng serve
