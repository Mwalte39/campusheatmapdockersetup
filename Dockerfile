FROM node:12.2.0

ENV PATH /app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY ./UI/ui-4155/ui4155/package.json /app/package.json
RUN npm install
RUN npm install -g @angular/cli@7.3.9

# add app
COPY ./UI/ui-4155/ui4155 /app

# start app
CMD ng serve
