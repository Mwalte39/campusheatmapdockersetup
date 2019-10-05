### STAGE 1: Build ###

# We label our stage as â€˜builderâ€™
FROM node:10-alpine as builder

COPY ./UI/ui-4155/ui4155/angular-client/package.json ./UI/ui-4155/ui4155/angular-client/package-lock.json ./

## Storing node modules on a separate layer will prevent unnecessary npm installs at each build

RUN npm ci && mkdir /ng-app && mv ./node_modules ./ng-app

WORKDIR /ng-app

COPY ./UI/ui-4155/ui4155/angular-client .

## Build the angular app in production mode and store the artifacts in dist folder

RUN npm run ng build -- --prod --output-path=dist


### STAGE 2: Setup ###

FROM nginx:1.14.1-alpine

## Copy our default nginx config
COPY ./UI/ui-4155/ui4155/angular-client/nginx/default.conf /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From â€˜builderâ€™ stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /ng-app/dist /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
